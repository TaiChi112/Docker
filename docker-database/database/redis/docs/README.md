```sh
mkdir redis && cd redis && touch docker-compose.redis.yml && code .
```

```yml
services:
  redis_db: # Service name
    image: redis:alpine # Use the official Redis Alpine image
    container_name: my_redis # Name of the container
    ports:
      - "6379:6379" # Map host port 6379 to container port 6379
    volumes:
      - redis_data:/data # Persist Redis data in a named volume
    restart: unless-stopped # Always restart unless stopped manually

volumes:
  redis_data: # Named volume for data persistence
```

```sh
docker compose up -d
```

```sh
docker exec -it my_redis sh
```
or
```sh
docker exec -it my_redis redis-cli
```

```sh
# Basic Redis commands
ping
set mykey "Hello, Redis!"
get mykey
```

### After this, you can use Redis commands to interact with your data.

```sh
# To see all keys
keys *
```

### If you want to exit the Redis CLI, you can type:

```sh
exit
```

Exit the container shell:
```sh
exit
```

```sh
redis-cli -h 127.0.0.1 -p 6379
```