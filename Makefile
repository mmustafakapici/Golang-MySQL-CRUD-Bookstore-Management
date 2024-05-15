# Makefile for setting up MySQL with Docker

# MySQL Docker Image and Container settings
MYSQL_IMAGE := mysql:latest
MYSQL_CONTAINER := golang_mysql_container
MYSQL_ROOT_PASSWORD := rootpassword
MYSQL_DATABASE := bookstore
MYSQL_USER := user
MYSQL_PASSWORD := password

# Docker Network settings
NETWORK_NAME := golang_mysql_network

# MySQL Docker Volume
MYSQL_DATA_VOLUME := golang_mysql_data

.PHONY: all build start stop clean env

# Default target
all: build start env

# Build the Docker environment
build: 
	@echo "Creating Docker network..."
	@docker network create $(NETWORK_NAME) || true

	@echo "Creating MySQL data volume..."
	@docker volume create $(MYSQL_DATA_VOLUME) || true

# Start the MySQL container
start: 
	@echo "Starting MySQL container..."
	@docker run --name $(MYSQL_CONTAINER) --network $(NETWORK_NAME) -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
		-e MYSQL_DATABASE=$(MYSQL_DATABASE) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
		-v $(MYSQL_DATA_VOLUME):/var/lib/mysql -p 3306:3306 -d $(MYSQL_IMAGE)
	@echo "Waiting for MySQL to start..."
	@sleep 20 # MySQL'in başlatılmasını bekleyin

# Stop the MySQL container
stop: 
	@echo "Stopping MySQL container..."
	@docker stop $(MYSQL_CONTAINER) || true
	@docker rm $(MYSQL_CONTAINER) || true

# Clean up Docker environment
clean: stop
	@echo "Removing Docker network..."
	@docker network rm $(NETWORK_NAME) || true

	@echo "Removing MySQL data volume..."
	@docker volume rm $(MYSQL_DATA_VOLUME) || true

# Set environment variables for the application
env:
	@echo "Setting environment variables..."
	@chmod +x env.sh
	@sh env.sh
