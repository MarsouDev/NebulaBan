# NebulaBan - Advanced FiveM Ban System

A comprehensive and professional ban management system for FiveM servers with multi-identifier tracking, localization support, and robust database architecture.

## 🌟 Features

- **Multi-Identifier Ban System**: Tracks Steam, License, Discord, IP, FiveM, Xbox Live, and player tokens
- **Secure Ban ID Generation**: Unique 16-character alphanumeric ban IDs with collision detection
- **Advanced Ban Checking**: Comprehensive player verification during connection
- **Localization Support**: English and French translations included (easily extensible)
- **Professional Logging**: Color-coded console output with different log levels
- **Database Integrity**: Foreign key constraints and proper indexing for performance
- **Admin Commands**: Full command suite for ban management (`/ban`, `/unban`, `/checkban`)
- **Async Operations**: Non-blocking database operations for optimal server performance

## 📋 Requirements

- **FiveM Server** (latest artifacts recommended)
- **MySQL Database** (5.7+ or MariaDB 10.2+)
- **oxmysql Resource** (for database operations)
- **Admin permissions** configured on your server

## 🚀 Installation

### 1. Database Setup
```sql
-- Import the provided SQL schema
SOURCE install.sql;
```

### 2. Resource Installation
1. Download or clone this repository
2. Place the `NebulaBan` folder in your server's `resources` directory
3. Add to your `server.cfg`:
```bash
ensure oxmysql
ensure NebulaBan
```

### 3. Configuration
Edit `shared/config.lua` to match your server setup:
```lua
nConfig = {
    BanIdLength = 16,
    Language = "en", -- or "fr"
    Commands = {
        Ban = "ban",
        Unban = "unban",
        CheckBan = "checkban"
    }
}
```

## 🎮 Usage

### Admin Commands

#### Ban Player
```
/ban <player_id> <duration_hours> <reason>
```
- `player_id`: Server ID of the player to ban
- `duration_hours`: Ban duration in hours (0 = permanent)
- `reason`: Reason for the ban

**Examples:**
```
/ban 1 24 Cheating
/ban 5 0 Permanent ban for hacking
```

#### Unban Player
```
/unban <ban_id>
```
- `ban_id`: The unique 16-character ban ID

**Example:**
```
/unban ABC123DEF456GHI7
```

#### Check Ban Status
```
/checkban <player_id>
```
- `player_id`: Server ID of the player to check

**Example:**
```
/checkban 1
```

### Permission System
Commands require admin permissions. Configure your server's permission system accordingly.

## 🗄️ Database Schema

The system uses a normalized database structure with the following tables:

- `nebula_bans`: Main ban records
- `banned_steams`: Steam ID bans
- `banned_licenses`: Rockstar License bans
- `banned_discords`: Discord ID bans
- `banned_ips`: IP address bans
- `banned_fivems`: FiveM ID bans
- `banned_xbls`: Xbox Live ID bans
- `banned_lives`: Live ID bans
- `banned_tokens`: Player token bans

## 🌍 Localization

The system supports multiple languages. Currently included:

- **English** (`locales/en.lua`)
- **French** (`locales/fr.lua`)

### Adding New Languages

1. Create a new locale file: `locales/[language_code].lua`
2. Copy the structure from `locales/en.lua`
3. Translate all strings
4. Update `config.lua` to use your new language

## 🔧 API Reference

### Ban Functions

#### Ban.banPlayer(banData, duration, reason, admin, callback)
Bans a player with comprehensive identifier tracking.

**Parameters:**
- `banData`: Player identifiers object or player server ID
- `duration`: Ban duration in hours (0 for permanent)
- `reason`: String reason for the ban
- `admin`: String name of the admin issuing the ban
- `callback`: Function to handle the result

#### Ban.unbanPlayer(banId, callback)
Removes a ban by Ban ID.

**Parameters:**
- `banId`: String ban ID to remove
- `callback`: Function to handle the result

#### Ban.isPlayerBanned(identifiers, callback)
Checks if a player is currently banned.

**Parameters:**
- `identifiers`: Player identifiers object
- `callback`: Function to handle the result

### Utility Functions

#### Ban.getPlayerIdentifiers(source)
Retrieves all identifiers for a player.

#### Ban.generateBanId(length)
Generates a secure, unique ban ID.

## 🔒 Security Features

- **SQL Injection Protection**: All queries use prepared statements
- **Unique Ban ID Generation**: Collision detection with recursive generation
- **Foreign Key Constraints**: Ensures database integrity
- **Async Operations**: Prevents server blocking during database operations
- **Input Validation**: All user inputs are validated before processing

## 🐛 Troubleshooting

### Common Issues

**Ban commands not working:**
- Verify admin permissions are configured
- Check server console for error messages
- Ensure oxmysql is running and connected

**Database connection errors:**
- Verify MySQL credentials in oxmysql configuration
- Ensure database exists and tables are created
- Check MySQL server status

**Players not getting banned:**
- Check console for ban system messages
- Verify database tables exist with correct schema
- Ensure player identifiers are being retrieved correctly

### Debug Mode
Enable debug logging by checking console output for detailed information about ban operations.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📞 Support

If you encounter any issues or need assistance:

1. Check the troubleshooting section above
2. Review the console output for error messages
3. Open an issue on the project repository with detailed information

## 🔄 Changelog

### Version 1.0.0
- Initial release
- Multi-identifier ban system
- Localization support (EN/FR)
- Complete admin command suite
- Professional database architecture
- Comprehensive documentation

---

**NebulaBan** - Professional ban management for professional servers.