#!/bin/bash

###############################################################################
# TrinityCore 3.3.5 Quick Start Script
# This script sets up and starts TrinityCore 3.3.5 using Docker
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DOCKER_DIR="$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}TrinityCore 3.3.5 Quick Start${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create necessary directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$DOCKER_DIR/configs"
mkdir -p "$DOCKER_DIR/data"
mkdir -p "$DOCKER_DIR/logs"
mkdir -p "$DOCKER_DIR/init-db"

# Check if config files exist, if not create them
if [ ! -f "$DOCKER_DIR/configs/bnetserver.conf" ] || [ ! -f "$DOCKER_DIR/configs/worldserver.conf" ]; then
    echo -e "${YELLOW}Creating configuration files...${NC}"
    
    # Copy config files from source if they exist
    if [ -f "$PROJECT_ROOT/src/server/bnetserver/bnetserver.conf.dist" ]; then
        cp "$PROJECT_ROOT/src/server/bnetserver/bnetserver.conf.dist" "$DOCKER_DIR/configs/bnetserver.conf"
    fi
    
    if [ -f "$PROJECT_ROOT/src/server/worldserver/worldserver.conf.dist" ]; then
        cp "$PROJECT_ROOT/src/server/worldserver/worldserver.conf.dist" "$DOCKER_DIR/configs/worldserver.conf"
    fi
    
    # Update database connection strings for Docker
    if [ -f "$DOCKER_DIR/configs/bnetserver.conf" ]; then
        echo -e "${YELLOW}Configuring bnetserver.conf...${NC}"
        sed -i.bak 's|LoginDatabaseInfo = "127.0.0.1;3306;trinity;trinity;auth"|LoginDatabaseInfo = "mysql;3306;trinity;trinity;auth"|g' "$DOCKER_DIR/configs/bnetserver.conf" 2>/dev/null || \
        sed -i '' 's|LoginDatabaseInfo = "127.0.0.1;3306;trinity;trinity;auth"|LoginDatabaseInfo = "mysql;3306;trinity;trinity;auth"|g' "$DOCKER_DIR/configs/bnetserver.conf"
        rm -f "$DOCKER_DIR/configs/bnetserver.conf.bak" 2>/dev/null || true
    fi
    
    if [ -f "$DOCKER_DIR/configs/worldserver.conf" ]; then
        echo -e "${YELLOW}Configuring worldserver.conf...${NC}"
        # Update database connections
        sed -i.bak 's|LoginDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;auth"|LoginDatabaseInfo     = "mysql;3306;trinity;trinity;auth"|g' "$DOCKER_DIR/configs/worldserver.conf" 2>/dev/null || \
        sed -i '' 's|LoginDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;auth"|LoginDatabaseInfo     = "mysql;3306;trinity;trinity;auth"|g' "$DOCKER_DIR/configs/worldserver.conf"
        
        sed -i.bak 's|WorldDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;world"|WorldDatabaseInfo     = "mysql;3306;trinity;trinity;world"|g' "$DOCKER_DIR/configs/worldserver.conf" 2>/dev/null || \
        sed -i '' 's|WorldDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;world"|WorldDatabaseInfo     = "mysql;3306;trinity;trinity;world"|g' "$DOCKER_DIR/configs/worldserver.conf"
        
        sed -i.bak 's|CharacterDatabaseInfo = "127.0.0.1;3306;trinity;trinity;characters"|CharacterDatabaseInfo = "mysql;3306;trinity;trinity;characters"|g' "$DOCKER_DIR/configs/worldserver.conf" 2>/dev/null || \
        sed -i '' 's|CharacterDatabaseInfo = "127.0.0.1;3306;trinity;trinity;characters"|CharacterDatabaseInfo = "mysql;3306;trinity;trinity;characters"|g' "$DOCKER_DIR/configs/worldserver.conf"
        
        sed -i.bak 's|HotfixDatabaseInfo    = "127.0.0.1;3306;trinity;trinity;hotfixes"|HotfixDatabaseInfo    = "mysql;3306;trinity;trinity;hotfixes"|g' "$DOCKER_DIR/configs/worldserver.conf" 2>/dev/null || \
        sed -i '' 's|HotfixDatabaseInfo    = "127.0.0.1;3306;trinity;trinity;hotfixes"|HotfixDatabaseInfo    = "mysql;3306;trinity;trinity;hotfixes"|g' "$DOCKER_DIR/configs/worldserver.conf"
        
        # Update DataDir
        sed -i.bak 's|DataDir = "."|DataDir = "/trinity/data"|g' "$DOCKER_DIR/configs/worldserver.conf" 2>/dev/null || \
        sed -i '' 's|DataDir = "."|DataDir = "/trinity/data"|g' "$DOCKER_DIR/configs/worldserver.conf"
        
        rm -f "$DOCKER_DIR/configs/worldserver.conf.bak" 2>/dev/null || true
    fi
