#!/bin/bash

# This script generates a pkcs12 file for a network element
# It works by replacing the variables in the baseNE.cnf with 
# the command line parameters to this script. 
#
# Input: (each input replaces the indicated variable)
#   $1 - NE_COMMONNAME
#   $2 - NE_UNSTRUCTUREDNAME
#   $3 - NE_IPADDR
#   $4 - NE_DNSNAME
#   $5, the base name of the pkcs12 file to output (no extension)
#   $6, the password for the .key file and .p12 file
#
# Security issues:
#	1) The client's "private" key is generated out here and 
#	is stored in the .con file.
#	2) The CA used is an "openssl ca". Management of this 
#	CA is very minimal.
#   3) This script is directly accessing the CA private key 
#   4) The CA private key isn't stored in a secure location
#   5) The NE private key is stored in /tmp (encrypted)
#
# The intention here is to provide a minimal CA sufficient for
# test and development purposes. These scripts can be used for 
# testing deployments but should not be used for a production
# environment.

# TODO: determine the installation strategy for this scipt bundle and address
# In the meantime use the suggestion from here about how to access our bundle's include files
# http://mywiki.wooledge.org/BashFAQ/028
. ${BASH_SOURCE%/*}/common.sh

usage ()
{
    echo "Usage example:"
    echo "createNEp12.sh -cn router1 -ip 10.10.10.1 -out file.p12 -pass 123"
    echo "Input:"
    echo "NOTE: This script requires something in the subjectname and subjectaltname"
    echo " -cn <subjectname common name>"
    echo " -un <subjectname unstructured name>"
    echo " -ip <subjectaltname iPAddress>"
    echo " -dns <subjectaltname dnsNAme>"
    echo "Output:"
    echo " -out <pkcs12 file name>"
    echo " -pass <key encryption password>"    
    echo "" 
    echo "You probably want to import the p12 file to your network element"
    echo "The 3node .virl and config files provides an example of how to do this"
    exit 255
}

if [ "$#" -lt 2 ]
then
    usage
fi

while [ "$1" != "" ]; do
    case $1 in
        -cn )   shift
                NE_COMMONNAME=$1
                ;;
        -un )   shift
                NE_UNSTRUCTUREDNAME=$1
                ;;
        -ip )   shift
                NE_IPADDR=$1
                ;;
        -dns )  shift
                NE_DNSNAME=$1
                ;;
        -out ) shift
               OUTP12=$1
               ;;
        -pass ) shift
               PASSWORD=$1
               ;;
        *) 
            usage
            ;;
    esac
    shift
done

if [[ -z "$OUTP12" ]]
then
    echo "ERROR: output file not specified."
    usage
fi

if [[ -z "$PASSWORD" ]]
then 
    echo "ERROR: password for key encryption not specified."
    usage
fi   

# TODO: see "apply_variable" for how to remove these limitations
if [[ -z "$NE_DNSNAME" && -z "$NE_IPADDR" ]]
then
    echo "ERROR: A subjectaltname value (DNSname or IPaddr) MUST be set."
    echo "(This is a script limitation not a PKI limitation)"
    usage
fi
if [[ -z "$NE_COMMONNAME" && -z "$NE_UNSTRUCTUREDNAME" ]]
then
    echo "ERROR: A subjectname value (CommonName or UnstructuredName) MUST be set."
    echo "(This is a script limitation not a PKI limitation)"
    usage
fi

# temp files (errors leak these files)
TMP_CONF="$(mktemp)"
cp $BASECLIENT_CONF $TMP_CONF
TMP_REQ="$(mktemp)"
TMP_KEY="$(mktemp)"
TMP_CRT="$(mktemp)"
TMP_BUNDLE="$(mktemp)"

echo "Applying parameter settings to config file:" 
apply_variable () 
{
  CONF=$1
  VAR=$2
  VAL=$3
  
  # apply or erase the template line
  # TODO: This is a simplistic approach. If the last entry in a section
  # is removed then the whole section needs to go. That is possible but doesn't
  # seem worth coding up yet. For now the usage checks prevent errors of this type.
  if [[ -z "$VAL" ]]
  then
    echo "Removing $VAR (no value supplied)"
    sed -i "/$VAR/d" $CONF
  else
    echo "Applying $VAL to $VAR" 
    sed -i "s/$VAR/$VAL/g" $CONF
  fi
}
apply_variable $TMP_CONF NE_COMMONNAME $NE_COMMONNAME
apply_variable $TMP_CONF NE_UNSTRUCTUREDNAME $NE_UNSTRUCTUREDNAME
apply_variable $TMP_CONF NE_IPADDR $NE_IPADDR
apply_variable $TMP_CONF NE_DNSNAME $NE_DNSNAME

echo "Generating client req"
openssl req -config $TMP_CONF -new -out $TMP_REQ -passout pass:${PASSWORD} -keyout $TMP_KEY 
iferrorlogandexit "Unable to create enrollment req" 1

#various methods of displaying the request
#openssl req -in onepkClients/${OUTPUTBASE}.req -text
#openssl asn1parse -in ${OUTPUTBASE}.req
#iferrorlogandexit "Unable to asn1parse client req" 1
#openssl req -in ${OUTPUTBASE}.req -text
#iferrorlogandexit "Unable to dump client req" 1

echo "Signing the request by the CA"
openssl ca -config $SIMPLECA_CONF -cert $CA_CERT -keyfile $CA_PRIVKEY -in $TMP_REQ -out $TMP_CRT -batch -notext
iferrorlogandexit "Unable to sign client cert" 1

echo "This is the cert generated:"
openssl x509 -in $TMP_CRT -text
iferrorlogandexit "Unable to display the client cert" 1

# create the pkcs12
cat $CA_CERT > $TMP_BUNDLE
cat $TMP_KEY >> $TMP_BUNDLE
cat $TMP_CRT >> $TMP_BUNDLE
openssl pkcs12 -export -in $TMP_BUNDLE -passin pass:${PASSWORD} -passout pass:${PASSWORD} -out $OUTP12
iferrorlogandexit "Unable to create the pkcs12 file" 1

# cleanup temp files
rm $TMP_CONF
rm $TMP_REQ
rm $TMP_KEY
rm $TMP_CRT
rm $TMP_BUNDLE
