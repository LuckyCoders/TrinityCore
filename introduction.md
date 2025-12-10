# TrinityCore Project Introduction

## What is TrinityCore?

TrinityCore is an open-source game server that lets you run your own World of Warcraft server. It is written mostly in C++ programming language. You can use it to create and manage your own private game world where you and your friends can play.

The project is completely free and open source. Anyone can use it, modify it, and help improve it. It started from MaNGOS (another open-source project) but has been improved a lot over the years.

## Project History

The development of this project dates back to **2004**, when it started as the WoW Daemon Team project. Over the years, it has evolved through several stages:

- **2004**: WoW Daemon Team - The very first attempt to create a World of Warcraft server
- **2005-2008**: MaNGOS project (located at mangosproject.org) - First successful open-source server project
- **2008-2011**: MaNGOS project (located at getmangos.com) - Continued development and improvements
- **2008-present**: TrinityCore (located at trinitycore.org) - Fork of MaNGOS with major improvements

The TrinityCore project officially started in **October 2008** and continues to be actively developed today.

## Key Milestones and Versions

### Early Years (2008-2012)

- **October 2008**: TrinityCore project started as a fork of MaNGOS
- **2009**: First stable releases supporting World of Warcraft 3.3.5 (Wrath of the Lich King)
- **2010-2012**: Major code improvements, better stability, and community growth

### Version 3.3.5 Support (2010-present)

- **2010**: Full support for World of Warcraft 3.3.5a (Wrath of the Lich King expansion)
- **2011-2015**: Continuous improvements to game mechanics, quests, and dungeons
- **2015-present**: 3.3.5 branch remains one of the most popular and stable versions
- **Current**: Still actively maintained with regular TDB (Trinity Database) updates

### Modern Versions (2014-present)

- **2014**: Support for newer game versions (4.x, 5.x, 6.x)
- **2016**: Introduction of master branch for latest game version support
- **2018**: Major code refactoring and performance improvements
- **2020**: Support for Cataclysm Classic (cata_classic branch)
- **2021-2023**: Support for Shadowlands and later expansions
- **2024**: Support for The War Within expansion (version 11.0.0)
- **2025**: Active development continues with regular updates

### Current Development (2024-2025)

**What we're working on now:**

- **Active Maintenance**: All three main branches (master, 3.3.5, cata_classic) receive regular updates
  - Master branch: Supports latest World of Warcraft versions (up to 11.0.0 - The War Within)
  - 3.3.5 branch: Most popular version, still actively maintained with TDB updates
  - cata_classic branch: Supports Cataclysm Classic expansion
  
- **Database Updates**: TDB (Trinity Database) is updated regularly with new game content
  - Latest TDB versions: TDB335.25101 (for 3.3.5), TDB442.25051 (for 4.4.2), TDB1125.25101 (for 11.0.0)
  - Updates include: quests, NPCs, items, spells, and game mechanics fixes
  
- **Bug Fixes**: Continuous fixes for quests, NPCs, spells, and game mechanics
  - Regular commits fixing gameplay issues
  - Improvements to movement, combat, and AI systems
  
- **Performance**: Ongoing optimization for better server performance
  - Code improvements for faster processing
  - Better memory usage
  - Optimized database queries

- **Docker Support**: Improved Docker setup for easier deployment (new in 2024-2025)
  - Docker Compose files for easy setup
  - One-command installation scripts
  - Pre-built Docker images on Docker Hub

- **Documentation**: Better guides and documentation for beginners
  - Improved README with troubleshooting
  - Quick start guides
  - Better error messages

- **Code Quality**: Code improvements and modernization
  - Better code structure
  - Improved build system
  - Enhanced testing

**Recent Improvements (2024-2025):**

- ✅ Added Docker Compose support for easier setup
- ✅ Created one-command installation scripts (`quick-start-335.sh`)
- ✅ Improved error messages and troubleshooting guides
- ✅ Better documentation for new users
- ✅ Enhanced build system and CI/CD pipelines
- ✅ Regular TDB updates for all supported branches
- ✅ Performance improvements and bug fixes

**Current Status:**

