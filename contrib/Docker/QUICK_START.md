# TrinityCore 3.3.5 - One Command Quick Start

This guide will help you get TrinityCore 3.3.5 running with Docker in just a few minutes using one simple command.

## Prerequisites

- **Docker** installed ([Install Docker](https://docs.docker.com/get-docker/))
- **Docker Compose** installed (usually included with Docker Desktop)
- **4GB+ RAM** available
- **10GB+ free disk space**

## Quick Start (One Command)

```bash
# Clone the repository
git clone https://github.com/TrinityCore/TrinityCore.git
cd TrinityCore

# Run the quick start script
./contrib/Docker/quick-start-335.sh
```

That's it! The script will:
- ✅ Pull the TrinityCore 3.3.5 Docker image
- ✅ Create and configure MySQL database
- ✅ Generate configuration files
- ✅ Start bnetserver (authentication server)
- ✅ Start worldserver (game world server)

## What Gets Created

The script creates the following structure:

```
contrib/Docker/
├── configs/          # Configuration files (auto-generated)
│   ├── bnetserver.conf
│   └── worldserver.conf
├── data/            # Game data directory (maps, vmaps, etc.)
├── logs/            # Server logs
├── init-db/         # Database initialization scripts
└── docker-compose.yml
```

## After Running the Script

### 1. Check Server Status

```bash
cd contrib/Docker
docker-compose ps
```

You should see three services running:
- `trinitycore-mysql` (database)
- `trinitycore-bnetserver` (authentication)
- `trinitycore-worldserver` (game world)

### 2. View Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f worldserver
docker-compose logs -f bnetserver
```

### 3. Import TDB (Trinity Database)

**Important**: Without TDB, your game world will be empty. You need to import the game content database.

**Step 1: Import base world database structure** (if not already done):
```bash
cd contrib/Docker
docker exec -i trinitycore-mysql mysql -uroot -proot world < ../../sql/base/dev/world_database.sql
```

**Step 2: Download TDB** from [TrinityCore Releases](https://github.com/TrinityCore/TrinityCore/releases)
   - For 3.3.5 branch: Look for files like `TDB_full_world_335.63_*.sql`
   - For master branch: Look for `TDB_full_world_*.sql` matching latest version
   - **Note**: TDB is separate from core repository and must be downloaded manually

**Step 3: Import TDB**:
   ```bash
   cd contrib/Docker
   docker exec -i trinitycore-mysql mysql -uroot -proot world < /path/to/TDB_full_world_335.63_*.sql
   ```

   Or if you downloaded it to the Docker directory:
   ```bash
   docker exec -i trinitycore-mysql mysql -uroot -proot world < TDB_full_world_335.63_*.sql
   ```

**Step 4: Apply database updates** (if any):
   ```bash
   # Check for updates in sql/updates/world/3.3.5/ directory
   # Apply them in order if they exist
   ```

### 4. Extract Game Client Data

The server needs maps, vmaps, and DBC files from the game client.

1. **Extract maps** using `mapextractor`:
   ```bash
   docker run --rm -v /path/to/wow/client:/client -v $(pwd)/data:/output \
     trinitycore/trinitycore:3.3.5 mapextractor /client /output
   ```

2. **Extract vmaps**:
   ```bash
   docker run --rm -v $(pwd)/data:/data trinitycore/trinitycore:3.3.5 \
     vmap4extractor /data
   docker run --rm -v $(pwd)/data:/data trinitycore/trinitycore:3.3.5 \
     vmap4assembler Buildings vmaps
   ```

3. **Extract DBC files** (copy from game client):
   ```bash
   cp /path/to/wow/client/dbc/* contrib/Docker/data/dbc/
   ```

## Common Commands

### Start Services
```bash
cd contrib/Docker
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### Restart Services
```bash
docker-compose restart
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f worldserver
```

### Access MySQL
```bash
docker exec -it trinitycore-mysql mysql -uroot -proot
```

### Check Service Status
```bash
docker-compose ps
```

## Troubleshooting

### Services Won't Start

1. **Check Docker is running**:
   ```bash
   docker ps
   ```

2. **Check logs for errors**:
   ```bash
   docker-compose logs
   ```

3. **Verify ports are not in use**:
   ```bash
   # Check ports 3306, 1119, 8081, 8085, 8086
   netstat -tulpn | grep -E ':(3306|1119|8081|8085|8086)'
   ```

### Database Connection Errors

If you see database connection errors:

1. **Wait for MySQL to be ready** (it takes ~30 seconds):
   ```bash
   docker-compose logs mysql
   ```

2. **Check MySQL is running**:
   ```bash
   docker exec trinitycore-mysql mysqladmin ping -h localhost -u root -proot
   ```

3. **Verify database exists**:
   ```bash
   docker exec -it trinitycore-mysql mysql -uroot -proot -e "SHOW DATABASES;"
   ```

### Empty World (No NPCs/Quests)

This is normal! You need to import TDB. See step 3 above.

### Missing Maps/Vmaps Errors

You need to extract game client data. See step 4 above.

### Permission Errors

On Linux, you might need to adjust permissions:

```bash
sudo chown -R $USER:$USER contrib/Docker/
chmod -R 755 contrib/Docker/
```

## Configuration

Configuration files are in `contrib/Docker/configs/`:

- **bnetserver.conf** - Authentication server settings
- **worldserver.conf** - Game world server settings

Edit these files and restart services:

```bash
docker-compose restart
```

## Default Credentials

- **MySQL Root**: `root` / `root`
- **MySQL User**: `trinity` / `trinity`
- **Databases**: `auth`, `characters`, `world`, `hotfixes`

**Important**: Change these in production!

## Next Steps

1. ✅ Import TDB (see step 3 above)
2. ✅ Extract game client data (see step 4 above)
3. ✅ Create game account (see [Wiki](https://trinitycore.info))
4. ✅ Configure realmlist (see [Wiki](https://trinitycore.info))
5. ✅ Connect with game client

## Getting Help

- **Wiki**: [trinitycore.info](https://www.trinitycore.info)
- **Forums**: [talk.trinitycore.org](https://talk.trinitycore.org/)
- **Discord**: [discord.trinitycore.org](https://discord.trinitycore.org/)

## Manual Setup

If you prefer manual setup or the script doesn't work, see [README.md](README.md) for detailed Docker instructions.
