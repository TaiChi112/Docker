```sh
mkdir mysql && cd mysql && touch docker-compose.mysql.yml && code .
```

```yml
services:
  mysql_db: # Service name
    image: mysql:lts-oraclelinux9 # Use the official MySQL 8.0 image
    container_name: my_mysql # Name of the container
    ports:
      - "3306:3306" # Map host port 3306 to container port 3306
    volumes:
      - mysql_data:/var/lib/mysql # Persist MySQL data in a named volume
    environment:
      MYSQL_ROOT_PASSWORD: root # Root password (change to a strong password)
      MYSQL_DATABASE: my_app_db      # Default database to create (change as needed)
      MYSQL_USER: taichi                  # New user to create (change as needed)
      MYSQL_PASSWORD: mysecretpassword          # Password for the new user (change as needed)
    restart: unless-stopped # Always restart unless stopped manually

volumes:
  mysql_data: # Named volume for data persistence
```

```sh
docker compose up -d
```

```sh
docker exec -it my_mysql sh 
```
or
```sh
docker exec -it my_mysql mysql -u root -proot || docker exec -it my_mysql mysql -u taichi -pmysecretpassword
```

```sql
show databases;
```

```sql
use my_app_db; <!-- reference tracking in docker-compose.mysql.yml -->
```

### after this, you can create tables and insert data as needed.

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, email) VALUES
('john_doe', 'john@example.com'),
('jane_doe', 'jane@example.com');
SELECT * FROM users;
```

### if you want to exit the MySQL shell, you can type:

```sql
exit;
```

exit the container shell:
```sh
exit
```
