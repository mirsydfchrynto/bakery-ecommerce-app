/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bakery_db
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` varchar(36) NOT NULL,
  `actor` varchar(36) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `resource` varchar(50) NOT NULL,
  `entity_id` varchar(36) NOT NULL,
  `old_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_value`)),
  `new_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_value`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES
('11dcac60-d6e2-4ced-b3d4-18577126fcc4','Cakes','cakes','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('54060c81-e88c-4bec-9060-7f8b1831427e','Cookies','cookies','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6fcc0cf3-c2c4-4179-97e7-60644b94121b','Breads','breads','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('7795591e-6171-4e2c-8ba9-3cfd435d6469','Drinks','drinks','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES
(1,'1','init schema','SQL','V1__init_schema.sql',-1993856329,'root','2026-07-31 08:04:28',610,1),
(2,'2','add user details','SQL','V2__add_user_details.sql',-385135845,'root','2026-07-31 08:04:29',73,1),
(3,'3','add product name to order items','SQL','V3__add_product_name_to_order_items.sql',-46897820,'root','2026-07-31 08:04:29',35,1),
(4,'4','add profile picture url','SQL','V4__add_profile_picture_url.sql',54975965,'root','2026-07-31 08:04:29',36,1),
(5,'5','add password reset tokens','SQL','V5__add_password_reset_tokens.sql',958044966,'root','2026-07-31 08:04:29',31,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventories` (
  `id` varchar(36) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `reserved_stock` int(11) NOT NULL DEFAULT 0,
  `minimum_stock` int(11) NOT NULL DEFAULT 5,
  `status` varchar(20) NOT NULL DEFAULT 'IN_STOCK',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`),
  CONSTRAINT `fk_inv_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
INSERT INTO `inventories` VALUES
('028a4a6d-a2c6-42d0-9241-9f5ccaaefce3','814fab04-b610-4bee-919e-01771b181147',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0a586c12-72d3-4d46-898c-18f55f800900','ae567339-3dfc-45c7-a42a-b770f4e80955',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0c582888-afbf-412d-bad7-583cce7e63bd','e4e47040-e4f3-44e1-87cd-38f8a9be801b',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('12ee6d4d-6e3d-439e-a6d3-bd4493a69c53','9d649d4c-1616-4a82-acfa-3d7766bc67d7',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('14de11d6-424e-40b9-84c0-2fc50033aafb','756ba718-30ac-426d-a1c9-15ca91448309',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1c72b9c3-89ea-47d6-b461-0a77832994ab','ec6a319f-763e-4c2b-a970-95c2a68b809d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1ddd919b-3057-46d4-9798-5c8ac995b9ae','79c1a336-96c2-481c-9904-851328882783',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('204952f4-1fe5-4c6a-a891-0fb0e4e91a27','6a261a9f-61b7-4e7e-9bb1-cf19f9005e16',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2104f17a-6d1f-4dbc-bc39-c7f7b27b01e7','3b41c151-3079-4875-b669-d4747494e534',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('21841f79-a71f-4f33-9bf2-309a96c7167f','56d7e687-55d3-4f08-a411-fb798495ea5d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('24ccd2f5-829f-4931-92d0-1fafd8d77786','6a754251-36c0-4052-a313-bf23a9adbde1',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('25c1c341-dbfe-4c20-a5d1-520fb536515f','a17fae15-c87f-4bee-bc79-890e3727a549',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('29f77235-70d7-48ee-978d-ac53539948a4','5eb0c11f-12ea-477d-8ee9-51ea53707ba7',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2b52511d-2914-4298-9a88-cdf708f63329','6737317e-8b8a-437d-9c6d-f5fa7fa84b0a',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2c0302c7-6205-484b-a0a4-47ae333b9b32','fd8fb1c7-143f-4ebb-87f9-db2bb122f98d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2c29815f-1a45-44be-94b0-6c3869ab174a','e99e1d40-622a-481c-a3c2-8e16e7d6b93d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2e9bb0bf-12dc-4913-835c-e53ccdd9d771','2ce3183e-5e63-4edc-b12a-362256e46b48',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2ef64893-f21d-4e1d-9215-c817bee1d75d','f71792bc-c2b3-4956-bdf2-a4c5013c3b18',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('32d28dbc-aaa0-4068-8178-425b3aa05b23','e12381bb-7af3-4805-91c7-09b2ae7a414e',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('35f44bb0-3a59-4dcd-a017-bb9dd413cf5e','dc234fbe-9d4f-4be9-9702-4d9e8b322784',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('385fb57a-7030-4250-ac8a-0b7ef5f7a8a1','078bc811-0023-4cc2-b9ba-5a7a509dcebd',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3c0733e2-6e55-41d3-b2db-4950e6fa2d61','722f1dc6-25cb-4528-ab5a-1020cf08e72e',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4032c5c0-780a-48f3-b805-407d4014d7dd','ba37d948-5675-48d7-8e68-7764cdbdb4e3',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('41cd223a-e120-457e-a6ce-1747f87cb1da','34ba1760-1fc7-4579-83be-76cd33c67452',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('42105c59-22e9-4937-982c-75a06779f144','933af7e8-6eac-4370-8d22-2b6874d91f39',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('43a6c786-73f9-451d-9be9-f67db4afbd88','117e0394-8844-40c6-83f2-9ca43b928215',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4620bd7c-aed9-489b-9dd6-42b5f0b83883','76fcbb04-1050-40bf-9ca6-aa7709c2678c',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4ab5243a-cbad-4146-a160-fd6f11f25b02','6f522662-d68c-474a-a50f-d75375196421',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4ab58705-3336-4664-bc22-ae315a605a28','8ff54eaa-dcce-4468-a5d5-0cc8ad5baceb',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4ecfb159-8ebe-4fd5-a4ee-539ad5b3dbd8','cdb5d687-7ed1-410e-af70-ca3e40de2d15',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('5e556444-375c-495f-b856-e2620afb2e95','9b9f84b8-68a0-4802-bfe2-56c661809a4a',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('5f1918d7-1998-4e12-9728-bafb72310dad','578534c3-da8c-4914-900c-5d0143ab4643',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('63d59be4-b2ef-4739-af33-64cfcb5e54a2','cadd0188-73a1-4bd9-9307-fe552bb2ff7e',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6ec53bf7-b75f-41e3-8848-dcf49e0c45dd','5a62e3c6-3577-4637-a3a2-4361c08b7930',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6fa07228-591d-4625-937e-b71c2bf2a06c','a6261253-b599-4515-b05c-73e8b4dddcbc',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('75775262-9d8c-46dd-b446-61aa22b67daf','9843e7ea-d73e-4e58-a05c-95efaa9adf65',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('7901dc95-87a5-488f-81b7-aa92de00b7aa','1665d6d5-e3ed-4f69-a523-aa29c6e818ac',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('7c2709aa-f9fb-4215-890e-ec3da98941a5','bbefd010-8f1b-425d-8742-fd81f5e75d43',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('7ed74f0b-0688-40fa-ba06-a748969b325b','78fa0fcd-0ce0-4ec9-9db0-55ec25660293',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('83787cde-90f8-4cce-a153-d9ff3cf967cc','3f26a0c4-a0cb-481a-bda0-2f5bc60858f8',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8967b3b6-5649-4ea8-b09b-d027d6d641d0','c8fa35da-126b-4f31-9844-29b4127765be',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('90d8d7f8-0fc5-4001-8d38-64fd14a3fb4e','a8e6f3c6-4d54-4efd-8b2a-d925de3f9b95',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9296da41-116d-4f95-a036-c85bb669437e','c0ebe380-dc94-46df-831a-55e3bf66a541',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9c0f21b6-b797-4072-8e64-08ce04b19750','50c0f6f4-4c63-4961-ab5c-a1f56a4d3f27',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9d98c3a9-64bd-41bb-8736-80cf8625e1f9','229a0f2f-c5ae-4e05-a33f-da09e3f34adb',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a5b9866b-dbe1-4401-bb3b-226d69cbde4d','dc95a184-2560-4282-985c-3a1d1bb30a00',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a6caa2b3-d9c2-4353-99a7-700f01384eea','e682f57d-0fad-41e1-ba78-bbc288a563f5',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a7dc2365-3c55-42e8-815c-3e0dc99425cc','c8b295dc-7988-4d21-9cd8-c5d81c7de1ec',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('adb65502-4f48-4f1c-a094-410d6c0230a7','1411651b-013c-4bd2-b61a-38afff734d45',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('af60bc95-8eef-4010-a3a6-1f1a8f19cbb7','1000c3bb-d644-49a8-a1ba-893146dc04d6',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('baa95eb5-3419-480a-8c33-65d3fa496a7b','96938b1d-7fb0-4d13-97e2-231f70a05f32',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('bb17657c-80b2-41b2-b235-a5f8025ad247','05d667c9-44b6-480b-b133-7fa36c3d20c1',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('bdfc2980-3b9d-4885-a57e-825436c3bd45','ea55a2d8-f3a2-4a82-a160-2a967b35fd83',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('bf1cf958-6033-482d-a88f-37b67e482620','cbd16cc0-2a43-4bf4-bef1-eeb483fe2a69',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c101faaf-4eb7-4463-ab92-a72de858ddd6','da8775ae-418d-428a-b41b-e7b2595052cf',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c740f99e-24be-4600-a972-0cccbbcffaef','34c08e7a-507a-4d61-b7e0-f100ac3ba401',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c84d31f8-4e14-4181-b8fb-a37dc79b1278','ea339584-26d7-4798-a4eb-bd5d117e04b4',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cbaacaf8-2fc9-48ce-9b1f-ff2a311ef72d','61c50711-b62d-4f70-90dc-362597eb9097',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cc698919-af25-4729-89c7-7e2c39872fe4','9bbec9a6-da66-4d00-94dd-a05d06e8762d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cc784563-627c-45ee-8cb4-4ba6705b127b','191fcbd3-a2df-47c3-8a0d-7d732c1cbffa',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cce1bfdc-8b51-49ce-bf6b-39c8efdadda4','873b2de6-a19b-45e7-8e49-4154ad1df677',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ce110735-d8d9-4875-9a86-d1df9697b534','3d3ba15c-da18-462e-96ed-bd7624fbd763',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d1ad2966-1bcf-4aed-bdfd-d8ebe999fb22','8416421a-7b7a-4980-bb03-b9de26a11e20',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d2c33243-d190-422a-9be2-641229203e02','e2072f48-96dc-4cdd-984e-7a0d5b40cf79',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d44f292f-f93e-4442-b7c7-78a370811b53','0281356e-9565-4995-adbf-06c0e5aac484',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('df64aa57-c2bc-4f5b-aa78-67691ca34987','c7bd0d95-50c9-4e43-ba2b-01abdb0d2a13',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e17a8556-8fa6-4870-bc38-715132f2865c','1aacc5d3-6027-46ba-9bd2-a41a0e8d766d',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e5e92495-1ec3-4778-9888-c3083c03304c','24255037-500d-428d-807d-220878286336',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ec2591ee-c75f-4fea-8e45-0cad1c6dc7ef','00851366-7b6b-4526-a97d-8b7da8fdcaf6',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f02c2dfa-3027-4d31-a81c-011af9fb0eb4','331e5ba0-43ad-4565-86c9-1a3f159c885f',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f12bc8ed-eb03-4876-b691-0675a818d091','023a188b-a6f0-4cb2-9fbb-de1fbc2273ba',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f1f0b3cd-997d-4ef8-a9bf-3f90c3e9f548','70b64611-faad-435f-b119-de449a6f908b',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f2f54cb2-14eb-4396-8dda-1ad9f03308c1','26198b4b-989f-4ce4-9569-aaf4a020bebb',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f6ccc06c-be23-43c2-a921-9bacd267b697','11086a4c-813b-4b3d-98b9-90b9650554f4',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f8032760-5e32-4c28-a12e-cdc376907724','0f06321f-0c6a-41d6-a15d-300106b3a1f2',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f896495b-ca24-40fa-bc5e-da296345e830','b1ddae12-627c-4484-9431-820e6c9f0c6f',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('fabcc238-1fcf-4468-bde7-d0d79eafdd6c','4bcc1137-92a8-45af-9f62-01221bb701ad',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('facb4c15-543b-4083-b58f-f2a024dbb3ae','4962180f-2159-422a-a874-86d35225e809',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ff623beb-ebf1-4cb0-afe3-97248879743d','e54946ea-5d19-4312-a1ff-b57fb1e5b9fa',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ff84b48f-4839-46c8-8a15-c810d592fc41','4a837c05-94aa-46b9-abe2-471638c2bc51',150,0,10,'IN_STOCK','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL);
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_addresses`
--

DROP TABLE IF EXISTS `order_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_addresses` (
  `id` varchar(36) NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `recipient_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `full_address` text NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  CONSTRAINT `fk_oa_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_addresses`
--

LOCK TABLES `order_addresses` WRITE;
/*!40000 ALTER TABLE `order_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` varchar(36) NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_at_purchase` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  `product_name` varchar(100) NOT NULL DEFAULT 'Unknown Product',
  PRIMARY KEY (`id`),
  KEY `fk_oi_order` (`order_id`),
  KEY `fk_oi_product` (`product_id`),
  CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_oi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES
('24799928-e0f6-496f-ae77-f6ce3a805e7e','ba78f975-bcb4-4292-9435-0f9f34758432','e2072f48-96dc-4cdd-984e-7a0d5b40cf79',3,400000.00,'2026-07-31 01:04:38','2026-07-31 01:04:38',NULL,NULL,''),
('74de0d28-bb86-4562-8e31-5bfb0d2a38af','7d8e7d97-7f89-471e-8696-b4b339966546','023a188b-a6f0-4cb2-9fbb-de1fbc2273ba',1,15000.00,'2026-07-31 01:04:38','2026-07-31 01:04:38',NULL,NULL,''),
('9d43ce1e-f61e-454f-9d81-56538b48c333','7d8e7d97-7f89-471e-8696-b4b339966546','00851366-7b6b-4526-a97d-8b7da8fdcaf6',1,280000.00,'2026-07-31 01:04:38','2026-07-31 01:04:38',NULL,NULL,'');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` varchar(36) NOT NULL,
  `customer_id` varchar(36) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'PENDING',
  `ordered_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_orders_customer_date` (`customer_id`,`ordered_at`),
  KEY `idx_orders_status_date` (`status`,`ordered_at`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES
('7d8e7d97-7f89-471e-8696-b4b339966546','1fbbc9dc-9418-4ad7-b891-ca484ccaa112',295000.00,'COMPLETED','2026-07-31 01:04:38','2026-07-31 01:04:38','2026-07-31 01:04:38',NULL,NULL),
('ba78f975-bcb4-4292-9435-0f9f34758432','1fbbc9dc-9418-4ad7-b891-ca484ccaa112',1200000.00,'PROCESSING','2026-07-31 01:04:38','2026-07-31 01:04:38','2026-07-31 01:04:38',NULL,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` varchar(36) NOT NULL,
  `token` varchar(255) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `expiry_date` timestamp NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `fk_prt_user` (`user_id`),
  CONSTRAINT `fk_prt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` varchar(36) NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `payment_reference` varchar(50) DEFAULT NULL,
  `payment_method` varchar(50) NOT NULL,
  `bank_name` varchar(50) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `transfer_amount` decimal(12,2) NOT NULL,
  `payment_proof_urls` text NOT NULL,
  `payment_status` varchar(30) NOT NULL DEFAULT 'VERIFYING',
  `rejection_reason` text DEFAULT NULL,
  `verified_by` varchar(36) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `fk_payments_verifier` (`verified_by`),
  KEY `idx_payments_status_time` (`payment_status`,`created_at`),
  CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payments_verifier` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_categories` (
  `product_id` varchar(36) NOT NULL,
  `category_id` varchar(36) NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `fk_pc_category` (`category_id`),
  CONSTRAINT `fk_pc_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pc_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
INSERT INTO `product_categories` VALUES
('00851366-7b6b-4526-a97d-8b7da8fdcaf6','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('023a188b-a6f0-4cb2-9fbb-de1fbc2273ba','54060c81-e88c-4bec-9060-7f8b1831427e'),
('0281356e-9565-4995-adbf-06c0e5aac484','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('05d667c9-44b6-480b-b133-7fa36c3d20c1','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('078bc811-0023-4cc2-b9ba-5a7a509dcebd','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('0f06321f-0c6a-41d6-a15d-300106b3a1f2','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('1000c3bb-d644-49a8-a1ba-893146dc04d6','54060c81-e88c-4bec-9060-7f8b1831427e'),
('11086a4c-813b-4b3d-98b9-90b9650554f4','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('117e0394-8844-40c6-83f2-9ca43b928215','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('1411651b-013c-4bd2-b61a-38afff734d45','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('1665d6d5-e3ed-4f69-a523-aa29c6e818ac','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('191fcbd3-a2df-47c3-8a0d-7d732c1cbffa','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('1aacc5d3-6027-46ba-9bd2-a41a0e8d766d','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('229a0f2f-c5ae-4e05-a33f-da09e3f34adb','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('24255037-500d-428d-807d-220878286336','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('26198b4b-989f-4ce4-9569-aaf4a020bebb','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('2ce3183e-5e63-4edc-b12a-362256e46b48','54060c81-e88c-4bec-9060-7f8b1831427e'),
('331e5ba0-43ad-4565-86c9-1a3f159c885f','54060c81-e88c-4bec-9060-7f8b1831427e'),
('34ba1760-1fc7-4579-83be-76cd33c67452','54060c81-e88c-4bec-9060-7f8b1831427e'),
('34c08e7a-507a-4d61-b7e0-f100ac3ba401','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('3b41c151-3079-4875-b669-d4747494e534','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('3d3ba15c-da18-462e-96ed-bd7624fbd763','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('3f26a0c4-a0cb-481a-bda0-2f5bc60858f8','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('4962180f-2159-422a-a874-86d35225e809','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('4a837c05-94aa-46b9-abe2-471638c2bc51','54060c81-e88c-4bec-9060-7f8b1831427e'),
('4bcc1137-92a8-45af-9f62-01221bb701ad','54060c81-e88c-4bec-9060-7f8b1831427e'),
('50c0f6f4-4c63-4961-ab5c-a1f56a4d3f27','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('56d7e687-55d3-4f08-a411-fb798495ea5d','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('578534c3-da8c-4914-900c-5d0143ab4643','54060c81-e88c-4bec-9060-7f8b1831427e'),
('5a62e3c6-3577-4637-a3a2-4361c08b7930','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('5eb0c11f-12ea-477d-8ee9-51ea53707ba7','54060c81-e88c-4bec-9060-7f8b1831427e'),
('61c50711-b62d-4f70-90dc-362597eb9097','54060c81-e88c-4bec-9060-7f8b1831427e'),
('6737317e-8b8a-437d-9c6d-f5fa7fa84b0a','54060c81-e88c-4bec-9060-7f8b1831427e'),
('6a261a9f-61b7-4e7e-9bb1-cf19f9005e16','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('6a754251-36c0-4052-a313-bf23a9adbde1','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('6f522662-d68c-474a-a50f-d75375196421','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('70b64611-faad-435f-b119-de449a6f908b','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('722f1dc6-25cb-4528-ab5a-1020cf08e72e','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('756ba718-30ac-426d-a1c9-15ca91448309','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('76fcbb04-1050-40bf-9ca6-aa7709c2678c','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('78fa0fcd-0ce0-4ec9-9db0-55ec25660293','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('79c1a336-96c2-481c-9904-851328882783','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('814fab04-b610-4bee-919e-01771b181147','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('8416421a-7b7a-4980-bb03-b9de26a11e20','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('873b2de6-a19b-45e7-8e49-4154ad1df677','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('8ff54eaa-dcce-4468-a5d5-0cc8ad5baceb','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('933af7e8-6eac-4370-8d22-2b6874d91f39','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('96938b1d-7fb0-4d13-97e2-231f70a05f32','54060c81-e88c-4bec-9060-7f8b1831427e'),
('9843e7ea-d73e-4e58-a05c-95efaa9adf65','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('9b9f84b8-68a0-4802-bfe2-56c661809a4a','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('9bbec9a6-da66-4d00-94dd-a05d06e8762d','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('9d649d4c-1616-4a82-acfa-3d7766bc67d7','54060c81-e88c-4bec-9060-7f8b1831427e'),
('a17fae15-c87f-4bee-bc79-890e3727a549','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('a6261253-b599-4515-b05c-73e8b4dddcbc','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('a8e6f3c6-4d54-4efd-8b2a-d925de3f9b95','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('ae567339-3dfc-45c7-a42a-b770f4e80955','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('b1ddae12-627c-4484-9431-820e6c9f0c6f','54060c81-e88c-4bec-9060-7f8b1831427e'),
('ba37d948-5675-48d7-8e68-7764cdbdb4e3','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('bbefd010-8f1b-425d-8742-fd81f5e75d43','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('c0ebe380-dc94-46df-831a-55e3bf66a541','54060c81-e88c-4bec-9060-7f8b1831427e'),
('c7bd0d95-50c9-4e43-ba2b-01abdb0d2a13','54060c81-e88c-4bec-9060-7f8b1831427e'),
('c8b295dc-7988-4d21-9cd8-c5d81c7de1ec','54060c81-e88c-4bec-9060-7f8b1831427e'),
('c8fa35da-126b-4f31-9844-29b4127765be','54060c81-e88c-4bec-9060-7f8b1831427e'),
('cadd0188-73a1-4bd9-9307-fe552bb2ff7e','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('cbd16cc0-2a43-4bf4-bef1-eeb483fe2a69','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('cdb5d687-7ed1-410e-af70-ca3e40de2d15','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('da8775ae-418d-428a-b41b-e7b2595052cf','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('dc234fbe-9d4f-4be9-9702-4d9e8b322784','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('dc95a184-2560-4282-985c-3a1d1bb30a00','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('e12381bb-7af3-4805-91c7-09b2ae7a414e','54060c81-e88c-4bec-9060-7f8b1831427e'),
('e2072f48-96dc-4cdd-984e-7a0d5b40cf79','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('e4e47040-e4f3-44e1-87cd-38f8a9be801b','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('e54946ea-5d19-4312-a1ff-b57fb1e5b9fa','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('e682f57d-0fad-41e1-ba78-bbc288a563f5','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('e99e1d40-622a-481c-a3c2-8e16e7d6b93d','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('ea339584-26d7-4798-a4eb-bd5d117e04b4','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('ea55a2d8-f3a2-4a82-a160-2a967b35fd83','6fcc0cf3-c2c4-4179-97e7-60644b94121b'),
('ec6a319f-763e-4c2b-a970-95c2a68b809d','7795591e-6171-4e2c-8ba9-3cfd435d6469'),
('f71792bc-c2b3-4956-bdf2-a4c5013c3b18','11dcac60-d6e2-4ced-b3d4-18577126fcc4'),
('fd8fb1c7-143f-4ebb-87f9-db2bb122f98d','54060c81-e88c-4bec-9060-7f8b1831427e');
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` varchar(36) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `url` varchar(255) NOT NULL,
  `alt_text` varchar(100) DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pi_product` (`product_id`),
  CONSTRAINT `fk_pi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES
('009dc42f-5c7f-4953-a3db-19a2e5d8366d','5eb0c11f-12ea-477d-8ee9-51ea53707ba7','https://image.pollinations.ai/prompt/Lemon+Glaze+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0565f788-f79e-49e8-bdc8-857694f771fc','ae567339-3dfc-45c7-a42a-b770f4e80955','https://image.pollinations.ai/prompt/Cold+Brew+Coffee+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('06ba718d-a9ee-453b-b487-8791754ae114','96938b1d-7fb0-4d13-97e2-231f70a05f32','https://image.pollinations.ai/prompt/Chocolate+Chip+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0a02ad24-aeb1-4c87-9702-5e7e995d2d54','6a754251-36c0-4052-a313-bf23a9adbde1','https://image.pollinations.ai/prompt/Milk+Toast+Bread+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('11ae020b-2a42-421e-9b96-10efe3a40ff3','70b64611-faad-435f-b119-de449a6f908b','https://image.pollinations.ai/prompt/Choco+Mint+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('13951fac-05bb-4ed3-8f03-dc3c1340b67c','c8b295dc-7988-4d21-9cd8-c5d81c7de1ec','https://image.pollinations.ai/prompt/Almond+Biscotti+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('180f8a6c-f6d9-4be6-939a-60d6f5da3d9e','3f26a0c4-a0cb-481a-bda0-2f5bc60858f8','https://image.pollinations.ai/prompt/Vanilla+Bean+Frappe+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1d65b675-787e-4cd4-8cb0-0f374c98ea93','fd8fb1c7-143f-4ebb-87f9-db2bb122f98d','https://image.pollinations.ai/prompt/Espresso+Chocolate+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('28b1a588-e909-486b-9ee6-6f6617c6272f','ea55a2d8-f3a2-4a82-a160-2a967b35fd83','https://image.pollinations.ai/prompt/Almond+Croissant+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2af57bff-ba42-4612-9ec7-dade92e3c76d','e54946ea-5d19-4312-a1ff-b57fb1e5b9fa','https://image.pollinations.ai/prompt/Whole+Wheat+Loaf+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2e7864e0-d6a6-490d-b0ce-6a127aaee800','9d649d4c-1616-4a82-acfa-3d7766bc67d7','https://image.pollinations.ai/prompt/Shortbread+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('33716cc7-7798-419b-a97c-eca2e7d37da6','00851366-7b6b-4526-a97d-8b7da8fdcaf6','https://image.pollinations.ai/prompt/Earl+Grey+Chiffon+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('37c69bd6-ba43-4845-8295-b15ef5b2df20','c7bd0d95-50c9-4e43-ba2b-01abdb0d2a13','https://image.pollinations.ai/prompt/Red+Velvet+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3b281a7e-4c77-4530-be1c-0821000a69bb','1665d6d5-e3ed-4f69-a523-aa29c6e818ac','https://image.pollinations.ai/prompt/Brioche+Bun+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3cb03c2a-ff4e-4b90-8d0d-734316227f16','cdb5d687-7ed1-410e-af70-ca3e40de2d15','https://image.pollinations.ai/prompt/Rye+Bread+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3d1faefd-f79a-4bda-9bf3-ec9ede8dda41','1aacc5d3-6027-46ba-9bd2-a41a0e8d766d','https://image.pollinations.ai/prompt/Pretzel+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3d797443-f3d7-4397-b31c-2d90b03a25cd','933af7e8-6eac-4370-8d22-2b6874d91f39','https://image.pollinations.ai/prompt/Iced+Chocolate+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3d91e87f-c92f-4b45-8d2f-94c2e213be49','a6261253-b599-4515-b05c-73e8b4dddcbc','https://image.pollinations.ai/prompt/Carrot+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('441954bd-d784-4549-8162-0a018b2d6bcb','9843e7ea-d73e-4e58-a05c-95efaa9adf65','https://image.pollinations.ai/prompt/Flat+White+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('47daa618-8042-46ed-b97b-536177feacac','c8fa35da-126b-4f31-9844-29b4127765be','https://image.pollinations.ai/prompt/Peanut+Butter+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('488e38c4-da8a-4ecd-8355-a267451651b5','61c50711-b62d-4f70-90dc-362597eb9097','https://image.pollinations.ai/prompt/Brownie+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('488eecf5-e939-4de3-b4b3-f2e4caffd89c','8ff54eaa-dcce-4468-a5d5-0cc8ad5baceb','https://image.pollinations.ai/prompt/Red+Velvet+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('49d0ae36-016c-4695-a433-80b2b9fc89fa','9bbec9a6-da66-4d00-94dd-a05d06e8762d','https://image.pollinations.ai/prompt/Strawberry+Smoothie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4c1e69c0-c940-4f5a-9683-7d363861f050','26198b4b-989f-4ce4-9569-aaf4a020bebb','https://image.pollinations.ai/prompt/Bagel+with+Cream+Cheese+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4ce61cb8-422e-4b19-a47b-4bbc04aa32ea','578534c3-da8c-4914-900c-5d0143ab4643','https://image.pollinations.ai/prompt/Matcha+Almond+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4d481c78-fab9-41db-a399-96b3c11428c9','873b2de6-a19b-45e7-8e49-4154ad1df677','https://image.pollinations.ai/prompt/Vanilla+Bean+Sponge+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('55d24da9-6e3a-4d0d-9d51-203dd557acfa','078bc811-0023-4cc2-b9ba-5a7a509dcebd','https://image.pollinations.ai/prompt/Pumpernickel+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('55dab75b-25c9-4fad-a33c-d0c3d3f7875c','814fab04-b610-4bee-919e-01771b181147','https://image.pollinations.ai/prompt/Sparkling+Lemonade+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('59f9e831-04ab-4585-8d09-c17cb03098bc','1000c3bb-d644-49a8-a1ba-893146dc04d6','https://image.pollinations.ai/prompt/Snickerdoodle+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('5d54c222-eb7b-43fc-9af9-c8e226c6bce7','3b41c151-3079-4875-b669-d4747494e534','https://image.pollinations.ai/prompt/Mango+Tango+Frappe+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('616fa460-907b-4009-b417-1feb6973037b','da8775ae-418d-428a-b41b-e7b2595052cf','https://image.pollinations.ai/prompt/Black+Forest+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6a89be2c-1d51-41d3-bad6-36e3db1871d8','dc234fbe-9d4f-4be9-9702-4d9e8b322784','https://image.pollinations.ai/prompt/New+York+Cheesecake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6b3d20ac-b145-45b5-b45d-c9c9043f3468','2ce3183e-5e63-4edc-b12a-362256e46b48','https://image.pollinations.ai/prompt/Ginger+Molasses+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6b72d913-2084-4e7d-bbb6-417b7256e0d9','76fcbb04-1050-40bf-9ca6-aa7709c2678c','https://image.pollinations.ai/prompt/Mocha+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6cde574d-4591-42bf-8a96-cbaa63e51be9','4962180f-2159-422a-a874-86d35225e809','https://image.pollinations.ai/prompt/Blueberry+Cheesecake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6d46334d-1639-4216-9c97-ef03f892972d','6f522662-d68c-474a-a50f-d75375196421','https://image.pollinations.ai/prompt/Dirty+Matcha+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('717365a1-ede1-46f1-8411-d75c1350a38b','79c1a336-96c2-481c-9904-851328882783','https://image.pollinations.ai/prompt/Hazelnut+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('75689d8f-11f8-4a1b-b6ef-7d44a03d7d76','6737317e-8b8a-437d-9c6d-f5fa7fa84b0a','https://image.pollinations.ai/prompt/Macadamia+White+Choco+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('7b5fb636-5ccb-417b-a24b-793edbbe18fe','1411651b-013c-4bd2-b61a-38afff734d45','https://image.pollinations.ai/prompt/Opera+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8006a44d-d15f-49c9-a866-41d8d5d25d78','a8e6f3c6-4d54-4efd-8b2a-d925de3f9b95','https://image.pollinations.ai/prompt/Strawberry+Shortcake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('837e2da0-6c0f-489f-93e5-4d08ae4846a8','5a62e3c6-3577-4637-a3a2-4361c08b7930','https://image.pollinations.ai/prompt/Caramel+Macchiato+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('84b7a776-54be-46e7-82f2-98a53f1521d1','e99e1d40-622a-481c-a3c2-8e16e7d6b93d','https://image.pollinations.ai/prompt/Classic+Red+Velvet+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('85cfafac-86e6-425f-954e-74811bdb0b6b','bbefd010-8f1b-425d-8742-fd81f5e75d43','https://image.pollinations.ai/prompt/Lotus+Biscoff+Cheesecake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('85fb5cf7-f3cc-471c-9033-f63a70cdc229','e4e47040-e4f3-44e1-87cd-38f8a9be801b','https://image.pollinations.ai/prompt/Chocolate+Babka+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8616bcda-29d2-4d72-bc0f-e88cfc8c4105','b1ddae12-627c-4484-9431-820e6c9f0c6f','https://image.pollinations.ai/prompt/Pistachio+Cranberry+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('86c6d211-3072-40de-ae10-382c4902f7bf','cbd16cc0-2a43-4bf4-bef1-eeb483fe2a69','https://image.pollinations.ai/prompt/Hazelnut+Praline+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('87b3c39d-171f-4030-9984-385e114c3256','11086a4c-813b-4b3d-98b9-90b9650554f4','https://image.pollinations.ai/prompt/Butter+Croissant+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8d7feabd-401d-4c88-a2b6-3a56aecaa634','dc95a184-2560-4282-985c-3a1d1bb30a00','https://image.pollinations.ai/prompt/Raspberry+Tart+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('90153647-40e6-40f4-b9ea-7f8c9e554457','e682f57d-0fad-41e1-ba78-bbc288a563f5','https://image.pollinations.ai/prompt/Tiramisu+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9401b33e-2279-4d00-b489-844fa348dff8','56d7e687-55d3-4f08-a411-fb798495ea5d','https://image.pollinations.ai/prompt/Iced+Americano+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9b16095d-2506-4d7f-bc81-97c5edca493d','0281356e-9565-4995-adbf-06c0e5aac484','https://image.pollinations.ai/prompt/Chai+Tea+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9b9998c9-37fe-4d60-b40f-f5b9144d2929','05d667c9-44b6-480b-b133-7fa36c3d20c1','https://image.pollinations.ai/prompt/Cinnamon+Roll+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a4e07b9f-db82-4d42-a6d0-4b5e15a2461f','722f1dc6-25cb-4528-ab5a-1020cf08e72e','https://image.pollinations.ai/prompt/Peach+Iced+Tea+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('b0d523f8-911d-46c3-989a-017346076b72','34c08e7a-507a-4d61-b7e0-f100ac3ba401','https://image.pollinations.ai/prompt/Hot+Caffe+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('b0ec1a68-4516-489a-adcc-7cb203eb06ba','117e0394-8844-40c6-83f2-9ca43b928215','https://image.pollinations.ai/prompt/Pain+au+Chocolat+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('b31b857f-7dc5-4889-a29f-fe252d680e21','8416421a-7b7a-4980-bb03-b9de26a11e20','https://image.pollinations.ai/prompt/Lychee+Yakult+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ba1119db-2ebd-4353-b5bb-a6a3c383dd6a','78fa0fcd-0ce0-4ec9-9db0-55ec25660293','https://image.pollinations.ai/prompt/Multigrain+Bread+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('bb1eb0bc-3bb8-4cbc-8a47-123c87d49d41','c0ebe380-dc94-46df-831a-55e3bf66a541','https://image.pollinations.ai/prompt/Coconut+Macaroon+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c1f1178b-0376-4eb0-a48d-082fab4c93f8','023a188b-a6f0-4cb2-9fbb-de1fbc2273ba','https://image.pollinations.ai/prompt/Oatmeal+Raisin+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c36fada6-3d60-40bc-873d-ce510ba24b0f','a17fae15-c87f-4bee-bc79-890e3727a549','https://image.pollinations.ai/prompt/Pandan+Gula+Melaka+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c5275b0b-5ca8-4ced-8d00-e42f305118d4','ec6a319f-763e-4c2b-a970-95c2a68b809d','https://image.pollinations.ai/prompt/Caramel+Macchiato+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cbe59ed7-68c2-42e2-9d46-41c372406a78','24255037-500d-428d-807d-220878286336','https://image.pollinations.ai/prompt/Sourdough+Boule+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cfda40a3-6a79-411f-9332-4d8f13af55bb','e12381bb-7af3-4805-91c7-09b2ae7a414e','https://image.pollinations.ai/prompt/Funfetti+Sugar+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d255591f-dc31-4bc6-8b17-5c51329b89ee','229a0f2f-c5ae-4e05-a33f-da09e3f34adb','https://image.pollinations.ai/prompt/Affogato+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d4adfc3d-a2f1-4f3f-96ee-e14c3581bc27','3d3ba15c-da18-462e-96ed-bd7624fbd763','https://image.pollinations.ai/prompt/Cheese+Babka+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('d9ddc837-af93-43d6-b65f-3b0f59a072ad','ea339584-26d7-4798-a4eb-bd5d117e04b4','https://image.pollinations.ai/prompt/Ciabatta+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e0a8f2e3-d298-473f-994b-2230a9249c1e','4a837c05-94aa-46b9-abe2-471638c2bc51','https://image.pollinations.ai/prompt/S%27mores+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e41fe5fc-987b-4450-846e-e7240b6e82cb','191fcbd3-a2df-47c3-8a0d-7d732c1cbffa','https://image.pollinations.ai/prompt/Lemon+Pound+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e74628ca-fb0b-42aa-bdcb-7136445c8c64','ba37d948-5675-48d7-8e68-7764cdbdb4e3','https://image.pollinations.ai/prompt/Earl+Grey+Milk+Tea+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ebcb38d7-adb3-4dca-9dd8-5e14daf3ee63','f71792bc-c2b3-4956-bdf2-a4c5013c3b18','https://image.pollinations.ai/prompt/Matcha+Mille+Crepe+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ed6bafca-0ab5-41c1-814b-315d02a44d26','cadd0188-73a1-4bd9-9307-fe552bb2ff7e','https://image.pollinations.ai/prompt/Mango+Mousse+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ee716a26-69dd-4929-aba8-8eb5cb9b1657','6a261a9f-61b7-4e7e-9bb1-cf19f9005e16','https://image.pollinations.ai/prompt/Olive+Bread+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('eef2b37e-81f2-4de0-8afe-44e31a6e0694','e2072f48-96dc-4cdd-984e-7a0d5b40cf79','https://image.pollinations.ai/prompt/Dark+Chocolate+Truffle+Cake+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ef84ce6a-aaee-4990-8133-e64b2ddecf7c','50c0f6f4-4c63-4961-ab5c-a1f56a4d3f27','https://image.pollinations.ai/prompt/Classic+French+Baguette+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f30b79fd-ee00-4af9-b024-f04f83813dc1','756ba718-30ac-426d-a1c9-15ca91448309','https://image.pollinations.ai/prompt/Cheese+Focaccia+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f42d980a-d994-4e9f-9550-07e907d971c5','34ba1760-1fc7-4579-83be-76cd33c67452','https://image.pollinations.ai/prompt/Lotus+Biscoff+Stuffed+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f4f5da15-2dc2-48a3-88b0-2b2e6b3d075c','0f06321f-0c6a-41d6-a15d-300106b3a1f2','https://image.pollinations.ai/prompt/Garlic+Butter+Bread+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('fac6b129-4c8f-48d6-8a61-cbb6f52e943f','331e5ba0-43ad-4565-86c9-1a3f159c885f','https://image.pollinations.ai/prompt/Nutella+Sea+Salt+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('faf3a09b-155a-4bb6-a873-3c8e29d7be2f','9b9f84b8-68a0-4802-bfe2-56c661809a4a','https://image.pollinations.ai/prompt/Matcha+Latte+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('fb8422e5-15f6-4ab6-a379-61ffafaebf04','4bcc1137-92a8-45af-9f62-01221bb701ad','https://image.pollinations.ai/prompt/Double+Chocolate+Cookie+bakery+food+photography+8k+resolution+highly+detailed?width=800&height=800&nologo=true',NULL,1,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL);
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) NOT NULL DEFAULT 'DRAFT',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_products_name` (`name`),
  KEY `idx_products_active` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES
('00851366-7b6b-4526-a97d-8b7da8fdcaf6','Earl Grey Chiffon','Extremely fluffy chiffon cake infused with fragrant Earl Grey tea.',280000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('023a188b-a6f0-4cb2-9fbb-de1fbc2273ba','Oatmeal Raisin Cookie','Chewy, comforting, and perfectly spiced with cinnamon and plump raisins.',15000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0281356e-9565-4995-adbf-06c0e5aac484','Chai Tea Latte','Spiced Indian black tea with notes of cinnamon, cardamom, and milk.',38000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('05d667c9-44b6-480b-b133-7fa36c3d20c1','Cinnamon Roll','Soft and fluffy bread swirled with cinnamon sugar and topped with cream cheese frosting.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('078bc811-0023-4cc2-b9ba-5a7a509dcebd','Pumpernickel','Dark, slightly sweet and dense German sourdough bread.',40000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('0f06321f-0c6a-41d6-a15d-300106b3a1f2','Garlic Butter Bread','Savory artisan bread generously loaded with roasted garlic and herb butter.',35000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1000c3bb-d644-49a8-a1ba-893146dc04d6','Snickerdoodle','Soft, pillowy cookie coated in a generous layer of cinnamon sugar.',15000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('11086a4c-813b-4b3d-98b9-90b9650554f4','Butter Croissant','Flaky, buttery, and golden brown French pastry. Perfect for breakfast.',20000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('117e0394-8844-40c6-83f2-9ca43b928215','Pain au Chocolat','Classic French pastry filled with two batons of dark chocolate.',24000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1411651b-013c-4bd2-b61a-38afff734d45','Opera Cake','Elegant French cake with layers of almond sponge, coffee syrup, and chocolate.',450000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1665d6d5-e3ed-4f69-a523-aa29c6e818ac','Brioche Bun','Rich, buttery, and soft bun, perfect for premium burgers or eating plain.',18000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('191fcbd3-a2df-47c3-8a0d-7d732c1cbffa','Lemon Pound Cake','Zesty, buttery loaf cake topped with a sweet lemon glaze.',120000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('1aacc5d3-6027-46ba-9bd2-a41a0e8d766d','Pretzel','Authentic Bavarian soft pretzel sprinkled with coarse sea salt.',22000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('229a0f2f-c5ae-4e05-a33f-da09e3f34adb','Affogato','A shot of hot espresso poured over a scoop of premium vanilla ice cream.',45000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('24255037-500d-428d-807d-220878286336','Sourdough Boule','Artisan naturally fermented bread with a signature tangy flavor and chewy texture.',45000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('26198b4b-989f-4ce4-9569-aaf4a020bebb','Bagel with Cream Cheese','New York style boiled bagel served with a side of cream cheese.',30000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('2ce3183e-5e63-4edc-b12a-362256e46b48','Ginger Molasses Cookie','Chewy, richly spiced cookie with deep molasses and ginger flavors.',16000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('331e5ba0-43ad-4565-86c9-1a3f159c885f','Nutella Sea Salt','Thick cookie stuffed with Nutella and sprinkled with flaky sea salt.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('34ba1760-1fc7-4579-83be-76cd33c67452','Lotus Biscoff Stuffed','Soft brown sugar cookie with a gooey melted Speculoos center.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('34c08e7a-507a-4d61-b7e0-f100ac3ba401','Hot Caffe Latte','Smooth and balanced espresso combined with perfectly steamed milk.',35000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3b41c151-3079-4875-b669-d4747494e534','Mango Tango Frappe','Tropical and sweet mango blended drink, perfect for a hot day.',42000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3d3ba15c-da18-462e-96ed-bd7624fbd763','Cheese Babka','Savory braided bread generously filled with sharp cheddar and parmesan.',55000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('3f26a0c4-a0cb-481a-bda0-2f5bc60858f8','Vanilla Bean Frappe','Ice blended beverage made with real vanilla bean and topped with cream.',45000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4962180f-2159-422a-a874-86d35225e809','Blueberry Cheesecake','Rich baked cheesecake topped with homemade blueberry compote.',390000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4a837c05-94aa-46b9-abe2-471638c2bc51','S\'mores Cookie','Toasted marshmallow, graham cracker crumbs, and milk chocolate.',24000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('4bcc1137-92a8-45af-9f62-01221bb701ad','Double Chocolate Cookie','The ultimate chocolate lover\'s dream with cocoa dough and chocolate chunks.',18000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('50c0f6f4-4c63-4961-ab5c-a1f56a4d3f27','Classic French Baguette','Crispy crust on the outside, soft and airy crumb on the inside. Baked fresh daily.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('56d7e687-55d3-4f08-a411-fb798495ea5d','Iced Americano','Chilled espresso poured over ice and water. Bold and refreshing.',28000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('578534c3-da8c-4914-900c-5d0143ab4643','Matcha Almond Cookie','Earthy Japanese matcha flavor balanced with sliced toasted almonds.',20000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('5a62e3c6-3577-4637-a3a2-4361c08b7930','Caramel Macchiato Cake','Coffee infused cake layers with salted caramel buttercream.',370000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('5eb0c11f-12ea-477d-8ee9-51ea53707ba7','Lemon Glaze Cookie','Zesty soft baked lemon cookie topped with a sweet citrus glaze.',17000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('61c50711-b62d-4f70-90dc-362597eb9097','Brownie Cookie','Brookies - half fudgy brownie, half chewy chocolate chip cookie.',20000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6737317e-8b8a-437d-9c6d-f5fa7fa84b0a','Macadamia White Choco','Sweet white chocolate chips paired with crunchy roasted macadamia nuts.',22000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6a261a9f-61b7-4e7e-9bb1-cf19f9005e16','Olive Bread','Artisan loaf studded with Kalamata olives and rosemary.',45000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6a754251-36c0-4052-a313-bf23a9adbde1','Milk Toast Bread','Japanese Shokupan, extremely fluffy and sweet milk bread loaf.',35000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('6f522662-d68c-474a-a50f-d75375196421','Dirty Matcha','Iced matcha latte topped with a bold shot of espresso.',48000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('70b64611-faad-435f-b119-de449a6f908b','Choco Mint Cake','Refreshing peppermint frosting layered between rich dark chocolate cake.',360000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('722f1dc6-25cb-4528-ab5a-1020cf08e72e','Peach Iced Tea','Refreshing black tea infused with natural peach flavor and fruit slices.',28000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('756ba718-30ac-426d-a1c9-15ca91448309','Cheese Focaccia','Italian flatbread baked with olive oil, herbs, and melted cheddar.',38000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('76fcbb04-1050-40bf-9ca6-aa7709c2678c','Mocha Latte','The perfect blend of robust espresso and rich dark chocolate sauce.',42000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('78fa0fcd-0ce0-4ec9-9db0-55ec25660293','Multigrain Bread','Packed with sunflower seeds, flaxseeds, and oats for a healthy diet.',42000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('79c1a336-96c2-481c-9904-851328882783','Hazelnut Latte','Nutty, sweet hazelnut syrup mixed with classic espresso and milk.',42000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('814fab04-b610-4bee-919e-01771b181147','Sparkling Lemonade','Freshly squeezed lemon juice mixed with bubbly sparkling water.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8416421a-7b7a-4980-bb03-b9de26a11e20','Lychee Yakult','Sweet and tangy probiotic drink mixed with lychee syrup and jelly.',30000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('873b2de6-a19b-45e7-8e49-4154ad1df677','Vanilla Bean Sponge','Classic, simple, and elegant vanilla cake made with real vanilla beans.',250000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('8ff54eaa-dcce-4468-a5d5-0cc8ad5baceb','Red Velvet Latte','Creamy, sweet, and cake-inspired warm drink topped with cocoa powder.',40000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('933af7e8-6eac-4370-8d22-2b6874d91f39','Iced Chocolate','Rich and creamy Belgian chocolate served over ice.',38000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('96938b1d-7fb0-4d13-97e2-231f70a05f32','Chocolate Chip Cookie','Chewy edge, soft center, and loaded with gooey dark chocolate chips.',15000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9843e7ea-d73e-4e58-a05c-95efaa9adf65','Flat White','Double ristretto shot finished with velvety micro-foamed milk.',38000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9b9f84b8-68a0-4802-bfe2-56c661809a4a','Matcha Latte','Premium Japanese Uji matcha green tea blended with steamed milk.',40000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9bbec9a6-da66-4d00-94dd-a05d06e8762d','Strawberry Smoothie','Freshly blended strawberries and creamy yogurt.',40000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('9d649d4c-1616-4a82-acfa-3d7766bc67d7','Shortbread Cookie','Buttery, crumbly, and melt-in-your-mouth Scottish classic.',14000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a17fae15-c87f-4bee-bc79-890e3727a549','Pandan Gula Melaka Cake','Local favorite pandan cake layered with palm sugar and coconut.',300000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a6261253-b599-4515-b05c-73e8b4dddcbc','Carrot Cake','Spiced cake loaded with carrots and walnuts, frosted with cream cheese.',340000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('a8e6f3c6-4d54-4efd-8b2a-d925de3f9b95','Strawberry Shortcake','Light vanilla sponge layered with fresh strawberries and whipped cream.',320000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ae567339-3dfc-45c7-a42a-b770f4e80955','Cold Brew Coffee','Steeped slowly for 18 hours for a smooth, low-acid coffee experience.',35000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('b1ddae12-627c-4484-9431-820e6c9f0c6f','Pistachio Cranberry','Festive and nutty cookie with bright dried cranberries.',22000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ba37d948-5675-48d7-8e68-7764cdbdb4e3','Earl Grey Milk Tea','Fragrant Earl Grey black tea brewed and mixed with creamy milk.',32000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('bbefd010-8f1b-425d-8742-fd81f5e75d43','Lotus Biscoff Cheesecake','New York cheesecake infused and topped with Speculoos cookie butter.',400000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c0ebe380-dc94-46df-831a-55e3bf66a541','Coconut Macaroon','Chewy coconut drops, baked until golden and dipped in dark chocolate.',18000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c7bd0d95-50c9-4e43-ba2b-01abdb0d2a13','Red Velvet Cookie','Vibrant red velvet dough studded with creamy white chocolate chips.',18000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c8b295dc-7988-4d21-9cd8-c5d81c7de1ec','Almond Biscotti','Crunchy twice-baked Italian cookie, perfect for dipping in coffee.',20000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('c8fa35da-126b-4f31-9844-29b4127765be','Peanut Butter Cookie','Classic, crumbly, and rich peanut butter flavor with a fork-pressed top.',16000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cadd0188-73a1-4bd9-9307-fe552bb2ff7e','Mango Mousse Cake','Light, tropical, and refreshing mango mousse on a sponge base.',330000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cbd16cc0-2a43-4bf4-bef1-eeb483fe2a69','Hazelnut Praline Cake','Nutty and rich layered cake with crunchy hazelnut praline.',410000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('cdb5d687-7ed1-410e-af70-ca3e40de2d15','Rye Bread','Dense, dark, and flavorful European style bread.',40000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('da8775ae-418d-428a-b41b-e7b2595052cf','Black Forest','Classic cherry and chocolate layered cake with whipped cream.',350000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('dc234fbe-9d4f-4be9-9702-4d9e8b322784','New York Cheesecake','Creamy, dense baked cheesecake with a buttery graham cracker crust.',380000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('dc95a184-2560-4282-985c-3a1d1bb30a00','Raspberry Tart','Sweet pastry crust filled with custard and topped with fresh raspberries.',220000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e12381bb-7af3-4805-91c7-09b2ae7a414e','Funfetti Sugar Cookie','Soft and chewy sugar cookie baked with colorful rainbow sprinkles.',15000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e2072f48-96dc-4cdd-984e-7a0d5b40cf79','Dark Chocolate Truffle Cake','Rich, decadent chocolate sponge layered with smooth chocolate ganache.',400000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e4e47040-e4f3-44e1-87cd-38f8a9be801b','Chocolate Babka','Rich braided sweet bread filled with premium dark chocolate swirls.',55000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e54946ea-5d19-4312-a1ff-b57fb1e5b9fa','Whole Wheat Loaf','Healthy and nutritious loaf made with 100% whole wheat flour.',30000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e682f57d-0fad-41e1-ba78-bbc288a563f5','Tiramisu Cake','Coffee-soaked ladyfingers layered with a light mascarpone cream.',360000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('e99e1d40-622a-481c-a3c2-8e16e7d6b93d','Classic Red Velvet Cake','Moist layers of red velvet cake filled and topped with cream cheese frosting.',350000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ea339584-26d7-4798-a4eb-bd5d117e04b4','Ciabatta','Rustic Italian bread with a porous crumb, perfect for gourmet panini.',25000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ea55a2d8-f3a2-4a82-a160-2a967b35fd83','Almond Croissant','Twice-baked croissant filled and topped with sweet almond frangipane.',30000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('ec6a319f-763e-4c2b-a970-95c2a68b809d','Caramel Macchiato','Espresso layered with vanilla, milk, and a sweet caramel drizzle.',45000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('f71792bc-c2b3-4956-bdf2-a4c5013c3b18','Matcha Mille Crepe','20 layers of paper-thin crepes filled with premium Uji matcha cream.',420000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('fd8fb1c7-143f-4ebb-87f9-db2bb122f98d','Espresso Chocolate Cookie','Coffee infused cookie dough loaded with dark chocolate chunks.',19000.00,'ACTIVE',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` varchar(36) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
('8d9d1d7d-a839-43b3-aacd-fd93c86acc55','CUSTOMER','Default customer role','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL),
('b3627e56-4fd7-4b1d-a78d-3d39f766bb0a','ADMIN','Administrator role with full access','2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `role_id` varchar(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  `email` varchar(100) NOT NULL DEFAULT '',
  `phone_number` varchar(20) NOT NULL DEFAULT '',
  `profile_picture_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_role` (`role_id`),
  KEY `idx_users_username` (`username`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('1fbbc9dc-9418-4ad7-b891-ca484ccaa112','8d9d1d7d-a839-43b3-aacd-fd93c86acc55','customer','$2a$10$yDoPAbfitzR2hbWifyLfJuox8HWe637tWyE8CTUIHCW9wvcqUNGU6',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL,'customer@bakery.com','+6281234567891',NULL),
('a31ed809-f754-4838-ace0-ba49d5eec439','b3627e56-4fd7-4b1d-a78d-3d39f766bb0a','irsyad','$2a$10$dDWb/SOVsd7aKpMg7Y/TKeXFewz3QT4svh3.xkVsPCWwLqJAW1Fha',0,NULL,'2026-07-31 01:04:37','2026-07-31 01:04:37',NULL,NULL,'admin@bakery.com','+6281234567890',NULL);
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

-- Dump completed on 2026-07-31 20:16:07
