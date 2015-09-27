-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2
-- http://www.phpmyadmin.net
--
-- Hostiteľ: localhost
-- Vygenerované: Ned 27.Sep 2015, 16:27
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
-- Databáza: `tahoe`
--

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `AccessLists`
--

DROP TABLE IF EXISTS `AccessLists`;
CREATE TABLE IF NOT EXISTS `AccessLists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `action` int(11) NOT NULL,
  `protocol` varchar(32) DEFAULT NULL,
  `ip_source` int(11) NOT NULL,
  `ip_destination` int(11) NOT NULL,
  `ttl` int(11) DEFAULT NULL,
  `filter_id` int(11) NOT NULL,
  `pn_source` int(11) NOT NULL,
  `pn_destination` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_access_list_ip_networks_idx` (`ip_source`),
  KEY `fk_access_list_ip_networks1_idx` (`ip_destination`),
  KEY `fk_access_list_filter1_idx` (`filter_id`),
  KEY `fk_access_list_ports1_idx` (`pn_source`),
  KEY `fk_access_list_ports2_idx` (`pn_destination`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Analyzers`
--

DROP TABLE IF EXISTS `Analyzers`;
CREATE TABLE IF NOT EXISTS `Analyzers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `src` varchar(128) DEFAULT NULL,
  `args` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Applications`
--

DROP TABLE IF EXISTS `Applications`;
CREATE TABLE IF NOT EXISTS `Applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `active_flag` tinyint(1) DEFAULT NULL,
  `certificate_id` int(11) NOT NULL,
  `analyzer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_application_certificates1_idx` (`certificate_id`),
  KEY `fk_application_analyzer1_idx` (`analyzer_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `application_config`
--

DROP TABLE IF EXISTS `application_config`;
CREATE TABLE IF NOT EXISTS `application_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `config_name` varchar(255) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Certificates`
--

DROP TABLE IF EXISTS `Certificates`;
CREATE TABLE IF NOT EXISTS `Certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `root_cert_path` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `FilterHasNbarProtocols`
--

DROP TABLE IF EXISTS `FilterHasNbarProtocols`;
CREATE TABLE IF NOT EXISTS `FilterHasNbarProtocols` (
  `filter_id` int(11) NOT NULL,
  `nbar_protocol_id` int(11) NOT NULL,
  PRIMARY KEY (`filter_id`,`nbar_protocol_id`),
  KEY `fk_filter_has_nbar_protocol_nbar_protocol1_idx` (`nbar_protocol_id`),
  KEY `fk_filter_has_nbar_protocol_filter1_idx` (`filter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Filters`
--

DROP TABLE IF EXISTS `Filters`;
CREATE TABLE IF NOT EXISTS `Filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  `application_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_policy_map_policy_map1_idx` (`application_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `interface_list`
--

DROP TABLE IF EXISTS `interface_list`;
CREATE TABLE IF NOT EXISTS `interface_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intf_name` varchar(100) DEFAULT NULL,
  `intf_type` varchar(100) DEFAULT NULL,
  `router_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_interface_list_router1_idx` (`router_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `IpNetworks`
--

DROP TABLE IF EXISTS `IpNetworks`;
CREATE TABLE IF NOT EXISTS `IpNetworks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(45) DEFAULT NULL,
  `mask` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `NbarProtocols`
--

DROP TABLE IF EXISTS `NbarProtocols`;
CREATE TABLE IF NOT EXISTS `NbarProtocols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protocol_name` varchar(45) DEFAULT NULL,
  `protocol_description` varchar(255) DEFAULT NULL,
  `protocol_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Ports`
--

DROP TABLE IF EXISTS `Ports`;
CREATE TABLE IF NOT EXISTS `Ports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `greater_or_equal` int(11) DEFAULT NULL,
  `less_or_equal` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `Routers`
--

DROP TABLE IF EXISTS `Routers`;
CREATE TABLE IF NOT EXISTS `Routers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `management_ip` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `application_id` int(11) NOT NULL,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `interfaces` text,
  PRIMARY KEY (`id`),
  KEY `fk_router_application1_idx` (`application_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Obmedzenie pre exportované tabuľky
--

--
-- Obmedzenie pre tabuľku `AccessLists`
--
ALTER TABLE `AccessLists`
  ADD CONSTRAINT `fk_access_list_filter1` FOREIGN KEY (`filter_id`) REFERENCES `Filters` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_access_list_ip_networks` FOREIGN KEY (`ip_source`) REFERENCES `IpNetworks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_access_list_ip_networks1` FOREIGN KEY (`ip_destination`) REFERENCES `IpNetworks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_access_list_ports1` FOREIGN KEY (`pn_source`) REFERENCES `Ports` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_access_list_ports2` FOREIGN KEY (`pn_destination`) REFERENCES `Ports` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `Applications`
--
ALTER TABLE `Applications`
  ADD CONSTRAINT `fk_application_analyzer1` FOREIGN KEY (`analyzer_id`) REFERENCES `Analyzers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_application_certificates1` FOREIGN KEY (`certificate_id`) REFERENCES `Certificates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `FilterHasNbarProtocols`
--
ALTER TABLE `FilterHasNbarProtocols`
  ADD CONSTRAINT `fk_filter_has_nbar_protocol_filter1` FOREIGN KEY (`filter_id`) REFERENCES `Filters` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_filter_has_nbar_protocol_nbar_protocol1` FOREIGN KEY (`nbar_protocol_id`) REFERENCES `NbarProtocols` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `Filters`
--
ALTER TABLE `Filters`
  ADD CONSTRAINT `fk_policy_map_policy_map1` FOREIGN KEY (`application_id`) REFERENCES `Applications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `interface_list`
--
ALTER TABLE `interface_list`
  ADD CONSTRAINT `fk_interface_list_router1` FOREIGN KEY (`router_id`) REFERENCES `Routers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `Routers`
--
ALTER TABLE `Routers`
  ADD CONSTRAINT `fk_router_application1` FOREIGN KEY (`application_id`) REFERENCES `Applications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
