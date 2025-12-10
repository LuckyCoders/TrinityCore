# ![logo](https://community.trinitycore.org/public/style_images/1_trinitycore.png) TrinityCore

[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/TrinityCore/TrinityCore.svg)](https://isitmaintained.com/project/TrinityCore/TrinityCore "Average time to resolve an issue") [![Percentage of issues still open](https://isitmaintained.com/badge/open/TrinityCore/TrinityCore.svg)](https://isitmaintained.com/project/TrinityCore/TrinityCore "Percentage of issues still open")

## Quick Start

**New to TrinityCore?** Start here:

- 🐳 **[Docker Quick Start Guide](#docker-quick-start)** - Get running in minutes with Docker
- 📖 **[Full Installation Guide](https://trinitycore.info/en/home)** - Complete setup instructions
- ❓ **[Common Problems & Solutions](#common-problems-and-solutions)** - Troubleshooting guide

## Build Status

| master | 3.3.5 | cata_classic |
|:------------:|:------------:|:------------:|
|[![master Build Status](https://circleci.com/gh/TrinityCore/TrinityCore/tree/master.svg?style=shield)](https://circleci.com/gh/TrinityCore/TrinityCore/tree/master) | [![3.3.5 Build Status](https://circleci.com/gh/TrinityCore/TrinityCore/tree/3.3.5.svg?style=shield)](https://circleci.com/gh/TrinityCore/TrinityCore/tree/3.3.5) | [![cata_classic Build Status](https://circleci.com/gh/TrinityCore/TrinityCore/tree/cata_classic.svg?style=shield)](https://circleci.com/gh/TrinityCore/TrinityCore/tree/cata_classic) |

## Introduction

TrinityCore is an open-source **MMORPG Framework** written primarily in C++. It is derived from [MaNGOS](http://getmangos.com), the *Massive Network Game Object Server*, and has been extensively improved and optimized over time.

### What TrinityCore Does

- Runs World of Warcraft private servers
- Provides complete game server functionality (authentication, world simulation, database management)
- Supports multiple game versions (3.3.5, Cataclysm Classic, and more)
- Completely open source with active community development

### Project History

- **2004**: Started as WoW Daemon Team
- **2005-2008**: MaNGOS project
- **2008-present**: TrinityCore (actively maintained)

## Supported Versions

TrinityCore maintains active branches for different game versions:

- **master** - Latest development branch
- **3.3.5** - World of Warcraft: Wrath of the Lich King (3.3.5)
- **cata_classic** - Cataclysm Classic

## Docker Quick Start

The easiest way to get started with TrinityCore is using Docker. We provide pre-built images for quick deployment.

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM available
- 10GB+ free disk space

### One-Command Setup (3.3.5)

For the simplest setup, use our automated script:

```bash
# Clone the repository
git clone https://github.com/TrinityCore/TrinityCore.git
cd TrinityCore

# Run the quick start script (creates databases, configs, and starts servers)
./contrib/Docker/quick-start-335.sh
```

This script will:
1. Pull the Docker image
2. Create MySQL container with required databases
3. Generate configuration files
4. Start both bnetserver and worldserver

**Note**: You still need to import the TDB (Trinity Database) files for game content. See [Docker Setup Guide](contrib/Docker/README.md) for details.

### Manual Docker Setup

See [contrib/Docker/README.md](contrib/Docker/README.md) for detailed Docker instructions.

## Requirements

### Software Requirements

- **C++ Compiler**: GCC 7+ or Clang 5+ with C++11 support
- **CMake**: 3.24 or higher
- **MySQL/MariaDB**: 5.7+ or 8.0+
- **OpenSSL**: 1.0.x or 1.1.x
- **Boost**: 1.70+ (headers only)
- **Processor**: SSE2 capable

### Platform-Specific Guides

Detailed requirements and installation instructions:

- [Windows Installation](https://trinitycore.info/en/install/requirements/windows)
- [Linux Installation](https://trinitycore.info/en/install/requirements/linux)
- [macOS Installation](https://trinitycore.info/en/install/requirements/macos)

**Recommended**: Debian-based Linux distributions (Debian 8+, Ubuntu 18.04+) for easiest setup.

## Installation

### From Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/TrinityCore/TrinityCore.git
   cd TrinityCore
   ```

2. **Checkout desired branch**:
   ```bash
   git checkout 3.3.5  # or master, cata_classic
   ```

3. **Follow platform-specific guide**:
   - [Windows](https://trinitycore.info/en/install/core/windows)
   - [Linux](https://trinitycore.info/en/install/core/linux)
   - [macOS](https://trinitycore.info/en/install/core/macos)

### Database Setup

TrinityCore requires **4 databases**:

1. **auth** - Authentication and realm information
2. **characters** - Character data
3. **world** - Game content (requires TDB import)
4. **hotfixes** - Hotfix data (optional for some versions)

**Important**: Import base SQL files from `sql/base/` before importing TDB updates.

## Common Problems and Solutions

### 🔴 Problem 1: Database Connection Errors

**Symptoms**: 
- `Could not connect to MySQL database`
- `Access denied for user`
- Server crashes on startup

**Solutions**:
1. **Check MySQL is running**: `systemctl status mysql` or `service mysql status`
2. **Verify credentials** in config files match your MySQL setup
3. **Check database exists**: `mysql -u root -p -e "SHOW DATABASES;"`
4. **Verify user permissions**: User must have CREATE/ALTER/RENAME table permissions
5. **Connection string format**: `"hostname;port;username;password;database"`
   - Example: `"127.0.0.1;3306;trinity;trinity;auth"`

**Common Mistakes**:
- Wrong password in config files
- Database not created
- MySQL user lacks permissions
- Firewall blocking MySQL port (3306)

### 🔴 Problem 2: Configuration File Issues

**Symptoms**:
- `Could not find configuration file`
- Server starts but can't find data files
- Wrong paths in logs

**Solutions**:
1. **Use absolute paths** instead of relative paths
2. **Check DataDir** in `worldserver.conf` points to correct location
3. **Verify file permissions** - server needs read access
4. **Copy `.dist` files** to create actual configs:
   ```bash
   cp worldserver.conf.dist worldserver.conf
   cp bnetserver.conf.dist bnetserver.conf
   ```

**Important Settings**:
- `DataDir` - Must point to directory with maps, vmaps, dbc files
- `LoginDatabaseInfo` - Database connection for auth
- `WorldDatabaseInfo` - Database connection for world content
- `CharacterDatabaseInfo` - Database connection for characters

### 🔴 Problem 3: Missing Game Data Files

**Symptoms**:
- `MAP FILE 'maps/0004331.map' does not exist!`
- `VMap file 'vmaps/000.vmtree' is missing or points to wrong vmap directory!`
- Server crashes when loading maps

**Solutions**:
1. **Extract maps** from game client using `mapextractor`
2. **Extract vmaps** using `vmap4extractor` and `vmap4assembler`
3. **Extract mmaps** using `mmaps_generator` (optional but recommended)
4. **Place files** in directory specified by `DataDir` in config

**Extraction Order**:
1. Maps (required)
2. Vmaps (required)
3. Mmaps (optional, improves pathfinding)

### 🔴 Problem 4: TDB (Trinity Database) Not Imported

**Symptoms**:
- Empty world (no NPCs, quests, items)
- `Table 'world.creature_template' doesn't exist`
- Server runs but world is empty

**Solutions**:
1. **Download TDB** from [TrinityCore TDB releases](https://github.com/TrinityCore/TrinityCore/releases)
2. **Import base world database** first: `sql/base/dev/world_database.sql`
3. **Import TDB file** matching your core version
4. **Apply updates** from `sql/updates/world/` directory

**Important**: TDB is separate from core repository. You must download and import it manually.

### 🔴 Problem 5: Port Already in Use

**Symptoms**:
- `bind: address already in use`
- Server fails to start
- Connection refused errors

**Solutions**:
1. **Check what's using the port**:
   ```bash
   # Linux
   sudo netstat -tulpn | grep :1119
   # or
   sudo lsof -i :1119
   ```
2. **Change port** in config file if needed
3. **Stop conflicting service** if it's another TrinityCore instance

**Default Ports**:
- **1119** - bnetserver (authentication)
- **8081** - bnetserver REST API
- **8085-8086** - worldserver

### 🔴 Problem 6: Git Revision Shows "unknown" or "1970-01-01"

**Symptoms**:
- `TrinityCore rev. unknown 1970-01-01 00:00:00 +0000`
- Version information incorrect

**Solutions**:
1. **Clone repository** instead of downloading ZIP
2. **Install Git properly** on Windows: [Git Installation Guide](https://community.trinitycore.org/topic/345-howto-properly-install-git-on-windows-fix-trinitycore-rev-1970-01-01-000000-0000/)
3. **Ensure Git is in PATH** environment variable

### 🔴 Problem 7: Compilation Errors

**Symptoms**:
- CMake configuration fails
- Build errors about missing dependencies
- Linker errors

**Solutions**:
1. **Install all dependencies** first (see Requirements section)
2. **Use recommended compiler versions** (GCC 7+ or Clang 5+)
3. **Check CMake version** (3.24+ required)
4. **Read error messages carefully** - they usually indicate missing packages
5. **Use Docker** if compilation is too difficult (pre-built images available)

**Common Missing Dependencies**:
- `libmysqlclient-dev` (MySQL client libraries)
- `libssl-dev` (OpenSSL)
- `libboost-all-dev` (Boost libraries)
- `cmake` (Build system)

### 🔴 Problem 8: Docker Volume Permission Issues

**Symptoms**:
- `Permission denied` when accessing mounted volumes
- Config files not found in container
- Logs can't be written

**Solutions**:
1. **Use absolute paths** for volume mounts
2. **Check file permissions** on host:
   ```bash
   chmod -R 755 /path/to/configs
   ```
3. **Run with correct user** or adjust permissions
4. **Use Docker volumes** instead of bind mounts for data persistence

## Getting Help

### Before Asking for Help

1. ✅ Read this README completely
2. ✅ Check [Common Problems](#common-problems-and-solutions) above
3. ✅ Search [existing issues](https://github.com/TrinityCore/TrinityCore/issues)
4. ✅ Review [installation guides](https://trinitycore.info/en/home)
5. ✅ Check server logs for error messages

### Where to Get Help

- **📚 Wiki**: [trinitycore.info](https://www.trinitycore.info) - Comprehensive documentation
- **💬 Forums**: [talk.trinitycore.org](https://talk.trinitycore.org/) - Community discussions
- **💬 Discord**: [discord.trinitycore.org](https://discord.trinitycore.org/) - Real-time chat
- **🐛 Issues**: [GitHub Issues](https://github.com/TrinityCore/TrinityCore/issues) - Bug reports

### Reporting Issues

**Please include**:
- Branch name (master, 3.3.5, etc.)
- Commit hash (not "unknown")
- Clear description of the problem
- Steps to reproduce
- Relevant log excerpts
- Your system information (OS, MySQL version, etc.)

Read the [Issue Tracker Guide](https://community.trinitycore.org/topic/37-the-trinitycore-issuetracker-and-you/) before creating tickets.

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Contribution Guide

1. **Fork** the repository
2. **Create a branch** for your fix
3. **Make changes** following [Development Standards](https://trinitycore.atlassian.net/wiki/spaces/tc/pages/2130103/C+Development+Standards)
4. **Test** your changes
5. **Submit a Pull Request**

For SQL-only fixes, please [create a ticket](https://github.com/TrinityCore/TrinityCore/issues/new/choose) instead.

## Project Structure

```
TrinityCore/
├── src/              # C++ source code
│   ├── server/       # Server components (worldserver, bnetserver)
│   └── tools/        # Utility tools (extractors, generators)
├── sql/              # Database files
│   ├── base/         # Base database structure
│   └── updates/      # Database update files
├── dep/              # Third-party dependencies
├── cmake/            # CMake build configuration
└── contrib/          # Contrib scripts and Docker files
```

## Links

- **🌐 Website**: [trinitycore.org](https://www.trinitycore.org)
- **📖 Wiki**: [trinitycore.info](https://www.trinitycore.info)
- **💬 Forums**: [talk.trinitycore.org](https://talk.trinitycore.org/)
- **💬 Discord**: [discord.trinitycore.org](https://discord.trinitycore.org/)
- **📦 Releases**: [GitHub Releases](https://github.com/TrinityCore/TrinityCore/releases)

## Copyright

License: **GPL 2.0**

See [COPYING](COPYING) file for details.

## Authors & Contributors

See [AUTHORS](AUTHORS) file for the complete list of contributors.

---

**Need help getting started?** Check out our [Docker Quick Start](#docker-quick-start) or visit the [Wiki](https://trinitycore.info) for detailed guides.