- **Active Development**: Yes, project is actively maintained
- **Last Update**: December 2025 (regular commits)
- **Community**: Active community on Discord, forums, and GitHub
- **Stability**: All branches are stable and production-ready
- **Support**: Community support available through forums and Discord

## Supported Versions

TrinityCore maintains several active branches for different game versions:

1. **master** - The main development branch for the latest supported game version
2. **3.3.5** - Support for World of Warcraft version 3.3.5 (Wrath of the Lich King)
3. **cata_classic** - Support for Cataclysm Classic version

Each branch is actively maintained and receives regular updates, bug fixes, and improvements from the community.

## Project Structure

The project consists of:

- **C++ Source Code** (`src/`) - The main server code that makes everything work
- **SQL Scripts** (`sql/`) - Database files with game data (over 19,000 files)
- **Dependencies** (`dep/`) - Other code libraries needed to build the server
- **Build System** - Tools that help compile the code
- **Tools** - Helper programs like map extractors and data generators
- **Docker Support** - Easy way to run the server using containers

## How to Run TrinityCore with Docker

TrinityCore works with Docker, which makes it easier to set up and run. Here's how to get started:

### Prerequisites

- Docker installed on your computer
- MySQL/MariaDB database (can run on your computer or in Docker)
- World of Warcraft game files (to extract maps and other data)

### Step 1: Pull the Docker Image

For the latest **3.3.5** version:
```bash
docker pull trinitycore/trinitycore:3.3.5
```

For the latest **master** branch:
```bash
docker pull trinitycore/trinitycore:master
```

For a specific commit, use:
```bash
docker pull trinitycore/trinitycore:commit_hash
```

### Step 2: Prepare Configuration Files

1. Copy the `.conf` files from the TrinityCore GitHub repository to a local folder
2. Edit the configuration files:
   - Set MySQL host to use UNIX socket: `".;/var/run/mysqld/mysqld.sock;username;password;database"`
   - Set `DataDir` in `worldserver.conf` to `"/trinity/data"`

### Step 3: Start the Servers

**Start bnetserver** (authentication server):
```bash
docker run --entrypoint=bnetserver -it \
  --volume=/host/path/to/configs:/home/circleci/project/bin/check_install/etc \
  --volume=/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock \
  -p=1119:1119 -p 8081:8081 \
  trinitycore/trinitycore:3.3.5
```

**Start worldserver** (game world server):
```bash
docker run --entrypoint=worldserver -it \
  --volume=/host/path/to/configs:/home/circleci/project/bin/check_install/etc \
  --volume=/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock \
  --volume=/path/to/data/directory:/trinity/data \
  -p=8085:8085 -p 8086:8086 \
  trinitycore/trinitycore:3.3.5
```

### Step 4: Import Database

Before starting the servers, you need to:
1. Create MySQL databases (auth, characters, world)
2. Import the base SQL files from the `sql/` directory
3. Import TDB (Trinity Database) files for game content

To import TDB using the autoupdater:
1. Download the TDB SQL file from GitHub
2. Add volume mapping: `--volume=/path/to/TDB_full_name.sql:/home/circleci/TDB_full_name.sql`
3. Run the container

### Docker Image Contents

The Docker image includes:
- `bnetserver` - Handles player login and authentication
- `worldserver` - Runs the game world where players play
- `mapextractor` - Tool to get map data from game files
- `mmaps_generator` - Tool to create pathfinding data (helps NPCs move)
- `vmap4extractor` - Tool to extract visibility data from game files
- `vmap4assembler` - Tool to put visibility data together

## Common Issues and Troubleshooting

### Most Problematic Areas for Beginners

#### 1. Database Setup and Configuration

**Problem**: Database connection issues are the most common problem for new users.

**Why it's hard**: 
- You need to create three separate databases (auth, characters, world)
- The database connection settings in config files can be confusing
- You must import SQL files in the right order
- TDB (game content database) must be downloaded and imported separately

**Common mistakes**:
- Wrong MySQL connection string format
- Forgetting to import base SQL files before TDB
- Database user permissions issues
- Using wrong database names

**Solution**: 
- Follow the installation guide step-by-step
- Double-check your MySQL connection strings
- Ensure MySQL user has proper permissions
- Import SQL files in the correct order: base files first, then updates

