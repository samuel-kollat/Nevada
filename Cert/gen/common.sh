
# TODO: determine the installation strategy for this scipt bundle and address
# In the meantime we're:
#   Keeping track of our script bundle using ${BASH_SOURCE}
#   Hardcoding the simpleCA database directories into ${HOME}/.simpleCA
# One could install the scripts into .simpleCA or keep them in /usr/share
# http://mywiki.wooledge.org/BashFAQ/028
# Uses of "${BASH_SOURCE%/*}" below are indicative of this area that could be improved
BUNDLE_DIR=${BASH_SOURCE%/*}
SIMPLECA_DIR=${BUNDLE_DIR}

# common variables for the CA configuration files
# TODO: copy base cnf files to SIMPLECA_DIR
SIMPLECA_CONF=${BUNDLE_DIR}/simpleCA.cnf 
BASECLIENT_CONF=${BUNDLE_DIR}/baseNE.cnf

# these variables MUST match their corresponding values in $SIMPLECA_CONF
CA_DIR=${SIMPLECA_DIR}/dbCA
CA_INDEX=$CA_DIR/index.txt
CA_NEWCERTSDIR=$CA_DIR/newcerts
CA_CERT=$CA_DIR/cacert.crt
CA_SERIAL=$CA_DIR/serial
CA_PRIVKEY=$CA_DIR/cacert.key

CLIENTS_DIR=${SIMPLECA_DIR}/dbNE

# helper functions
function iferrorlogandexit ()
{
    if [ $? -ne 0 ] ; then
    echo "##### FAIL #####"
    echo "$1" "$2"
    exit $2
    fi
}

