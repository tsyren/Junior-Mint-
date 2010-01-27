-- MySQL dump 10.11
--
-- Host: localhost    Database: nsu2_dev
-- ------------------------------------------------------
-- Server version	5.0.32-Debian_7etch8-log

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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `password_reset_code` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `searchable` text,
  `identity_url` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nsu1team@gmail.com','Цырен','Очиров','75138015839c1380d7b742c68ad2d69797819c54','025212fa5b0730bd580f1bf8fecb3ad23cdea7d0',NULL,'2008-12-06 21:21:13','2009-02-24 09:17:27',NULL,NULL,NULL,NULL,'2008-12-06 21:22:36','цырен очиров',NULL),(2,'kmelnikov@gmail.com','Константин','Мельников','b2a55647078d8fd666186651d8b15ef59adf2f39','574f8b08ab119bb74d7693d1b9ea68689c1102b0',NULL,'2008-12-09 19:08:27','2009-02-02 11:59:35',NULL,NULL,NULL,NULL,'2008-12-09 19:08:40','константин мельников',NULL),(3,'loriochar@gmail.com','Alexei','Char','c4edacee34f21ab64b146529295d58f687913f48','f10eeaa20d77ca6babfe3850993b0c0bf180b49b',NULL,'2008-12-10 07:27:06','2009-01-20 21:02:40',NULL,'4886fa7ad79fd7a2b86db14d1146ce5e3b743008','2009-01-18 06:03:06',NULL,'2008-12-10 07:28:20','alexei char',NULL),(4,'the.nimble@gmail.com','Максим','Савельев','9dbfec9f52363e448847ac9b629643686ae8e62a','dd7571e5239862b4df955a85f03a8f8af13eb206',NULL,'2008-12-13 16:48:29','2009-02-23 20:36:40',NULL,NULL,NULL,NULL,'2008-12-13 17:11:11','максим савельев',NULL),(5,'strange.live@gmail.com','K','M','47840c81b5cae1bace1506089e20ef297b9237ba','b9f89b18394e59f9a850db16457a307271fab2e0',NULL,'2008-12-20 17:07:18','2009-01-26 21:44:42',NULL,NULL,NULL,NULL,'2008-12-20 17:08:07','k m',NULL),(6,'tsyren@gorodok.net','Just','Man','125159882d121f905b831c81ccc3d383b9e11fc7','1c711f8b719fe16ba001370967368591ae1c860a','60c36fc6417f23cc14f5824b8098fad176084510','2008-12-20 21:53:53','2009-01-20 21:02:40',NULL,NULL,NULL,'87fb23a8ba450b20b9180a2fc9928a752277c170',NULL,'just man',NULL),(7,'spl@gorodok.net','spl','splor','d822df91a7f1d1aeca4328680403c1d8ea63d774','a1ac96b43b379abd5e428dfb8f1d2496329405a2',NULL,'2008-12-23 06:33:41','2009-01-20 21:02:40',NULL,NULL,NULL,'1905cd1be853f4d85ffc422e4d028364ffa86462',NULL,'spl splor',NULL),(9,'mynsuadmin@gmail.com','amdin','proc','99543ecafd9a686747ab8ed49540cccbf67b8f0a','27300ec0f57a3afea441f6dc22d83697e737ecbe',NULL,'2008-12-30 20:53:50','2009-01-20 21:02:40',NULL,NULL,NULL,'9842a8d105e8ba9df2fe8c6cefc3a10c2514b1dc',NULL,'amdin proc',NULL),(10,'first_stream@gorodok.net','ts','ts','af7f03179a5a56a321afb67e56b6a30a87a76425','0db18c1e71bf4d6ad4e402d27b1fceba6ee6c06a',NULL,'2008-12-30 21:04:46','2009-01-20 21:02:40',NULL,NULL,NULL,'a1134e5c73b1353041bfe5868b04fdd2ee838c83',NULL,'ts ts',NULL),(19,'x.doomer.x@gmail.com','Роман','Саяпин','64164f05f6e81fa05cdeb5c45d971e1722320cd9','b3dec876a9c3def4a1bcb2d9f5b908007cbb9675',NULL,'2009-01-19 05:16:35','2009-01-20 21:02:40',NULL,'c61fe6781185aa01954e0d80200c27c852030d1b','2009-03-26 07:06:58',NULL,'2009-01-20 07:06:58','роман саяпин',NULL),(21,'tsyren1@gorodok.net','Алексей','Питерский','61ad685898e88f4a0ab453e3f6afd0288007aa1f','6c34883cefec3f502eb611a9c6a3544c24b6e001',NULL,'2009-01-19 11:58:53','2009-01-20 21:02:40',NULL,NULL,NULL,'e38c5c19f60167781e9cdfd63946745dd1d12edb',NULL,'алексей питерский',NULL),(25,'nsu1team1@gmail.com','Testing','Testing','b692190cef2516d89b54abae0db6211e75b22910','9b0e153ce72932b0459d4d2a559c4044426b82ae',NULL,'2009-01-20 06:28:41','2009-01-20 21:02:40',NULL,NULL,NULL,'d6d24f0499479a8cebc83234637a721fde89a32e',NULL,'testing testing',NULL),(26,'zhargalma@gmail.com','Zhargalma','Ochirova','5659942a361e112f48fd67dc9fca70885a3ebfe5','5dfe3891a08b9042d41051825e02eb74f4afa66c',NULL,'2009-01-20 07:57:32','2009-01-21 14:40:59',NULL,'ba27cd49587ec6d0b433c3c871d87610f2dded73','2009-02-04 14:40:59',NULL,'2009-01-20 07:59:54','zhargalma ochirova',NULL),(27,'solbeg@nsk.ru','Test14','Test14','e081c02792ca5bec29d2d2eaae7f3f0cfbd245c8','4dbca2760aae01f852aad8daef7149c07cb262b5',NULL,NULL,NULL,NULL,NULL,NULL,'95f2605401fcb03914cf207704ccfa25518b4cdf',NULL,'test14 test14',NULL),(28,'test111@test.intel','Test15','Test15','18ab7a4d10974322fd9f1fbb09b3461b2d73cb40','cd47dfdfb515b4eaa1ea83af5ba603e1e166df45',NULL,NULL,NULL,NULL,NULL,NULL,'a67206c8e2df0fc136bbb3b5dfb4d36d5bd9a8fb',NULL,'test15 test15',NULL),(29,'nsu1team@ngs.ru','MyNsuCreator','BLaT','d558d5f6a186fdfd36ca59c20dcb7c3b78cc952a','7a7ee7f7b105cbfc367b2b7d16b51b00f06a0a21',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-05 19:24:33','mynsucreator blat',NULL),(30,'tsyren@google.com','Test','Test','43b53b3f660a633e77c91a97e1342544d0f41b87','d98ae659852aa733d1aa81f2d5418c0a4276dbb9',NULL,NULL,NULL,NULL,NULL,NULL,'fe3cdc904959b36e96b39fffe90c80a753ea2a34',NULL,'test test',NULL),(31,'stariy.czedun@gmail.com','black','overlord','61e1c501723fb1b13f8c0d1446556544d278f373','7795f3e518810dd6732d9b980de367fab62aa218',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-13 07:42:57','black overlord',NULL),(32,'my_survey@ngs.ru','Kelpie','Kelpie','8d4f429e5c5897fdafffe8658f026e3167f73bb2','538076429723287c0e9378a1f1234869fd6d599f',NULL,NULL,NULL,NULL,'fb8de2c8d1a8a66cc04e1ce2db5ac99be550a4a4','2009-03-26 09:57:31',NULL,'2009-03-12 09:57:03','kelpie kelpie',NULL),(33,'vontrips@ngs.ru','Вася','Петров','7f583cf9dac2c686091b9d374a9ec61ad56e11b3','3e22bb7c01d10d6554a14d0135ae68d6805cad49',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 08:30:37','вася петров',NULL),(34,'OrlovIO@gmail.com','Ilya','Orlov','a05b8523a7e922203665d0b85ef500a0b073c743','ea95852b3a3f53010e5ddeefae4af2d560eb45f6',NULL,NULL,NULL,NULL,'258d97c369e6d17848a5d82459f3611e2f9bf3cd','2009-03-26 08:58:41',NULL,'2009-03-12 08:54:24','ilya orlov',NULL),(35,'la@gorodok.net','nanon','nanonov','9515f81e2d7a32af738b6f84ff0c167a6e311b90','4fe7bff97af4c983ef9c12de179f433c434719fd',NULL,NULL,NULL,NULL,NULL,NULL,'92adaa5cf05070f7d90cad92805857f389eec52d',NULL,'nanon nanonov',NULL),(36,'biker.serzhant@gmail.com','Vladimir','Gordeyev','23e053bab96e0d1fb07dd0d7455682d361d619f4','67b835853d21701a0758c35bfa345b300511f82e',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 09:19:47','vladimir gordeyev',NULL),(37,'orfest@gmail.com','Nikolay','Kurtov','524bb77642b450c8b37f983f675812a02ca513b4','4ad514554d5107c434f770341c62643c9f5f2af2',NULL,NULL,NULL,NULL,'ab9c148701a19d31c4dd027f18308e71c3ecdfc7','2009-03-26 09:20:52',NULL,'2009-03-12 09:20:37','nikolay kurtov',NULL),(38,'llavey@gmail.com','nanon','nanonov','114b14b64dca9827ef51fdc355cd67bb01b85355','c555bad3e14c567a84a88167ddbbaa0bf98ea5f9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 10:55:14','nanon nanonov',NULL),(39,'asilkhan@gorodok.net','Асылхан','Садыков','b198df3de71c7f42778074455b506bb3ad7abdef','ff8ed0211e22360e1e22f8b37a3c8ee3f5c273d0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-14 13:29:51','асылхан садыков',NULL),(40,'dralexthk@gmail.com','Alex','D','e6925ff92a6bf1b434ed57c3e404de8087eabcf4','91e685540ad65f977c452a96b74cdd46af91d1da',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 12:10:35','alex d',NULL),(41,'a.a.terehov@mail.ru','Александр','Терехов','9b7b163839ad5514903b8c89b7151db9867d6ff5','078e0925eca427c655bdccdd7816a201edc0d6d6',NULL,NULL,NULL,NULL,'6b6f8c9f0c04f2cba26999d078cbf932a830d4eb','2009-03-26 12:24:48',NULL,'2009-03-12 12:24:22','александр терехов',NULL),(42,'kaygorodov.ivan@gmail.com','Kaygorodov','Ivan','a2e01b43e7db0e519bf647403d036eaeee4c7df7','c67594d37878e0b6dfe8611ef7ae93e275145aaf',NULL,NULL,NULL,NULL,'9eac08f958169248638d479e458d2f058b35924a','2009-03-26 13:23:36',NULL,'2009-03-12 13:23:23','kaygorodov ivan',NULL),(43,'forallepsilon@yandex.ru','Егор','Фёдоров','63267d8201ea00846014672fee18932a9b689547','73cad8778048b7fd7bda5d5070876577a4c90878',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 13:53:30','егор фёдоров',NULL),(44,'bgm@gorodok.net','Геннадий','Борисов','8dca0a6df46b206533596e73879c71eb0529d02e','be9ec77f06f71fb2e8fdac626716e5a12d7f5698',NULL,NULL,NULL,NULL,NULL,NULL,'908230146bf769ca4f51a6caf23b88afc526b533',NULL,'геннадий борисов',NULL),(45,'ruslan.abylhozhin@gmail.com','Руслан','Абылхожин','154e8497d4618cadbd6b4c381f0324db116f4bd1','7cc2a01164b9c4b2d0bc388fee9b15f4d1686c35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 15:06:20','руслан абылхожин',NULL),(46,'vladislav.semenov@gmail.com','Владислав','Семенов','f358bb0a7a14e8e43dd533ce79a3b477a3bf7db7','df92204cc0a23c7d4f0d10327d36dc21f54876f6',NULL,NULL,NULL,NULL,'a46b8e5607d0a4a542d9971d3954ac854edd74eb','2009-03-26 15:28:56',NULL,'2009-03-12 15:28:20','владислав семенов',NULL),(47,'parazit@gorodok.net','Vladimir','Cherepanov','f283f7bb765f235582d59208054186ec9c290a60','b6e92efffab57a4233d763f28ab6c84b1d37e855',NULL,NULL,NULL,NULL,NULL,NULL,'4a27eac520ab7a06009a0f2bb886d9048313c3fc',NULL,'vladimir cherepanov',NULL),(48,'V.A.Cherepanov@gmail.com','Vladimir','Cherepanov','5156646b1c0dc04a6fe9217c921bf1559248d28b','789a55d9c054c316eecd9cdf7b96107ec0a60c2a',NULL,NULL,NULL,NULL,'7d7e032ea44897eafbe17d2617b68e9131561e64','2009-03-27 07:14:43',NULL,'2009-03-12 18:51:55','vladimir cherepanov',NULL),(49,'bairts@google.com','Баир','Тучинов','b4d6e54eeffb041c42d8ba2a50cc022592c04a5b','62c72485ebe5b38bc994e5e17da863115acb63c7','19e0d535179288c2ea456dcc785e8a46e691f5e2',NULL,NULL,NULL,NULL,NULL,'c035e1b31477d60628331dad93d752941b415b7b',NULL,'баир тучинов',NULL),(50,'molcha2006@ngs.ru','Alex','Molchanov','2d0f563aa29e48f9f73f702cbad4bce85723b731','58e9c0f7167a3c92f7bd1e3bed0412dead643d8a',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-12 20:25:09','alex molchanov',NULL),(51,'fanatf1@bk.ru','Славян','Золотухин','681c4588b2f9bc1c4639ea16c771819711e4cc53','3dc3c29fae09574f7bec36a722edb1c73ce5eda5',NULL,NULL,NULL,NULL,'9a6952b554438e8202ead7a413498e5283d413b0','2009-03-27 02:29:47',NULL,'2009-03-13 02:29:26','славян золотухин',NULL),(52,'valera_123@ngs.ru','Валера','Казаков','2bbcdcf381459656293023cdd2e66f7ac62bf541','6ed336602180a5f49d39be07f3c4bd435f08bff0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-13 06:20:28','валера казаков',NULL),(53,'Kacenov@km.ru','Денис','Топшеноев','52ddf695f5beea17836cff6c2932e2c3b39d142f','cb9e2dc13f9b423bfe89a031095dc9178aad7673',NULL,NULL,NULL,NULL,NULL,NULL,'50f8f809f99582f78b69135a9dbff11cb3f2e65d',NULL,'денис топшеноев',NULL),(54,'glaz_@211.ru','I Am','Eye','e2a91797c397e3ca6513c2cdf617fc97d5e2e466','49086d92982c8c66feeb2370cce5de285b1ad079',NULL,NULL,NULL,NULL,'f4d8d0a75a5a519fb615d43b64389c8dcdee44b2','2009-03-28 12:28:49',NULL,'2009-03-14 12:28:12','i am eye',NULL);
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

-- Dump completed on 2009-03-14 14:24:48