#### 2. Configuration Files

**Problem**: Configuring `.conf` files correctly is essential but can be overwhelming.

**Why it's hard**:
- There are many settings to configure
- Some settings depend on your computer setup (file paths, network ports, etc.)
- Wrong file paths will make the server crash
- Port numbers might already be used by other programs

**Common mistakes**:
- Incorrect file paths (especially on Windows vs Linux)
- Wrong port numbers
- Missing or incorrect DataDir path
- Not setting up proper logging

**Solution**:
- Start with default config files and modify only what's necessary
- Use absolute paths instead of relative paths
- Check that ports are not already in use
- Enable debug logging initially to see what's wrong

#### 3. Map and Data Extraction

**Problem**: Extracting game client data files is required but not straightforward.

**Why it's hard**:
- You need the original World of Warcraft game files
- You must run several tools in the correct order
- The files are very large and take time to process
- File paths must be set up correctly

**Common mistakes**:
- Not extracting all required data types (maps, vmaps, mmaps)
- Wrong extraction paths
- Missing game client files
- Running tools in wrong order

**Solution**:
- Follow the extraction guide carefully
- Ensure you have enough disk space (several GB)
- Extract maps first, then vmaps, then mmaps
- Verify extracted files are in correct locations

#### 4. Docker Volume Mounting

**Problem**: Docker volume paths can be confusing, especially for beginners.

**Why it's hard**:
- File paths work differently on Windows, Linux, and macOS
- It's hard to know which folders need to be connected
- Sometimes you get permission errors
- Setting up the database connection can be tricky

**Common mistakes**:
- Wrong volume mount paths
- Permission denied errors
- MySQL socket not accessible from container
- Config files not found in container

**Solution**:
- Use absolute paths for volumes
- Check file permissions on mounted directories
- Ensure MySQL socket is accessible (or use TCP connection)
- Verify config files are in the mounted directory

#### 5. Build and Compilation (if building from source)

**Problem**: Compiling from source requires many dependencies and can fail easily.

**Why it's hard**:
- You need special programming tools (C++ compiler)
- You need many other programs installed first (OpenSSL, MySQL, Boost, etc.)
- The build system (CMake) can be complicated
- Different problems on Windows, Linux, and macOS

**Common mistakes**:
- Missing dependencies
- Wrong CMake configuration
- Compiler version too old
- Build errors that are hard to understand

**Solution**:
- Use Docker images if possible (pre-built)
- If building from source, follow platform-specific guides
- Install all dependencies first
- Use the recommended compiler versions

#### 6. Network and Firewall Configuration

**Problem**: Server might not be accessible due to network/firewall issues.

**Why it's hard**:
- You need to open several network ports
- Firewall settings are different on each operating system
- It's hard to know which ports do what
- Router settings are needed if others want to connect from outside

**Common mistakes**:
- Forgetting to open ports in firewall
- Wrong port forwarding
- Binding to wrong network interface
- Security groups (if using cloud services)

**Solution**:
- Open required ports: 1119 (bnetserver), 8085-8086 (worldserver)
- Check firewall rules
- Test locally first before exposing externally
- Review security considerations

### Getting Help

If you encounter problems:

1. **Check the official wiki**: https://www.trinitycore.info
2. **Visit the forums**: https://talk.trinitycore.org/
3. **Join Discord**: https://discord.trinitycore.org/
4. **Read installation guides**: Make sure you followed all steps
5. **Check logs**: Server logs usually contain helpful error messages
6. **Search existing issues**: Someone might have had the same problem

### Important Notes

- TrinityCore requires an SSE2-capable processor
- C++11 compiler is required
- The project is licensed under GPL 2.0
- Always use the latest core and database revisions when reporting issues
- For production use, consider security implications of running a game server

## Resources

- **Website**: https://www.trinitycore.org
- **Wiki**: https://www.trinitycore.info
- **Forums**: https://talk.trinitycore.org/
- **Discord**: https://discord.trinitycore.org/
- **GitHub**: https://github.com/TrinityCore/TrinityCore

---

*This document provides a beginner-friendly overview. For detailed installation and configuration instructions, please refer to the official TrinityCore wiki and documentation.*
