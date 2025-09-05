-- NebulaBan Database Schema
-- Execute this SQL script in your MySQL database before using the resource

-- Main ban records table
CREATE TABLE IF NOT EXISTS `nebula_bans` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `ban_id` varchar(16) NOT NULL UNIQUE,
    `player_name` varchar(50) NOT NULL,
    `ban_reason` text NOT NULL,
    `banned_by` varchar(50) NOT NULL,
    `ban_date` int(11) NOT NULL,
    `ban_expire` int(11) DEFAULT NULL,
    `unban_date` int(11) DEFAULT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    INDEX `idx_ban_id` (`ban_id`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Steam identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_steams` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- License identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_licenses` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Discord identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_discords` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- IP addresses ban table
CREATE TABLE IF NOT EXISTS `banned_ips` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- FiveM identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_fivems` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Xbox Live identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_xbls` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Live identifiers ban table
CREATE TABLE IF NOT EXISTS `banned_lives` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player tokens ban table
CREATE TABLE IF NOT EXISTS `banned_tokens` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(200) NOT NULL,
    `ban_id` varchar(16) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_ban_id` (`ban_id`),
    FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
