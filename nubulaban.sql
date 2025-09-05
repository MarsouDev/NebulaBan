-- =========================================
-- NebulaBan SQL Schema (Pro Refactor - English)
-- Author: marsou13k
-- Description: Database schema for FiveM ban system
-- =========================================

-- -------------------------------
-- Main bans table
-- -------------------------------
DROP TABLE IF EXISTS `nebula_bans`;
CREATE TABLE IF NOT EXISTS `nebula_bans` (
    `ban_id` VARCHAR(60) NOT NULL PRIMARY KEY,      -- Unique ban identifier
    `player_name` VARCHAR(64) DEFAULT NULL,        -- Player name
    `ban_reason` VARCHAR(255) DEFAULT NULL,        -- Reason for the ban
    `banned_by` VARCHAR(64) DEFAULT NULL,          -- Who issued the ban
    `ban_date` BIGINT NOT NULL,                    -- Timestamp of ban
    `ban_expire` BIGINT DEFAULT NULL,              -- Timestamp of expiration (NULL = permanent)
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,    -- Is the ban active?
    `unban_date` BIGINT DEFAULT NULL,              -- Timestamp of unban
    `unban_reason` VARCHAR(255) DEFAULT NULL,     -- Reason for unban
    `unbanned_by` VARCHAR(64) DEFAULT NULL,       -- Who unbanned the player
    INDEX `idx_active` (`is_active`),
    INDEX `idx_ban_date` (`ban_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------
-- Generic banned identifiers tables
-- -------------------------------
-- Each table stores a specific type of identifier and links to nebula_bans
-- Primary key on identifier to avoid duplicates
-- Index on ban_id for fast queries

-- Steam IDs
DROP TABLE IF EXISTS `banned_steams`;
CREATE TABLE IF NOT EXISTS `banned_steams` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_steams_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Licenses
DROP TABLE IF EXISTS `banned_licenses`;
CREATE TABLE IF NOT EXISTS `banned_licenses` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_licenses_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Discord IDs
DROP TABLE IF EXISTS `banned_discords`;
CREATE TABLE IF NOT EXISTS `banned_discords` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_discords_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- IPs
DROP TABLE IF EXISTS `banned_ips`;
CREATE TABLE IF NOT EXISTS `banned_ips` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_ips_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- FiveM IDs
DROP TABLE IF EXISTS `banned_fivems`;
CREATE TABLE IF NOT EXISTS `banned_fivems` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_fivems_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Xbox Live IDs
DROP TABLE IF EXISTS `banned_xbls`;
CREATE TABLE IF NOT EXISTS `banned_xbls` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_xbls_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Live IDs
DROP TABLE IF EXISTS `banned_lives`;
CREATE TABLE IF NOT EXISTS `banned_lives` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_lives_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tokens
DROP TABLE IF EXISTS `banned_tokens`;
CREATE TABLE IF NOT EXISTS `banned_tokens` (
    `ban_id` VARCHAR(60) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
    INDEX `idx_ban_id` (`ban_id`),
    CONSTRAINT `fk_banned_tokens_ban` FOREIGN KEY (`ban_id`) REFERENCES `nebula_bans`(`ban_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
