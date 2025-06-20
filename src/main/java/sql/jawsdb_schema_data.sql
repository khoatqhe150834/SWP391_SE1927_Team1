﻿
USE `ogmitaw4ik7g14kd`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: spamanagement
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL COMMENT 'ID khách hàng nhận dịch vụ cho lịch hẹn cụ thể này',
  `booking_group_id` int DEFAULT NULL COMMENT 'Liên kết đến nhóm đặt lịch nếu đây là một phần của đặt lịch nhóm',
  `therapist_user_id` int DEFAULT NULL COMMENT 'ID kỹ thuật viên từ bảng Users',
  `service_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `original_service_price` decimal(12,2) NOT NULL,
  `discount_amount_applied` decimal(12,2) DEFAULT '0.00',
  `final_price_after_discount` decimal(12,2) NOT NULL,
  `points_redeemed_value` decimal(12,2) DEFAULT '0.00',
  `final_amount_payable` decimal(12,2) NOT NULL,
  `promotion_id` int DEFAULT NULL,
  `status` enum('PENDING_CONFIRMATION','CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED_BY_CUSTOMER','CANCELLED_BY_SPA','NO_SHOW') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_CONFIRMATION',
  `payment_status` enum('UNPAID','PARTIALLY_PAID','PAID','REFUNDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNPAID',
  `notes_by_customer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes_by_staff` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancel_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_from_cart_item_id` int DEFAULT NULL COMMENT 'Nếu lịch hẹn được tạo từ một mục trong giỏ hàng',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  KEY `customer_id` (`customer_id`),
  KEY `booking_group_id` (`booking_group_id`),
  KEY `therapist_user_id` (`therapist_user_id`),
  KEY `service_id` (`service_id`),
  KEY `promotion_id` (`promotion_id`),
  KEY `created_from_cart_item_id` (`created_from_cart_item_id`),
  KEY `idx_appointment_times` (`start_time`,`end_time`),
  KEY `idx_appointment_status` (`status`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups` (`booking_group_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_4` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE RESTRICT,
  CONSTRAINT `appointments_ibfk_5` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_6` FOREIGN KEY (`created_from_cart_item_id`) REFERENCES `cart_items` (`cart_item_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (5,1,NULL,3,2,'2025-06-05 14:00:00','2025-06-05 15:30:00',700000.00,0.00,700000.00,0.00,700000.00,NULL,'CONFIRMED','UNPAID','Mong được thư giãn tốt nhất.','Khách quen, đã chuẩn bị phòng VIP.',NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,2,NULL,4,3,'2025-06-03 10:00:00','2025-06-03 11:00:00',400000.00,0.00,400000.00,50000.00,350000.00,NULL,'COMPLETED','PAID','Da tôi hơi nhạy cảm.','Sử dụng sản phẩm dịu nhẹ.',NULL,NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(7,3,1,3,1,'2025-06-12 15:00:00','2025-06-12 16:00:00',500000.00,100000.00,400000.00,0.00,400000.00,1,'PENDING_CONFIRMATION','UNPAID','Đây là 1 trong 4 suất của nhóm.',NULL,NULL,NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(8,6,NULL,NULL,6,'2025-06-04 11:00:00','2025-06-04 12:00:00',300000.00,0.00,300000.00,0.00,300000.00,NULL,'CANCELLED_BY_CUSTOMER','UNPAID','Đặt qua điện thoại.',NULL,'Khách báo bận đột xuất',NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_categories`
--

DROP TABLE IF EXISTS `blog_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_categories` (
  `blog_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`blog_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `blog_categories_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`blog_id`) ON DELETE CASCADE,
  CONSTRAINT `blog_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_categories`
--

LOCK TABLES `blog_categories` WRITE;
/*!40000 ALTER TABLE `blog_categories` DISABLE KEYS */;
INSERT INTO `blog_categories` VALUES (1,4),(2,4),(3,5);
/*!40000 ALTER TABLE `blog_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `author_user_id` int NOT NULL COMMENT 'User nhân viên viết bài',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `feature_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','PUBLISHED','SCHEDULED','ARCHIVED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `published_at` datetime DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`blog_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `author_user_id` (`author_user_id`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,2,'5 Lợi Ích Tuyệt Vời Của Massage Thường Xuyên','5-loi-ich-tuyet-voi-cua-massage-thuong-xuyen','Khám phá những lợi ích sức khỏe không ngờ tới từ việc massage định kỳ.','Nội dung chi tiết về 5 lợi ích của massage... (HTML/Markdown)','https://placehold.co/600x400/B2DFEE/333333?text=BlogMassage','PUBLISHED','2025-06-01 16:40:23',150,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,2,'Bí Quyết Sở Hữu Làn Da Căng Bóng Mùa Hè','bi-quyet-so-huu-lan-da-cang-bong-mua-he','Những mẹo chăm sóc da đơn giản mà hiệu quả giúp bạn tự tin tỏa sáng trong mùa hè.','Nội dung chi tiết về bí quyết chăm sóc da mùa hè... (HTML/Markdown)','https://placehold.co/600x400/FFDAB9/333333?text=BlogSkincare','PUBLISHED','2025-06-01 16:40:23',220,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,1,'Chương Trình Khuyến Mãi Mới Tại Spa','chuong-trinh-khuyen-mai-moi-tai-spa','Thông báo về các gói ưu đãi hấp dẫn sắp ra mắt.','Nội dung chi tiết về chương trình khuyến mãi... (HTML/Markdown)','https://placehold.co/600x400/98FB98/333333?text=BlogPromo','DRAFT',NULL,0,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_groups`
--

DROP TABLE IF EXISTS `booking_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_groups` (
  `booking_group_id` int NOT NULL AUTO_INCREMENT,
  `represent_customer_id` int NOT NULL COMMENT 'ID của khách hàng đứng ra đại diện đặt lịch cho nhóm',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tên gợi nhớ cho nhóm đặt lịch (ví dụ: Sinh nhật bạn A)',
  `expected_pax` int NOT NULL DEFAULT '1' COMMENT 'Số lượng người dự kiến trong nhóm',
  `group_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú chung cho cả nhóm đặt lịch',
  `status` enum('PENDING_CONFIRMATION','FULLY_CONFIRMED','PARTIALLY_CONFIRMED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING_CONFIRMATION' COMMENT 'Trạng thái của toàn bộ nhóm đặt lịch',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_group_id`),
  KEY `represent_customer_id` (`represent_customer_id`),
  CONSTRAINT `booking_groups_ibfk_1` FOREIGN KEY (`represent_customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_groups`
--

LOCK TABLES `booking_groups` WRITE;
/*!40000 ALTER TABLE `booking_groups` DISABLE KEYS */;
INSERT INTO `booking_groups` VALUES (1,3,'Sinh nhật Lan',4,'Nhóm bạn thân, muốn các phòng gần nhau.','PENDING_CONFIRMATION','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,1,'Thư giãn cuối tuần',2,'Cặp đôi, yêu cầu phòng đôi.','PENDING_CONFIRMATION','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `booking_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_hours` (
  `business_hour_id` int NOT NULL AUTO_INCREMENT,
  `day_of_week` enum('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `open_time` time DEFAULT NULL COMMENT 'Giờ mở cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `close_time` time DEFAULT NULL COMMENT 'Giờ đóng cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE nếu spa đóng cửa cả ngày vào ngày này trong tuần',
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ghi chú ví dụ: giờ hoạt động đặc biệt cho ngày lễ',
  PRIMARY KEY (`business_hour_id`),
  UNIQUE KEY `uq_day_of_week` (`day_of_week`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_hours`
--

LOCK TABLES `business_hours` WRITE;
/*!40000 ALTER TABLE `business_hours` DISABLE KEYS */;
INSERT INTO `business_hours` VALUES (1,'MONDAY','09:00:00','21:00:00',0,NULL),(2,'TUESDAY','09:00:00','21:00:00',0,NULL),(3,'WEDNESDAY','09:00:00','21:00:00',0,NULL),(4,'THURSDAY','09:00:00','21:00:00',0,NULL),(5,'FRIDAY','09:00:00','22:00:00',0,'Mở cửa muộn hơn'),(6,'SATURDAY','09:00:00','22:00:00',0,'Mở cửa muộn hơn'),(7,'SUNDAY','10:00:00','20:00:00',0,NULL);
/*!40000 ALTER TABLE `business_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `cart_item_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `service_id` int NOT NULL COMMENT 'ID của dịch vụ được thêm vào giỏ',
  `quantity` int NOT NULL DEFAULT '1' COMMENT 'Số lượng dịch vụ này (ví dụ: 2 suất massage cho 2 người)',
  `price_at_addition` decimal(12,2) NOT NULL COMMENT 'Giá dịch vụ tại thời điểm thêm vào giỏ',
  `therapist_user_id_preference` int DEFAULT NULL COMMENT 'Ưu tiên kỹ thuật viên cho dịch vụ',
  `preferred_start_time_slot` datetime DEFAULT NULL COMMENT 'Ưu tiên thời gian cho dịch vụ (cần kiểm tra lại khi đặt lịch)',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú của khách hàng cho mục này',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_converted_to_appointment` tinyint(1) DEFAULT '0' COMMENT 'Đánh dấu nếu mục này đã được chuyển thành lịch hẹn',
  PRIMARY KEY (`cart_item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `service_id` (`service_id`),
  KEY `therapist_user_id_preference` (`therapist_user_id_preference`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `shopping_carts` (`cart_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_3` FOREIGN KEY (`therapist_user_id_preference`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (1,1,2,1,700000.00,3,'2025-06-10 14:00:00','Xin phòng riêng nếu có thể.','2025-06-01 09:40:23',1),(2,1,6,1,300000.00,NULL,'2025-06-10 16:00:00',NULL,'2025-06-01 09:40:23',0),(3,2,1,1,500000.00,NULL,NULL,'Đặt cho buổi chiều.','2025-06-01 09:40:23',0),(4,3,3,2,400000.00,4,'2025-05-28 10:00:00','Cho 2 người.','2025-05-30 09:40:23',0);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `parent_category_id` int DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_type` enum('SERVICE','BLOG_POST') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Loại module mà category này thuộc về',
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_category_id` (`parent_category_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,'Massage','massage','Các dịch vụ massage thư giãn và trị liệu','https://placehold.co/200x150/AFEEEE/333333?text=MassageCat','SERVICE',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,NULL,'Chăm Sóc Da','cham-soc-da','Dịch vụ chăm sóc da mặt và toàn thân','https://placehold.co/200x150/FFEFD5/333333?text=SkinCareCat','SERVICE',1,2,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,2,'Da Mặt','da-mat','Chăm sóc chuyên sâu cho da mặt','https://placehold.co/200x150/FFE4E1/333333?text=FacialCat','SERVICE',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,NULL,'Mẹo Chăm Sóc Sức Khỏe','meo-cham-soc-suc-khoe','Bài viết về cách chăm sóc sức khỏe và sắc đẹp','https://placehold.co/200x150/F5DEB3/333333?text=HealthTips','BLOG_POST',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,NULL,'Tin Tức Spa','tin-tuc-spa','Cập nhật thông tin mới nhất từ spa','https://placehold.co/200x150/D2B48C/333333?text=SpaNews','BLOG_POST',1,2,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_sent_notifications`
--

DROP TABLE IF EXISTS `customer_sent_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_sent_notifications` (
  `sent_notification_id` int NOT NULL AUTO_INCREMENT,
  `master_notification_id` int NOT NULL,
  `recipient_customer_id` int NOT NULL COMMENT 'Customer nhận thông báo',
  `actual_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0' COMMENT 'Chỉ áp dụng nếu khách hàng có giao diện xem thông báo',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('EMAIL','SMS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kênh gửi chính cho khách hàng không có tài khoản',
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_customer_notification` (`recipient_customer_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `customer_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `customer_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_sent_notifications`
--

LOCK TABLES `customer_sent_notifications` WRITE;
/*!40000 ALTER TABLE `customer_sent_notifications` DISABLE KEYS */;
INSERT INTO `customer_sent_notifications` VALUES (4,1,1,'Xác nhận lịch hẹn #5','Lịch hẹn của bạn cho dịch vụ Massage Đá Nóng với KTV Lê Minh Cường vào lúc 14:00:00 ngày 2025-06-05 đã được XÁC NHẬN.','/appointments/view/5',5,0,NULL,'EMAIL','SENT','2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,2,2,'Nhắc lịch hẹn #6 ngày mai','Đừng quên lịch hẹn của bạn cho dịch vụ Chăm Sóc Da Cơ Bản vào 10:00:00 ngày mai (2025-06-03).','/appointments/view/6',6,1,'2025-06-02 03:05:00','SMS','DELIVERED','2025-06-02 03:00:00','2025-06-02 03:00:05','2025-06-02 03:00:00');
/*!40000 ALTER TABLE `customer_sent_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email có thể không bắt buộc. Nếu cung cấp, nên là duy nhất.',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại thường là định danh chính cho khách hàng không có tài khoản',
  `hash_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lưu mật khẩu đã được hash cho khách hàng',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Tài khoản khách hàng có hoạt động không',
  `gender` enum('MALE','FEMALE','OTHER','UNKNOWN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'UNKNOWN',
  `birthday` date DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ liên hệ',
  `loyalty_points` int DEFAULT '0',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về khách hàng',
  `role_id` int DEFAULT NULL COMMENT 'Vai trò của khách hàng, liên kết với bảng Roles',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE = Email verified, FALSE = Not verified',
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  KEY `idx_customer_phone` (`phone_number`),
  KEY `idx_customer_email` (`email`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Nguyễn Thị Mai','mai.nguyen@email.com','0988111222','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','1990-07-15','123 Đường Hoa, Quận 1, TP. HCM',250,'Khách hàng VIP, thích trà gừng.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/FFC0CB/333333?text=NTHMai',0),(2,'Trần Văn Nam','nam.tran@email.com','0977333444','$2b$10$abcdefghijklmnopqrstu',1,'MALE','1988-02-20','456 Đường Cây, Quận 3, TP. HCM',60,'Thường đặt dịch vụ massage chân.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/B0E0E6/333333?text=TVNam',0),(3,'Lê Thị Lan','lan.le@email.com','0966555666','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','1995-11-30','789 Đường Lá, Quận Bình Thạnh, TP. HCM',200,'Hay đi cùng bạn bè.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/98FB98/333333?text=LTLan',0),(4,'Phạm Văn Hùng','hung.pham@email.com','0955777888','$2b$10$abcdefghijklmnopqrstu',0,'MALE','1985-01-01','101 Đường Sông, Quận 2, TP. HCM',10,'Tài khoản không hoạt động.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/D3D3D3/333333?text=PVHung',0),(5,'Võ Thị Kim Chi','kimchi.vo@email.com','0944999000','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','2000-10-10','202 Đường Núi, Quận 7, TP. HCM',50,NULL,5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/FFE4E1/333333?text=VTKChi',0),(6,'Khách Vãng Lai A',NULL,'0912345001',NULL,1,'UNKNOWN',NULL,NULL,0,'Khách đặt qua điện thoại',NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23',NULL,0),(7,'Clementine Shields','qaxyb@mailinator.com','0075252946','$2a$10$Mg7a1qbG3Wpt5/LL1hJXdORgyMD8WFuuFS49lZKuEpf33xp6wDM0G',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-01 09:44:15','2025-06-01 09:44:15',NULL,0),(8,'Preston Reeves','wogelyvi@mailinator.com','0621707951','$2a$10$LfSiDBEkpBQh9uWhQwnW1.iG3TrMf3w0ucvWyw9GisHH.LNU63Oyy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:37:54','2025-06-02 02:37:54',NULL,0),(9,'Hector Gill','qepem@mailinator.com','0488215435','$2a$10$.GhDdGMtOZGoZsZlikXXA..J3OjZ4ka4t8iEEGEWQhRg5HXi9yESi',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:40:08','2025-06-02 02:40:08',NULL,0),(10,'John Walters','hybux@mailinator.com','0764611157','$2a$10$FIUJAcV5Tp4IGs9CD8jr5ePKbM28eoPYtMxj2egfVCtU/W8wnFQX2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:44:44','2025-06-02 02:44:44',NULL,0),(11,'Gregory Jacobs','fetoryby@mailinator.com','0868681648','$2a$10$kZUd1FfHe9.C/KOzKJZcxOL.uShM946L30qhvxDyRp39Ga0IlKj..',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:47:15','2025-06-02 02:47:15',NULL,0),(12,'Taylor Gross','jygemi@mailinator.com','0370784956','$2a$10$xfj9S0w1KsRoYkxlCK7wveQVequmL7r6bN5KifZG6m5TUO89zWata',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:49:28','2025-06-02 02:49:28',NULL,0),(14,'Kameko Leach','vadyrud@mailinator.com','0575726427','$2a$10$Ry4BL4CuoaI7Djki6.jD0eawqu/iEUt1aG/uHBqFO.yBuuiNb/Eiq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 02:53:25','2025-06-05 02:53:25',NULL,0),(15,'Geoffrey White','hudyq@mailinator.com','0838898566','$2a$10$I7NizmxcWCvvsCUQGGoFqOdtwNAWE3oaFJuakQXtCsU9/rGtI1qkq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 05:26:40','2025-06-05 05:26:40',NULL,0),(16,'Denton Holder','quangkhoa51123@gmail.com','0367449306','$2a$10$aUaZEiTGhy28V9UQF/Rj0O.MuR08s.ohvt6lflBvZA1bVxRi.H6eC',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:09','2025-06-06 15:07:09',NULL,0),(17,'Thieu Quang Khoa','begig@mailinator.com','0770634550','$2a$10$vEkr7YHufIaNKugswSNrwekQdXqrVjhGR4nnM6qhLBK1V9UCuy9di',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:35','2025-06-06 15:07:35',NULL,0),(18,'Eleanor Tran','sopehoxyq@mailinator.com','0863647205','$2a$10$1i8Jd7VQrkQk/vP/UU4A3eCfkEHF2lloVQISSj0tftLyvGruTnTBu',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:27:31','2025-06-06 15:27:31',NULL,0),(19,'Bert Keller','gimibokuk@mailinator.com','0315448491','$2a$10$ZKeSAojzxiFnpDVz6eiG1etPVrRM9vO56mjHhebgvMafG1opIeasK',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:29:58','2025-06-06 15:29:58',NULL,0),(20,'Ian Schwartz','kuwidozata@mailinator.com','0981727583','$2a$10$OiABUyWOj5psL9dnXsfOsOgFIu5tb7Si/oJwlUFsmBV5T11gbAHl2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:36:55','2025-06-06 15:36:55',NULL,0),(21,'Ian Bradshaw','hyjoz@mailinator.com','0994918210','$2a$10$k5F5H8URCFl8J.DE8XRUT.sm7jVcIBbzFhgYwy4aDbuDf80YIZIsy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:47:51','2025-06-06 15:47:51',NULL,0),(22,'Alea Compton','xapymabo@mailinator.com','0526799608','$2a$10$bqPlpJK5LWK0kKJ6LyMzlOuHepBWUuSIpQn7eJGR8hsRuNMszQRx6',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 16:41:35','2025-06-06 16:41:35',NULL,0),(60,'Emmanuel Garcia','quangkhoa51132@5dulieu.com','0567692940','$2a$10$FwTfR.8kjEt7RPzwtkneu.HUXHOLmk9DOSYsvTZPrsLfJ1YdZyv/a',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-07 13:13:13','2025-06-07 13:13:13',NULL,0),(80,'Dale Mccarthy','khoatqhe150834@gmail.com','0783791826','$2a$10$KxHxli2o9dNDcs.t6fvieO2P0ezP0ntFVeB90jlS5fJdsMsOdY.iS',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-08 13:42:37','2025-06-08 13:42:37',NULL,0),(82,'Merritt Merrill','quangkhoa5112@gmail.com','0763395150','$2a$10$qlJbnweqJwKQDA5ND/OjJuHBEIhQMYdSn8VSuaF5YKpayOzeVH9iK',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-08 14:16:34','2025-06-08 14:18:24',NULL,1);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verification_tokens`
--

DROP TABLE IF EXISTS `email_verification_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verification_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_email` (`user_email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verification_tokens`
--

LOCK TABLES `email_verification_tokens` WRITE;
/*!40000 ALTER TABLE `email_verification_tokens` DISABLE KEYS */;
INSERT INTO `email_verification_tokens` VALUES (81,'c216559d-da40-447e-b38a-a5e88f1c3b0e','quangkhoa51132@5dulieu.com','2025-06-07 13:13:15','2025-06-08 13:13:15',0),(98,'47af90ec-edb1-4b26-b3a3-fa86a2d26ac8','quangkhoa5112@gmail.com','2025-06-08 14:16:35','2025-06-09 14:16:36',1);
/*!40000 ALTER TABLE `email_verification_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general_transactions_log`
--

DROP TABLE IF EXISTS `general_transactions_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_transactions_log` (
  `transaction_log_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL COMMENT 'User (nhân viên) liên quan đến giao dịch này (ví dụ: admin điều chỉnh)',
  `customer_id` int DEFAULT NULL COMMENT 'Khách hàng liên quan đến giao dịch này',
  `related_entity_type` enum('APPOINTMENT_PAYMENT','POINT_REDEMPTION','REFUND_ONLINE','OTHER_EXPENSE','OTHER_REVENUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `transaction_code_internal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('DEBIT_SPA','CREDIT_SPA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('PENDING','COMPLETED','FAILED','CANCELLED','PARTIALLY_PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COMPLETED',
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_log_id`),
  UNIQUE KEY `transaction_code_internal` (`transaction_code_internal`),
  UNIQUE KEY `payment_id` (`payment_id`),
  KEY `user_id` (`user_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `general_transactions_log_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_transactions_log`
--

LOCK TABLES `general_transactions_log` WRITE;
/*!40000 ALTER TABLE `general_transactions_log` DISABLE KEYS */;
INSERT INTO `general_transactions_log` VALUES (5,4,NULL,2,'APPOINTMENT_PAYMENT',6,'SPA_PAY_00001','CREDIT_SPA',350000.00,'VND','Thu tiền dịch vụ Chăm Sóc Da Cơ Bản (ID: 3) cho lịch hẹn ID: 6','COMPLETED','2025-06-03 04:05:00'),(6,NULL,NULL,2,'POINT_REDEMPTION',6,'SPA_POINT_RD_00001','DEBIT_SPA',50000.00,'VND','Khách hàng Trần Văn Nam đổi 50 điểm (tương đương 50.000 VND) cho lịch hẹn ID: 6','COMPLETED','2025-06-03 04:00:00'),(7,5,NULL,1,'APPOINTMENT_PAYMENT',5,'SPA_PAY_00002','CREDIT_SPA',700000.00,'VND','Ghi nhận yêu cầu thanh toán cho dịch vụ Massage Đá Nóng (ID: 2) cho lịch hẹn ID: 5','PENDING','2025-06-05 06:00:00');
/*!40000 ALTER TABLE `general_transactions_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_point_transactions`
--

DROP TABLE IF EXISTS `loyalty_point_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_point_transactions` (
  `point_transaction_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `transaction_type` enum('EARNED_APPOINTMENT','REDEEMED_PAYMENT','ADMIN_ADJUSTMENT','EXPIRED','REFUND_POINTS','MANUAL_ADD') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_changed` int NOT NULL,
  `balance_after_transaction` int NOT NULL,
  `related_appointment_id` int DEFAULT NULL,
  `related_payment_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_user_id` int DEFAULT NULL COMMENT 'User admin thực hiện điều chỉnh điểm (nếu có)',
  PRIMARY KEY (`point_transaction_id`),
  KEY `customer_id` (`customer_id`),
  KEY `related_appointment_id` (`related_appointment_id`),
  KEY `related_payment_id` (`related_payment_id`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `loyalty_point_transactions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `loyalty_point_transactions_ibfk_2` FOREIGN KEY (`related_appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE SET NULL,
  CONSTRAINT `loyalty_point_transactions_ibfk_3` FOREIGN KEY (`related_payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `loyalty_point_transactions_ibfk_4` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_point_transactions`
--

LOCK TABLES `loyalty_point_transactions` WRITE;
/*!40000 ALTER TABLE `loyalty_point_transactions` DISABLE KEYS */;
INSERT INTO `loyalty_point_transactions` VALUES (5,2,'EARNED_APPOINTMENT',35,110,6,4,'Tích điểm từ lịch hẹn hoàn thành (10.000 VND = 1 điểm)','2025-06-03 04:10:00',NULL),(6,2,'REDEEMED_PAYMENT',-50,60,6,NULL,'Đổi 50 điểm trừ vào thanh toán lịch hẹn','2025-06-03 04:00:00',NULL),(7,1,'ADMIN_ADJUSTMENT',100,250,NULL,NULL,'Tặng điểm tri ân khách hàng VIP.','2025-06-01 09:40:23',1);
/*!40000 ALTER TABLE `loyalty_point_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_types`
--

DROP TABLE IF EXISTS `notification_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_types` (
  `notification_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên mã của loại thông báo, e.g., APPOINTMENT_CONFIRMED, BIRTHDAY_WISH',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_email_subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_email_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_sms_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_in_app_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icon_class` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_customer_facing` tinyint(1) DEFAULT '1',
  `is_staff_facing` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_types`
--

LOCK TABLES `notification_types` WRITE;
/*!40000 ALTER TABLE `notification_types` DISABLE KEYS */;
INSERT INTO `notification_types` VALUES (1,'APPOINTMENT_CONFIRMATION','Xác nhận lịch hẹn thành công','Xác nhận lịch hẹn tại An nhiên Spa','Kính chào {{customer_name}}, Lịch hẹn của bạn cho dịch vụ {{service_name}} vào lúc {{start_time}} đã được xác nhận. Mã lịch hẹn: {{appointment_id}}.','AnNhienSpa: Lich hen {{service_name}} luc {{start_time}} da duoc xac nhan. Ma LH: {{appointment_id}}. Cam on!','Lịch hẹn #{{appointment_id}} cho {{service_name}} đã được xác nhận!','fas fa-calendar-check',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'APPOINTMENT_REMINDER','Nhắc nhở lịch hẹn sắp tới','Nhắc nhở: Lịch hẹn của bạn tại An nhiên Spa sắp diễn ra','Kính chào {{customer_name}}, Nhắc bạn lịch hẹn dịch vụ {{service_name}} vào lúc {{start_time}} ngày mai. Vui lòng có mặt trước 10 phút. Trân trọng!','AnNhienSpa: Nhac ban lich hen {{service_name}} vao {{start_time}} ngay mai. Hotline: 02412345678.','Đừng quên! Lịch hẹn #{{appointment_id}} cho {{service_name}} vào {{start_time}} ngày mai.','fas fa-bell',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'NEW_APPOINTMENT_FOR_THERAPIST','Thông báo lịch hẹn mới cho KTV','Bạn có lịch hẹn mới','Chào {{therapist_name}}, Bạn có lịch hẹn mới: KH {{customer_name}}, Dịch vụ {{service_name}}, Thời gian {{start_time}} - {{end_time}}. Chi tiết xem tại hệ thống.',NULL,'Lịch hẹn mới: KH {{customer_name}} - {{service_name}} lúc {{start_time}}','fas fa-user-clock',0,1,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `notification_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications_master`
--

DROP TABLE IF EXISTS `notifications_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_master` (
  `master_notification_id` int NOT NULL AUTO_INCREMENT,
  `notification_type_id` int NOT NULL,
  `title_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tiêu đề có thể chứa placeholder',
  `content_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nội dung có thể chứa placeholder',
  `link_url_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_type_context` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., APPOINTMENT, PROMOTION, CUSTOMER, USER, BOOKING_GROUP',
  `created_by_user_id` int DEFAULT NULL COMMENT 'User (staff/admin) tạo thông báo thủ công',
  `trigger_event` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Sự kiện kích hoạt thông báo tự động',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`master_notification_id`),
  KEY `notification_type_id` (`notification_type_id`),
  KEY `created_by_user_id` (`created_by_user_id`),
  CONSTRAINT `notifications_master_ibfk_1` FOREIGN KEY (`notification_type_id`) REFERENCES `notification_types` (`notification_type_id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_master_ibfk_2` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications_master`
--

LOCK TABLES `notifications_master` WRITE;
/*!40000 ALTER TABLE `notifications_master` DISABLE KEYS */;
INSERT INTO `notifications_master` VALUES (1,1,'Xác nhận lịch hẹn #{{appointment_id}}','Lịch hẹn của bạn cho dịch vụ {{service_name}} với KTV {{therapist_name}} vào lúc {{start_time}} ngày {{appointment_date}} đã được XÁC NHẬN.','/appointments/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_STATUS_CONFIRMED','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,2,'Nhắc lịch hẹn #{{appointment_id}} ngày mai','Đừng quên lịch hẹn của bạn cho dịch vụ {{service_name}} vào {{start_time}} ngày mai ({{appointment_date}}).','/appointments/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_REMINDER_24H','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,3,'Lịch hẹn mới: {{service_name}} - {{customer_name}}','Bạn được chỉ định thực hiện dịch vụ {{service_name}} cho khách hàng {{customer_name}} (SĐT: {{customer_phone}}) vào lúc {{start_time}} ngày {{appointment_date}}.','/staff/schedule/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_ASSIGNED_TO_THERAPIST','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `notifications_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_email` (`user_email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (4,'8c09d300-9181-435b-b1e4-5c6d2faee0f1','qaxyb@mailinator.com','2025-06-03 02:10:37','2025-06-04 02:10:38',0),(37,'d115a86d-ba92-4781-9004-4a4fc169a92d','quangkhoa5112@5dulieu.com','2025-06-06 16:04:19','2025-06-07 16:04:19',0),(44,'0d3a0b97-fa55-4ab7-bf77-855bbb8bd4c1','quangkhoa51123@gmail.com','2025-06-07 14:13:13','2025-06-08 14:13:14',0);
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL COMMENT 'Liên kết với lịch hẹn đang được thanh toán',
  `customer_id` int NOT NULL COMMENT 'Khách hàng thực hiện thanh toán',
  `amount_paid` decimal(12,2) NOT NULL,
  `payment_method` enum('CREDIT_CARD','BANK_TRANSFER','VNPAY','MOMO','LOYALTY_POINTS','OTHER_ONLINE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chỉ các phương thức online và điểm',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id_gateway` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã giao dịch từ cổng thanh toán',
  `status` enum('PENDING','COMPLETED','FAILED','REFUNDED','PARTIALLY_PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Trạng thái thanh toán online',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về thanh toán, ví dụ: mã lỗi cổng thanh toán',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_id_gateway` (`transaction_id_gateway`),
  KEY `appointment_id` (`appointment_id`),
  KEY `customer_id` (`customer_id`),
  KEY `idx_payment_date` (`payment_date`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE RESTRICT,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (4,6,2,350000.00,'VNPAY','2025-06-03 04:05:00','VNPAY_TRN001','COMPLETED','Thanh toán thành công cho dịch vụ Chăm Sóc Da Cơ Bản.','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,5,1,700000.00,'MOMO','2025-06-05 06:00:00','MOMO_TRN002','PENDING','Khách hàng đã tạo yêu cầu thanh toán qua Momo.','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `promotion_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_type` enum('PERCENTAGE','FIXED_AMOUNT','FREE_SERVICE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(12,2) NOT NULL COMMENT 'Giá trị giảm (%), số tiền. Nếu FREE_SERVICE, có thể lưu service_id ở đây.',
  `applies_to_service_id` int DEFAULT NULL COMMENT 'Nếu FREE_SERVICE hoặc KM cho dịch vụ cụ thể.',
  `minimum_appointment_value` decimal(12,2) DEFAULT '0.00' COMMENT 'Giá trị tối thiểu của lịch hẹn để áp dụng KM',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` enum('SCHEDULED','ACTIVE','INACTIVE','EXPIRED','ARCHIVED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED',
  `usage_limit_per_customer` int DEFAULT NULL,
  `total_usage_limit` int DEFAULT NULL,
  `current_usage_count` int DEFAULT '0',
  `applicable_scope` enum('ALL_SERVICES','SPECIFIC_SERVICES','ENTIRE_APPOINTMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENTIRE_APPOINTMENT',
  `applicable_service_ids_json` json DEFAULT NULL COMMENT 'Mảng JSON chứa IDs của services được áp dụng',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms_and_conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_by_user_id` int DEFAULT NULL COMMENT 'User (staff/admin) tạo khuyến mãi',
  `is_auto_apply` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`promotion_id`),
  UNIQUE KEY `promotion_code` (`promotion_code`),
  KEY `created_by_user_id` (`created_by_user_id`),
  KEY `applies_to_service_id` (`applies_to_service_id`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `promotions_ibfk_2` FOREIGN KEY (`applies_to_service_id`) REFERENCES `services` (`service_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Chào Hè Rực Rỡ - Giảm 20%','Giảm giá 20% cho tất cả dịch vụ massage.','SUMMER20','PERCENTAGE',20.00,NULL,500000.00,'2025-06-01 00:00:00','2025-08-31 23:59:59','ACTIVE',1,100,10,'SPECIFIC_SERVICES','[1, 2]','https://placehold.co/400x200/FFD700/333333?text=SummerPromo','Áp dụng cho các dịch vụ massage. Không áp dụng cùng KM khác.',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'Tri Ân Khách Hàng - Tặng Voucher 100K','Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.','THANKS100K','FIXED_AMOUNT',100000.00,NULL,1000000.00,'2025-07-01 00:00:00','2025-07-31 23:59:59','SCHEDULED',1,200,0,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo','Mỗi khách hàng được sử dụng 1 lần.',2,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu','Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.','FRIENDSFREE','FREE_SERVICE',6.00,NULL,800000.00,'2025-06-15 00:00:00','2025-07-15 23:59:59','ACTIVE',1,50,5,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo','Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remember_me_tokens`
--

DROP TABLE IF EXISTS `remember_me_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remember_me_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_date` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remember_me_tokens`
--

LOCK TABLES `remember_me_tokens` WRITE;
/*!40000 ALTER TABLE `remember_me_tokens` DISABLE KEYS */;
INSERT INTO `remember_me_tokens` VALUES (11,'quangkhoa5112@5dulieu.com','123456789','0cb51cb5-2380-4033-acdc-f3cd9fa385ce','2025-07-06 09:36:14','2025-06-06 09:36:13'),(15,'manager@beautyzone.com','123456','a72c6844-678c-4baa-8984-63d90a01c798','2025-07-06 22:45:38','2025-06-06 22:45:38'),(24,'xapymabo@mailinator.com','A123456a@','aae04773-83ea-47ae-b622-9712d48c53f8','2025-07-07 08:05:55','2025-06-07 08:05:54'),(59,'quangkhoa5112@gmail.com','123456','4455d282-4ed2-4582-8cc3-470b14fb70a0','2025-07-08 21:18:30','2025-06-08 21:18:30');
/*!40000 ALTER TABLE `remember_me_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên vai trò (system name, e.g., ADMIN, MANAGER, THERAPIST)',
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên hiển thị của vai trò',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả vai trò',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN','Quản trị viên','Quản lý toàn bộ hệ thống','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'MANAGER','Quản lý Spa','Quản lý hoạt động hàng ngày của spa','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'THERAPIST','Kỹ thuật viên','Thực hiện các dịch vụ cho khách hàng','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,'RECEPTIONIST','Lễ tân','Tiếp đón khách, đặt lịch, thu ngân','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,'CUSTOMER','Khách hàng đã đăng ký','Khách hàng có tài khoản trên hệ thống','2025-06-01 09:40:23','2025-06-04 04:20:04');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_categories`
--

DROP TABLE IF EXISTS `service_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_categories` (
  `service_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`service_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `service_categories_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_categories`
--

LOCK TABLES `service_categories` WRITE;
/*!40000 ALTER TABLE `service_categories` DISABLE KEYS */;
INSERT INTO `service_categories` VALUES (1,1),(2,1),(6,1),(3,2),(4,2),(5,2),(3,3),(4,3);
/*!40000 ALTER TABLE `service_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_reviews`
--

DROP TABLE IF EXISTS `service_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `service_id` int NOT NULL COMMENT 'ID dịch vụ được đánh giá (để tiện truy vấn)',
  `customer_id` int NOT NULL COMMENT 'ID khách hàng đánh giá (để tiện truy vấn)',
  `appointment_id` int NOT NULL COMMENT 'ID của lịch hẹn đã hoàn thành mà review này dành cho.',
  `rating` tinyint unsigned NOT NULL COMMENT 'Điểm đánh giá (1-5)',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `appointment_id` (`appointment_id`),
  KEY `service_id` (`service_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `service_reviews_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_3` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_reviews`
--

LOCK TABLES `service_reviews` WRITE;
/*!40000 ALTER TABLE `service_reviews` DISABLE KEYS */;
INSERT INTO `service_reviews` VALUES (4,3,2,6,5,'Rất hài lòng!','Dịch vụ chăm sóc da rất tốt, da tôi cải thiện rõ rệt. Kỹ thuật viên Dung rất nhiệt tình.','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `service_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_types` (
  `service_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên loại dịch vụ',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1,'Massage Thư Giãn','Các liệu pháp massage giúp thư giãn cơ thể và tinh thần.','https://placehold.co/300x200/E0FFFF/333333?text=Massage',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'Chăm Sóc Da Mặt','Dịch vụ chăm sóc và cải thiện làn da mặt.','https://placehold.co/300x200/FFFACD/333333?text=Facial',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'Chăm Sóc Toàn Thân','Các liệu pháp chăm sóc cơ thể toàn diện.','https://placehold.co/300x200/F5FFFA/333333?text=BodyCare',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,'Dịch Vụ Gội Đầu Dưỡng Sinh','Gội đầu kết hợp massage cổ vai gáy.','https://placehold.co/300x200/FFEBCD/333333?text=HairWash',1,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_type_id` int NOT NULL COMMENT 'Loại dịch vụ mà dịch vụ này thuộc về',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL,
  `duration_minutes` int NOT NULL COMMENT 'Thời gian thực hiện dịch vụ (phút)',
  `buffer_time_after_minutes` int DEFAULT '0' COMMENT 'Thời gian đệm sau dịch vụ (phút), ví dụ dọn dẹp',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `bookable_online` tinyint(1) DEFAULT '1' COMMENT 'Dịch vụ này có thể đặt online qua giỏ hàng/hệ thống không',
  `requires_consultation` tinyint(1) DEFAULT '0' COMMENT 'Dịch vụ này có cần tư vấn trước khi đặt không',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,1,'Massage Thụy Điển','Massage cổ điển giúp giảm căng thẳng, tăng cường lưu thông máu.',500000.00,60,15,'https://placehold.co/300x200/ADD8E6/333333?text=SwedishMassage',1,4.50,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,1,'Massage Đá Nóng','Sử dụng đá nóng bazan giúp thư giãn sâu các cơ bắp.',700000.00,90,15,'https://placehold.co/300x200/F0E68C/333333?text=HotStone',1,4.80,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,2,'Chăm Sóc Da Cơ Bản','Làm sạch sâu, tẩy tế bào chết, đắp mặt nạ dưỡng ẩm.',400000.00,60,10,'https://placehold.co/300x200/E6E6FA/333333?text=BasicFacial',1,5.00,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,2,'Trị Mụn Chuyên Sâu','Liệu trình trị mụn, giảm viêm, ngăn ngừa tái phát.',650000.00,75,20,'https://placehold.co/300x200/FFDAB9/333333?text=AcneTreatment',1,4.00,1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,3,'Tẩy Tế Bào Chết Toàn Thân','Loại bỏ tế bào chết, giúp da mịn màng, tươi sáng.',450000.00,45,10,'https://placehold.co/300x200/90EE90/333333?text=BodyScrub',1,4.60,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,4,'Gội Đầu Thảo Dược','Gội đầu bằng thảo dược thiên nhiên, massage thư giãn.',300000.00,60,10,'https://placehold.co/300x200/FFE4B5/333333?text=HerbalHairWash',1,4.70,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_carts`
--

DROP TABLE IF EXISTS `shopping_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_carts` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL COMMENT 'Liên kết với khách hàng nếu đã đăng nhập/xác định',
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dùng cho khách vãng lai chưa đăng nhập',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('ACTIVE','ABANDONED','CONVERTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE' COMMENT 'CONVERTED khi các mục đã được chuyển thành lịch hẹn/yêu cầu',
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `uq_customer_active_cart` (`customer_id`,`status`),
  KEY `idx_cart_session_id` (`session_id`),
  CONSTRAINT `shopping_carts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_carts`
--

LOCK TABLES `shopping_carts` WRITE;
/*!40000 ALTER TABLE `shopping_carts` DISABLE KEYS */;
INSERT INTO `shopping_carts` VALUES (1,1,NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23','ACTIVE'),(2,NULL,'sess_abc123xyz789','2025-06-01 09:40:23','2025-06-01 09:40:23','ACTIVE'),(3,2,NULL,'2025-05-30 09:40:23','2025-05-30 09:40:23','ABANDONED');
/*!40000 ALTER TABLE `shopping_carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spa_information`
--

DROP TABLE IF EXISTS `spa_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spa_information` (
  `spa_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên Spa',
  `address_line1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Địa chỉ dòng 1',
  `address_line2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ dòng 2',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Thành phố',
  `postal_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã bưu điện',
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Quốc gia',
  `phone_number_main` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại chính',
  `phone_number_secondary` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số điện thoại phụ',
  `email_main` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email liên hệ chính',
  `email_secondary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email phụ',
  `website_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ website',
  `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL của logo',
  `tax_identification_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã số thuế',
  `cancellation_policy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Chính sách hủy lịch hẹn',
  `booking_terms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Điều khoản đặt lịch',
  `about_us_short` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả ngắn về spa',
  `about_us_long` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả chi tiết về spa',
  `vat_percentage` decimal(5,2) DEFAULT '0.00' COMMENT 'Phần trăm thuế VAT nếu có',
  `default_appointment_buffer_minutes` int DEFAULT '15' COMMENT 'Thời gian đệm mặc định giữa các lịch hẹn',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`spa_id`),
  UNIQUE KEY `uq_spa_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spa_information`
--

LOCK TABLES `spa_information` WRITE;
/*!40000 ALTER TABLE `spa_information` DISABLE KEYS */;
INSERT INTO `spa_information` VALUES (1,'BeautyZone','Số 10 Đường An Bình','Phường Yên Hòa','Hà Nội','100000','Việt Nam','02412345678','0912345678','contact@annhienspa.vn','support@annhienspa.vn','https://annhienspa.vn','https://placehold.co/200x100/E6F2FF/333333?text=AnNhienLogo','0123456789','Vui lòng hủy lịch trước 24 giờ để tránh phí hủy. Chi tiết xem tại website.','Điều khoản đặt lịch chi tiết có tại quầy lễ tân và website của spa.','Nơi bạn tìm thấy sự thư giãn và tái tạo năng lượng.','An nhiên Spa cung cấp các dịch vụ chăm sóc sức khỏe và sắc đẹp hàng đầu với đội ngũ chuyên nghiệp và không gian yên tĩnh.',8.00,15,'2025-06-01 09:40:23','2025-06-04 15:18:58');
/*!40000 ALTER TABLE `spa_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `therapist_schedules`
--

DROP TABLE IF EXISTS `therapist_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapist_schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `therapist_user_id` int NOT NULL COMMENT 'FK đến Users.user_id của kỹ thuật viên',
  `start_datetime` datetime NOT NULL COMMENT 'Thời gian bắt đầu của ca làm việc hoặc khoảng thời gian cụ thể',
  `end_datetime` datetime NOT NULL COMMENT 'Thời gian kết thúc của ca làm việc hoặc khoảng thời gian cụ thể',
  `is_available` tinyint(1) DEFAULT '1' COMMENT 'TRUE nếu làm việc, FALSE nếu là giờ nghỉ đã đăng ký trong ca',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ví dụ: Ca sáng, Ca chiều, Nghỉ đột xuất, Họp',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`schedule_id`),
  KEY `idx_therapist_schedule_datetimes` (`therapist_user_id`,`start_datetime`,`end_datetime`),
  CONSTRAINT `therapist_schedules_ibfk_1` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapist_schedules`
--

LOCK TABLES `therapist_schedules` WRITE;
/*!40000 ALTER TABLE `therapist_schedules` DISABLE KEYS */;
INSERT INTO `therapist_schedules` VALUES (5,3,'2025-06-05 09:00:00','2025-06-05 18:00:00',1,'Ca làm việc ngày 05/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,3,'2025-06-06 09:00:00','2025-06-06 12:00:00',1,'Ca sáng ngày 06/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(7,3,'2025-06-06 12:00:00','2025-06-06 13:00:00',0,'Nghỉ trưa','2025-06-01 09:40:23','2025-06-01 09:40:23'),(8,3,'2025-06-06 13:00:00','2025-06-06 18:00:00',1,'Ca chiều ngày 06/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(9,4,'2025-06-05 13:00:00','2025-06-05 21:00:00',1,'Ca làm việc ngày 05/06','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `therapist_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `therapists`
--

DROP TABLE IF EXISTS `therapists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapists` (
  `user_id` int NOT NULL COMMENT 'Liên kết với Users.user_id',
  `service_type_id` int DEFAULT NULL COMMENT 'Loại dịch vụ chính mà kỹ thuật viên chuyên trách',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Tiểu sử ngắn',
  `availability_status` enum('AVAILABLE','BUSY','OFFLINE','ON_LEAVE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'AVAILABLE' COMMENT 'Trạng thái tổng quan, không phải lịch chi tiết',
  `years_of_experience` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `therapists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `therapists_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapists`
--

LOCK TABLES `therapists` WRITE;
/*!40000 ALTER TABLE `therapists` DISABLE KEYS */;
INSERT INTO `therapists` VALUES (3,1,'Chuyên gia massage trị liệu với 5 năm kinh nghiệm. Am hiểu các kỹ thuật massage Thụy Điển và đá nóng.','AVAILABLE',5,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,2,'Kỹ thuật viên chăm sóc da mặt, đặc biệt có kinh nghiệm trong điều trị mụn và trẻ hóa da.','AVAILABLE',3,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `therapists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sent_notifications`
--

DROP TABLE IF EXISTS `user_sent_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sent_notifications` (
  `sent_notification_id` int NOT NULL AUTO_INCREMENT,
  `master_notification_id` int NOT NULL,
  `recipient_user_id` int NOT NULL COMMENT 'User nhân viên nhận thông báo',
  `actual_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('IN_APP','EMAIL','SMS','PUSH_NOTIFICATION') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED','VIEWED_IN_APP') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_user_notification` (`recipient_user_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `user_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `user_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sent_notifications`
--

LOCK TABLES `user_sent_notifications` WRITE;
/*!40000 ALTER TABLE `user_sent_notifications` DISABLE KEYS */;
INSERT INTO `user_sent_notifications` VALUES (3,3,3,'Lịch hẹn mới: Massage Đá Nóng - Nguyễn Thị Mai','Bạn được chỉ định thực hiện dịch vụ Massage Đá Nóng cho khách hàng Nguyễn Thị Mai (SĐT: 0988111222) vào lúc 14:00:00 ngày 2025-06-05.','/staff/schedule/view/5',5,0,NULL,'IN_APP','VIEWED_IN_APP','2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,3,4,'Lịch hẹn mới: Chăm Sóc Da Cơ Bản - Trần Văn Nam','Bạn được chỉ định thực hiện dịch vụ Chăm Sóc Da Cơ Bản cho khách hàng Trần Văn Nam (SĐT: 0977333444) vào lúc 10:00:00 ngày 2025-06-03.','/staff/schedule/view/6',6,1,'2025-06-02 02:30:00','EMAIL','SENT','2025-06-02 02:25:00','2025-06-02 02:25:05','2025-06-02 02:25:00');
/*!40000 ALTER TABLE `user_sent_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lưu mật khẩu đã được hash',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Tài khoản có hoạt động không',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT 'Thời điểm đăng nhập cuối',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Nguyễn Văn An','quangkhoa5112@5dulieu.com','$2a$10$Q8m8OY5RIEWeo1alSpOx1up8kZLEz.QDkfiKfyBlbO3GN0ySqwEm.','0912345678','MALE','1980-01-15','https://placehold.co/100x100/E6E6FA/333333?text=NVAn',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-05 02:51:26'),(2,2,'Trần Thị Bình','manager@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0987654321','FEMALE','1985-05-20','https://placehold.co/100x100/FFF0F5/333333?text=TTBinh',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,3,'Lê Minh Cường','therapist1@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0905112233','MALE','1990-09-10','https://placehold.co/100x100/F0FFF0/333333?text=LMCuong',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,3,'Phạm Thị Dung','therapist2@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0905445566','FEMALE','1992-12-01','https://placehold.co/100x100/FAFAD2/333333?text=PTDung',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,4,'Hoàng Văn Em','receptionist@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0918778899','MALE','1995-03-25','https://placehold.co/100x100/ADD8E6/333333?text=HVEm',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,1,'Nguyễn Văn Admin','admin@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234567','MALE','1985-01-15','/assets/avatars/admin.jpg',1,NULL,'2025-06-04 03:47:10','2025-06-04 03:47:10'),(7,2,'Trần Thị Manager','manager@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234568','FEMALE','1988-03-20','/assets/avatars/manager.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(8,3,'Lê Văn Therapist','therapist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234569','MALE','1990-07-10','/assets/avatars/therapist.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(9,4,'Phạm Thị Receptionist','receptionist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234570','FEMALE','1992-11-25','/assets/avatars/receptionist.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(10,1,'Hoàng Minh Quản Trị','admin2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234571','MALE','1987-05-12','/assets/avatars/admin2.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(11,3,'Nguyễn Thị Spa Master','therapist2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234572','FEMALE','1989-09-18','/assets/avatars/therapist2.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48');
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

-- Dump completed on 2025-06-10  8:32:28
