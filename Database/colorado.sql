-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2
-- http://www.phpmyadmin.net
--
-- Hostiteľ: localhost
-- Vygenerované: Ned 27.Sep 2015, 16:28
-- Verzia serveru: 5.5.37
-- Verzia PHP: 5.4.4-14+deb7u11

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databáza: `colorado`
--

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Dashboards`
--

DROP TABLE IF EXISTS `Dashboards`;
CREATE TABLE IF NOT EXISTS `Dashboards` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `Src` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `DnsAnalyzerDatas`
--

DROP TABLE IF EXISTS `DnsAnalyzerDatas`;
CREATE TABLE IF NOT EXISTS `DnsAnalyzerDatas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `SrcIp` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `DstIp` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `SrcPort` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `DstPort` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `DomainName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `DateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=18 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `DnsResponseAddresses`
--

DROP TABLE IF EXISTS `DnsResponseAddresses`;
CREATE TABLE IF NOT EXISTS `DnsResponseAddresses` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IpAddress` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `DnsAnalyzerDataId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_DnsAnalyzerData_Id` (`DnsAnalyzerDataId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `DnsTrackedDomains`
--

DROP TABLE IF EXISTS `DnsTrackedDomains`;
CREATE TABLE IF NOT EXISTS `DnsTrackedDomains` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DomainExpression` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `DomainStatus` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `DomainExpression` (`DomainExpression`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `HttpAnalyzerDatas`
--

DROP TABLE IF EXISTS `HttpAnalyzerDatas`;
CREATE TABLE IF NOT EXISTS `HttpAnalyzerDatas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `SourceIp` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `DestinationIp` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `Method` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `Quantity` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=5 ;

--
-- Obmedzenie pre exportované tabuľky
--

--
-- Obmedzenie pre tabuľku `DnsResponseAddresses`
--
ALTER TABLE `DnsResponseAddresses`
  ADD CONSTRAINT `DnsResponseAddresses_ibfk_1` FOREIGN KEY (`DnsAnalyzerDataId`) REFERENCES `DnsAnalyzerDatas` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;
SET FOREIGN_KEY_CHECKS=1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
