## 1.
- create project docker_postgres
- create file docker-compose.yml
- add the following content to docker-compose.yml
```yaml
services:  
  postgres_db: # you can change this name
    image: postgres:16-alpine # you can change this image
    container_name: my-postgres # you can change this name
    environment: 
      POSTGRES_PASSWORD: mysecretpassword # you can change this password
    ports:
      - "5433:5432" # you can change the port mapping
    volumes:
      - pgdata:/var/lib/postgresql/data 
    restart: always # this will restart the container if it stops

volumes:
  pgdata:
``` 

## 2. run postgres container by docker compose

- run the following command to start the container
```sh
docker compose up -d
```

- check if the container is running
```sh
docker ps
```

## 3. connect to the PostgreSQL database
- open wsl terminal (Ubuntu/Debian)
- searching IP address of WSL2 VM
```sh
ip addr show eth0 | grep inet
```
- you will see something like this 
```inet
192.168.1.100/24
```
- select the IP address (192.168.1.100) and use it to connect to the PostgreSQL database from your host machine.
```sh
psql -h 192.168.1.100 -p 5433 -U postgres
```
- or the next step

## 4. connect to PostgreSQL using a client UI tool
- select client UI tool (e.g., pgAdmin, DBeaver) and connect using the following details:
  - assuming you are using pgAdmin
    - open pgAdmin
    - click Server > Register > Server
    - fill in the details:
      - Name: My Postgres Server <!-- you can change this name -->
      - Host: 192.168.1.100 <!-- should match the IP address from the previous step -->
      - Port: 5433 <!-- should match the port mapping in docker-compose.yml -->
      - Maintenance database: postgres
      - Username: postgres
      - Password: mysecretpassword <!-- should match the password in docker-compose.yml -->
      - SSL: Disable
    - click Save
- you should now be able to see the PostgreSQL server in pgAdmin and manage your databases.