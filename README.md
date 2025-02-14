# Flowise Setup

## Local

### This guide provides instructions on how to set up Flowise using Docker and Docker Compose with PostgreSQL as the database backend.

### Prerequisites

### Ensure you have the following installed on your system:
* [Docker]()

* [Docker Compose]()

* A PostgreSQL database instance

## Dockerfile

Create a `Dockerfile` in the root directory:    
```
FROM flowiseai/flowise:latest
RUN find /usr/local/lib/node_modules/flowise/dist/database/migrations/postgres/ -type f -exec sed -i 's/uuid_generate_v4()/gen_random_uuid()/g' {} +
```
### Explanation of the `RUN` Command

This command:
1) Searches (`find`) all files in the PostgreSQL migration directory (`/usr/local/lib/node_modules/flowise/dist/database/migrations/postgres/`).

2) Filters for regular files (`-type f`).

3) Executes (`-exec`) the `sed` command to replace all occurrences of `uuid_generate_v4()` with `gen_random_uuid()`.

4) The `{}` represents each file found, and `+` ensures that multiple files are processed efficiently in batches.The reason for this replacement is that `uuid_generate_v4()` requires the `uuid-ossp` extension, which may not be available by default in some PostgreSQL installations. The `gen_random_uuid()` function is an alternative provided by the `pgcrypto` extension, which is more commonly enabled.

## Docker Compose Configuration

Create a `docker-compose.yaml` file:    
```
version: '3'
services:
  flowise:
    build: .
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - DATABASE_TYPE=postgres
      - DATABASE_HOST=$DATABASE_HOST 
      - DATABASE_PORT=5432
      - DATABASE_NAME=$DATABASE_NAME
      - DATABASE_USER=$DATABASE_USER
      - DATABASE_PASSWORD=$DATABASE_PASSWORD 
      - DATABASE_SSL=true
    restart: always
```
-----------------------

## Environment Variables

> Ensure you have the required environment variables set:    
```
    export DATABASE_HOST="your-database-host"
    export DATABASE_NAME="your-database-name"
    export DATABASE_USER="your-database-user"
    export DATABASE_PASSWORD="your-database-password"
```
-----------------------------------------------------

## Running the Setup

1. Build the Docker image:

       docker-compose build

2. Start the container:

       docker-compose up -d

3. Verify the logs:

       docker-compose logs -f

4. Access Flowise at:

       http://localhost:3000

## Stopping the Container

## To stop the running container, execute:    

    docker-compose down

## Troubleshooting

## - If the container fails to start, check the logs using:

      docker-compose logs -f

- Ensure the PostgreSQL database is running and accessible.

- Check if all required environment variables are correctly set.
