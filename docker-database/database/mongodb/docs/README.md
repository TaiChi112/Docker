```sh
mkdir mongodb && cd mongodb && touch docker-compose.mongodb.yml && code .
```

```yml
services:
  mongodb_db: # Service name
    image: bitnami/mongodb:latest # Use the official Bitnami MongoDB image
    container_name: my_mongodb # Name of the container
    ports:
      - "27017:27017" # Map host port 27017 to container port 27017
    volumes:
      - mongodb_data:/bitnami/mongodb # Persist MongoDB data in a named volume
    environment:
      MONGODB_ROOT_PASSWORD: rootpassword # Root password (change to a strong password)
      MONGODB_DATABASE: my_app_db         # Default database to create (change as needed)
      MONGODB_USERNAME: taichi            # New user to create (change as needed)
      MONGODB_PASSWORD: mysecretpassword  # Password for the new user (change as needed)
    restart: unless-stopped # Always restart unless stopped manually

volumes:
  mongodb_data: # Named volume for data persistence
```

```sh
docker compose up -d
```

```sh
docker exec -it my_mongodb bash
```
or
```sh
docker exec -it my_mongodb mongosh -u taichi -p mysecretpassword --authenticationDatabase my_app_db
```

```sh
# Basic MongoDB commands
show dbs
use my_app_db
db.createCollection("test")
db.test.insertOne({ message: "Hello, MongoDB!" })
db.test.find()
```

### To exit the MongoDB shell, type:

```sh
exit
```

Exit the container shell:
```sh
exit

```sh
mongosh --host 127.0.0.1 --port 27017
```