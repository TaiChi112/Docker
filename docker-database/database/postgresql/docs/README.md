## PostgreSQL Docker Compose Setup

### 1. Create a Docker Compose File

Create a folder for your project and a `docker-compose.postgres.yml` file:

```sh
mkdir postgresql && cd postgresql && touch docker-compose.postgres.yml && code .
```

Add the following content to `docker-compose.postgres.yml`:

```yaml
services:
  postgres_db: # Service name
    image: postgres:16-alpine # Use the official PostgreSQL image
    container_name: my_postgres # Name of the container
    ports:
      - "5433:5432" # Map host port 5433 to container port 5432
    volumes:
      - pgdata:/var/lib/postgresql/data # Persist PostgreSQL data in a named volume
    environment:
      POSTGRES_PASSWORD: mysecretpassword # Password for the default 'postgres' user
      POSTGRES_USER: taichi              # (Optional) Custom user to create
      POSTGRES_DB: my_app_db             # (Optional) Default database to create
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped # Always restart unless stopped manually

volumes:
  pgdata: # Named volume for data persistence
```

---

### 2. Start the PostgreSQL Container

```sh
docker compose -f docker-compose.postgres.yml up -d
```

Check if the container is running:

```sh
docker ps
```

---

### 3. Connect to PostgreSQL

#### From Host or WSL

```sh
psql -h 127.0.0.1 -p 5433 -U postgres
```
Password: `mysecretpassword`

#### From Inside the Container

```sh
docker exec -it my-postgres psql -U postgres
```

---

### 4. Connect Using a Client UI Tool

You can use tools like **pgAdmin** or **DBeaver**.  
Connection details:

- **Host:** 127.0.0.1
- **Port:** 5433
- **Database:** postgres
- **Username:** postgres
- **Password:** mysecretpassword
- **SSL:** Disable

---

You can now manage your PostgreSQL server using the command line or a

```sh
psql -h 127.0.0.1 -p 5433 -U <username> <database>
```