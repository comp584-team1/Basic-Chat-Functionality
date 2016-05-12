-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: chatdb
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `messages`
--
USE chatdb;
DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `msg_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `time_utc` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `msg_body` varchar(1000) NOT NULL,
  PRIMARY KEY (`msg_id`),
  KEY `room_id` (`room_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (4,1,1460843324,1,'hello, my old friend'),(5,1,1460843491,1,'hello, it is good to see you'),(8,1,1460843810,1,'trying to send in a message from outer space'),(9,1,1460843924,1,'it seems to be starting to work better'),(10,1,1460844208,1,'Sup, B?!'),(11,1,1460844546,1,'retry with global db connection'),(12,1,1460845912,1,'yo, this is cool, yo!'),(13,1,1460846023,1,'please don\'t crash again'),(14,1,1460846760,1,'cheah buddy!'),(15,1,1460846886,1,'Hi, honey!'),(16,1,1460846903,1,'yo'),(17,1,1460925419,1,'I guess I\'ll try sending in another message now.'),(18,1,1460925433,1,'Is it working?'),(19,1,1460925436,1,'Gosh, I sure hope so.'),(20,1,1460925440,1,''),(21,1,1460925442,1,'yeah...'),(22,1,1460926709,1,'try a new message'),(23,1,1460926839,1,'Keep pushing new mesages and see what happen!'),(24,1,1460926850,1,'it not work ver good'),(25,1,1460927027,1,'ohhh, now it work better?'),(26,1,1460927039,1,'cheah buddy!  gotta be usin\' dat bidniss!  it be workin da bombist!'),(27,1,1460927045,1,'nevermind it failed now'),(28,1,1460927051,1,'now it\'s cailing fconatstnacly'),(29,1,1460927054,1,'stopped working'),(30,1,1460927078,1,'why did it ... oh'),(31,1,1460927086,1,'wait so is it working now or what?'),(32,1,1460927089,1,'i\'m so confused'),(33,1,1460927098,1,'it seems to be working, but it\'s not?  I don\'t know how to tell if it\'s working'),(34,1,1460927103,1,'it\'s just working now?'),(35,1,1460927109,1,'what about now?'),(36,1,1460927116,1,'broken now?'),(37,1,1460927248,1,'how about now?'),(38,1,1460927251,1,'scrolling working?'),(39,1,1460927256,1,'and now?'),(40,1,1460927260,1,'ahhh much better'),(41,1,1460927270,1,'i\'ll try it now with a longer string to see if it continutes to working'),(42,1,1460927272,1,'and it do!'),(43,1,1460927274,1,'yay'),(44,1,1460928700,1,'whoopdie doozle!'),(45,1,1460929383,1,'blah'),(46,1,1460929440,1,'Yeah!'),(47,1,1460932442,1,'birch'),(48,1,1460932473,1,'yeah now i can send again?'),(49,1,1460932710,1,'yeah!!!'),(50,1,1460933747,1,'message in, output out!'),(51,1,1460959559,1,'testing 1 2 3 4'),(52,1,1460959652,1,'hello greedo'),(53,1,1460959666,1,'heheh it\'s really working!'),(55,1,1460960258,1,'i\'m sending message como un jefe'),(56,1,1460960274,1,'but not if they\'re blank (yay)'),(57,1,1460963828,1,'new message now'),(58,1,1460964353,1,'let\'s see what happens now'),(59,1,1460964358,1,'looking good so far'),(60,1,1460964371,1,'what if window is scrolled away when i enter a messsage?'),(61,1,1460964503,1,'add a line'),(62,1,1460964517,1,'now add a mega huge line, and see what happens with that!'),(63,1,1460965071,1,'this should still work'),(64,1,1460965305,1,'look out, here comes a flurry of silly messages to share with you');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pm_msgs`
--

DROP TABLE IF EXISTS `pm_msgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm_msgs` (
  `pm_id` int(11) NOT NULL AUTO_INCREMENT,
  `pm_room_id` int(11) NOT NULL,
  `time_utc` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`pm_id`),
  KEY `pm_room_id` (`pm_room_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `pm_msgs_ibfk_1` FOREIGN KEY (`pm_room_id`) REFERENCES `pm_rooms` (`pm_room_id`),
  CONSTRAINT `pm_msgs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pm_msgs`
--

LOCK TABLES `pm_msgs` WRITE;
/*!40000 ALTER TABLE `pm_msgs` DISABLE KEYS */;
/*!40000 ALTER TABLE `pm_msgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pm_rooms`
--

DROP TABLE IF EXISTS `pm_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pm_rooms` (
  `pm_room_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id_a` int(11) NOT NULL,
  `user_id_b` int(11) NOT NULL,
  PRIMARY KEY (`pm_room_id`),
  KEY `user_id_a` (`user_id_a`),
  KEY `user_id_b` (`user_id_b`),
  CONSTRAINT `pm_rooms_ibfk_1` FOREIGN KEY (`user_id_a`) REFERENCES `users` (`user_id`),
  CONSTRAINT `pm_rooms_ibfk_2` FOREIGN KEY (`user_id_b`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pm_rooms`
--

LOCK TABLES `pm_rooms` WRITE;
/*!40000 ALTER TABLE `pm_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `pm_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(30) NOT NULL,
  `recentest` int(11) NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'test',1460843194),(2,'other',1460927593);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(30) NOT NULL,
  `password` char(30) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test','test');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-24 12:49:30