else
    echo -e "${GREEN}Configuration files already exist${NC}"
fi

# Create database initialization script
if [ ! -f "$DOCKER_DIR/init-db/01-create-databases.sql" ]; then
    echo -e "${YELLOW}Creating database initialization script...${NC}"
    cat > "$DOCKER_DIR/init-db/01-create-databases.sql" << 'EOF'
-- Create databases
CREATE DATABASE IF NOT EXISTS `world` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `characters` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `auth` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `hotfixes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges
GRANT ALL PRIVILEGES ON `world`.* TO 'trinity'@'%';
GRANT ALL PRIVILEGES ON `characters`.* TO 'trinity'@'%';
GRANT ALL PRIVILEGES ON `auth`.* TO 'trinity'@'%';
GRANT ALL PRIVILEGES ON `hotfixes`.* TO 'trinity'@'%';
FLUSH PRIVILEGES;
EOF
    echo -e "${GREEN}Database initialization script created${NC}"
fi

# Pull Docker image
echo -e "${YELLOW}Pulling TrinityCore 3.3.5 Docker image...${NC}"
docker pull trinitycore/trinitycore:3.3.5 || {
    echo -e "${RED}Failed to pull Docker image${NC}"
    echo "Make sure you have internet connection and Docker Hub is accessible"
    exit 1
}

# Start services with docker-compose
echo -e "${YELLOW}Starting TrinityCore services...${NC}"
cd "$DOCKER_DIR"

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

$COMPOSE_CMD up -d mysql

# Wait for MySQL to be ready
echo -e "${YELLOW}Waiting for MySQL to be ready...${NC}"
timeout=60
counter=0
while ! docker exec trinitycore-mysql mysqladmin ping -h localhost -u root -proot --silent 2>/dev/null; do
    sleep 2
    counter=$((counter + 2))
    if [ $counter -ge $timeout ]; then
        echo -e "${RED}MySQL failed to start within $timeout seconds${NC}"
        exit 1
    fi
    echo -n "."
done
echo ""
echo -e "${GREEN}MySQL is ready!${NC}"

# Import base SQL files if they exist
if [ -f "$PROJECT_ROOT/sql/base/auth_database.sql" ]; then
    echo -e "${YELLOW}Importing auth database...${NC}"
    docker exec -i trinitycore-mysql mysql -uroot -proot auth < "$PROJECT_ROOT/sql/base/auth_database.sql" || echo -e "${YELLOW}Note: Auth database may already be imported${NC}"
fi

if [ -f "$PROJECT_ROOT/sql/base/characters_database.sql" ]; then
    echo -e "${YELLOW}Importing characters database...${NC}"
    docker exec -i trinitycore-mysql mysql -uroot -proot characters < "$PROJECT_ROOT/sql/base/characters_database.sql" || echo -e "${YELLOW}Note: Characters database may already be imported${NC}"
fi

# Note: world_database.sql in sql/base/dev/ is just structure, TDB needs to be imported separately
# We don't import it here as it requires TDB file which user must download separately
if [ -f "$PROJECT_ROOT/sql/base/dev/world_database.sql" ]; then
    echo -e "${YELLOW}Note: World database structure file found, but TDB import is required separately${NC}"
    echo -e "${YELLOW}      Import TDB after setup completes (see QUICK_START.md)${NC}"
fi

# Start bnetserver and worldserver
echo -e "${YELLOW}Starting bnetserver and worldserver...${NC}"
$COMPOSE_CMD up -d

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}TrinityCore 3.3.5 is starting!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Services:${NC}"
echo -e "  - MySQL:        ${GREEN}Running${NC} (port 3306)"
echo -e "  - bnetserver:   ${GREEN}Starting${NC} (ports 1119, 8081)"
echo -e "  - worldserver:  ${GREEN}Starting${NC} (ports 8085, 8086)"
echo ""
echo -e "${YELLOW}Important Notes:${NC}"
echo -e "  1. You need to import TDB (Trinity Database) files for game content"
echo -e "  2. You need to extract maps/vmaps from game client to ./data directory"
echo -e "  3. Check logs in: $DOCKER_DIR/logs"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo -e "  View logs:        ${GREEN}$COMPOSE_CMD logs -f${NC}"
echo -e "  Stop servers:     ${GREEN}$COMPOSE_CMD down${NC}"
echo -e "  Restart servers:  ${GREEN}$COMPOSE_CMD restart${NC}"
echo -e "  Check status:     ${GREEN}$COMPOSE_CMD ps${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Download TDB from: https://github.com/TrinityCore/TrinityCore/releases"
echo -e "  2. Import TDB: docker exec -i trinitycore-mysql mysql -uroot -proot world < TDB_full_world_335.63_*.sql"
echo -e "  3. Extract game client data to: $DOCKER_DIR/data"
echo ""
echo -e "${GREEN}Setup complete!${NC}"
