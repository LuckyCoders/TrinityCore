# Docker

We use Docker to create ready-to-use server files. For the 3.3.5 and master branches, we also publish these files to https://hub.docker.com/r/trinitycore/trinitycore so you can download them easily.

The instructions below assume you know a little about TrinityCore configuration and Docker. If you're new, start with the Quick Start guide instead.

## Quick Start (Recommended)

For the easiest setup, use our **one-command quick start script**:

```bash
./contrib/Docker/quick-start-335.sh
```

Or use **Docker Compose**:

```bash
cd contrib/Docker
docker-compose up -d
```

See [QUICK_START.md](QUICK_START.md) for detailed instructions.

## Manual Setup

The following instructions are for manual Docker setup when MySQL runs on the host machine or you need custom configuration.

## Load the Docker image
For the 3.3.5 and master branches, it's possible to pull the images from DockerHub.
- For latest 3.3.5, use the following command:
  ```
  docker pull trinitycore/trinitycore:3.3.5
  ```
- For latest master, use the following command:
  ```
  docker pull trinitycore/trinitycore:master
  ```
- For a specific 3.3.5 or master commit, use the following command, replacing "commit_hash" with the hash of the commit:
  ```
  docker pull trinitycore/trinitycore:commit_hash
  ```

For Pull Requests or branches other than 3.3.5 or master, follow the steps below to load the image from Circle CI:
1. Click the green tick ✔ next to each commit.
1. Scroll to "ci/circleci: pch" and click "Details".
1. Log in to Circle CI if necessary. You may have to repeat the previous steps after logging in, to reach the correct page.
1. Click the "Artifacts" tab in the Circle CI website.
1. Download the docker.tar.gz archive containing the docker image.
1. Load the image into your Docker host, using the following command:
    ```
    docker load -i docker.tar.gz
    ```

## Start bnetserver/worldserver from Docker

### Option 1: Using Docker Compose (Recommended)

See [docker-compose.yml](docker-compose.yml) and [QUICK_START.md](QUICK_START.md) for Docker Compose setup.

### Option 2: Manual Docker Run (MySQL on Host)

1. Copy the .conf files from the TrinityCore GitHub repository to a local folder which will be passed on as a mapped volume to Docker.
1. Set the MySQL host in the .conf files:
   - **For MySQL on host**: Use UNIX socket: `".;/var/run/mysqld/mysqld.sock;username;password;database"`
   - **For MySQL in Docker network**: Use hostname: `"mysql;3306;username;password;database"`
1. Set the "DataDir" config in worldserver.conf to `"/trinity/data"`
1. Start bnetserver or worldserver as desired, mapping the required volumes:

- bnetserver
    ```
    docker run --entrypoint=bnetserver -it --volume=/host/path/to/configs:/home/circleci/project/bin/check_install/etc --volume=/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock -p=1119:1119 -p 8081:8081 "image name"
    ```

- worldserver
    ```
    docker run --entrypoint=worldserver -it --volume=/host/path/to/configs:/home/circleci/project/bin/check_install/etc --volume=/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock --volume=/path/to/data/directory:/trinity/data -p=8085:8085 -p 8086:8086 "image name"
    ```

Change the ports and other parameters as needed. Consult Docker documentation for additional details about possible configuration settings.

## Content

The image contains:
- bnetserver
- mapextractor
- mmaps_generator
- vmap4asembler
- vmap4extractor
- worldserver
- README&#46;md

You can explore the image using
```
docker run --entrypoint=/bin/bash -it "image name"
```

Note that the WORKDIR is set to /home/circleci and all logs will be saved to that folder by default. You can export the logs from the container with
```
docker cp "container name":/home/circleci/name.log name.log
```

For more instructions, please check the official docker documentation.

## Database Setup

Before starting the servers, you need to:

1. **Create databases**: `auth`, `characters`, `world`, `hotfixes`
2. **Import base SQL files** from `sql/base/`:
   - `sql/base/auth_database.sql`
   - `sql/base/characters_database.sql`
   - `sql/base/dev/world_database.sql` (structure only)
3. **Download and import TDB** (Trinity Database):
   - Download from [TrinityCore Releases](https://github.com/TrinityCore/TrinityCore/releases)
   - Import TDB file matching your branch (e.g., `TDB_full_world_335.63_*.sql` for 3.3.5)
   - **Important**: TDB is separate from core repository and must be downloaded manually

## Limitations:

- **Database connection**: 
  - Manual instructions expect MySQL to run on the host machine using UNIX socket
  - For Docker Compose setup, MySQL runs in a container and uses TCP connection via service name
  - Change `docker run` parameters and .conf settings to fit your scenario
- **TDB import**: 
  - TDB must be downloaded separately from GitHub releases
  - Import TDB after importing base database structure
  - To import TDB using the autoupdater:
    1. Download the TDB sql file from GitHub.
    1. Map it with `--volume=/path/to/TDB_full_name.sql:/home/circleci/TDB_full_name.sql` added to the commands specified in the main steps above.
    1. Run the container.
- **Game data files**: Maps, vmaps, and DBC files must be extracted from game client and placed in DataDir
