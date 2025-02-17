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




## Azure

### Deploying Flowise on Azure App Service with Docker

 This guide will help you deploy **Flowise** on **Azure App Service** using **Docker** with PostgreSQL as the database.

### Prerequisites

- An **Azure account** with App Service enabled

- **Azure CLI** installed

- **PostgreSQL database** (can be an Azure Database for PostgreSQL instance)

- **Docker** installed locally

- **GitHub Actions/Azure DevOps** for CI/CD (optional)


## Deploy to Azure App Service

### 1. Build and Push the Docker Image

    docker build -t yourdockerhub/flowise-azure:latest .
    docker push yourdockerhub/flowise-azure:latest


### 2. Create an Azure Web App with Docker Container

    az webapp create --resource-group <RESOURCE_GROUP> \
        --plan <APP_SERVICE_PLAN> \
        --name <FLOWISE_APP_NAME> \
        --deployment-container-image-name yourdockerhub/flowise-azure:latest


### 3. Configure Environment Variables

Set environment variables in Azure App Service:  

    az webapp config appsettings set --resource-group <RESOURCE_GROUP> \
        --name <FLOWISE_APP_NAME> \
        --settings \
        DATABASE_TYPE=postgres \
        DATABASE_HOST=<DATABASE_HOST> \
        DATABASE_PORT=5432 \
        DATABASE_NAME=<DATABASE_NAME> \
        DATABASE_USER=<DATABASE_USER> \
        DATABASE_PASSWORD=<DATABASE_PASSWORD> \
        DATABASE_SSL=true

### 4. Restart the Web App

    az webapp restart --name <FLOWISE_APP_NAME> --resource-group <RESOURCE_GROUP>


## Monitoring Logs

### To view container logs in Azure, run:   
    az webapp log tail --name <FLOWISE_APP_NAME> --resource-group <RESOURCE_GROUP>

## Summary

This setup ensures Flowise runs smoothly on Azure App Service using Docker, with a PostgreSQL backend. Let me know if you need further optimizations!

##
