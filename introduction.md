# TrinityCore Project Introduction

## What is TrinityCore?

TrinityCore is an open-source MMORPG (Massively Multiplayer Online Role-Playing Game) server framework written mostly in C++. It is designed to run World of Warcraft game servers, allowing players to create and manage their own private game worlds.

The project is completely open source and encourages community involvement. It is derived from MaNGOS (Massive Network Game Object Server) and has been extensively improved and optimized over the years.

## Project History

The development of this project dates back to **2004**, when it started as the WoW Daemon Team project. Over the years, it has evolved through several stages:

- **2004**: WoW Daemon Team
- **2005-2008**: MaNGOS project (located at mangosproject.org)
- **2008-2011**: MaNGOS project (located at getmangos.com)
- **2008-2023+**: TrinityCore (located at trinitycore.org)

The TrinityCore project officially started in **October 2008** and continues to be actively developed today.

## Supported Versions

TrinityCore maintains several active branches for different game versions:

1. **master** - The main development branch for the latest supported game version
2. **3.3.5** - Support for World of Warcraft version 3.3.5 (Wrath of the Lich King)
3. **cata_classic** - Support for Cataclysm Classic version

Each branch is actively maintained and receives regular updates, bug fixes, and improvements from the community.

## Project Structure

The project consists of:

- **C++ Source Code** (`src/`) - Core server logic, game mechanics, and networking code
- **SQL Scripts** (`sql/`) - Database structure and data files (over 19,000 SQL files)
- **Dependencies** (`dep/`) - Third-party libraries required for compilation
- **Build System** - CMake-based build configuration
- **Tools** - Various utilities like map extractors, vmap generators, and more
- **Docker Support** - Containerized deployment options

## How to Run TrinityCore with Docker

TrinityCore provides Docker support for easier deployment. Here's how to get started:

### Prerequisites

- Docker installed on your system
- MySQL/MariaDB database server (can run on host or in a separate container)
- Game client data files (for map extraction)

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
- `bnetserver` - Authentication server
- `worldserver` - Game world server
- `mapextractor` - Tool to extract game maps
- `mmaps_generator` - Pathfinding data generator
- `vmap4extractor` - Visibility map extractor
- `vmap4assembler` - Visibility map assembler

## Common Issues and Troubleshooting

### Most Problematic Areas for Beginners

#### 1. Database Setup and Configuration

**Problem**: Database connection issues are the most common problem for new users.

**Why it's hard**: 
- You need to set up three separate databases (auth, characters, world)
- Database connection strings in config files can be confusing
- SQL import order matters
- TDB updates need to be applied correctly

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
- Many configuration options
- Some settings depend on your setup (paths, ports, etc.)
- Wrong paths cause server crashes
- Port conflicts with other applications

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
- Requires original game client files
- Multiple extraction tools need to be run in correct order
- Large files take time and disk space
- Paths must be configured correctly

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
- Different path formats on Windows, Linux, macOS
- Understanding which directories need to be mounted
- Permission issues with mounted volumes
- MySQL socket connection setup

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
- Requires C++ compiler (GCC/Clang) with C++11 support
- Many dependencies (OpenSSL, MySQL, Boost, etc.)
- CMake configuration can be complex
- Platform-specific issues (Windows, Linux, macOS)

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
- Multiple ports need to be opened
- Firewall rules vary by OS
- Understanding which ports are for what
- NAT/router configuration for external access

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
