# การใช้งาน Docker กับ PostgreSQL และ pgAdmin

## 1. การตั้งค่าไฟล์

### 1.1 สร้างไฟล์ `.env`

```properties
# PostgreSQL Configuration
POSTGRES_USER=user_v0
POSTGRES_PASSWORD=password_v0
POSTGRES_DB=db_v0
POSTGRES_PORT=5432

# pgAdmin Configuration
PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=admin_password
PGADMIN_LISTEN_PORT=5050
```

### 1.2 สร้างไฟล์ `docker-compose.yml`

```yaml
services:
  postgres_v0:
    image: postgres:16-alpine
    container_name: postgres_v0
    ports:
      - "${POSTGRES_PORT}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - postgres_network

  postgres_v1:
    image: postgres:16-alpine
    container_name: postgres_v1
    ports:
      - "5433:5432"
    volumes:
      - postgres_data_v1:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: ${POSTGRES_USER_V1}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD_V1}
      POSTGRES_DB: ${POSTGRES_DB_V1}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER_V1}"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - postgres_network

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: my_pgadmin
    ports:
      - "${PGADMIN_LISTEN_PORT}:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    depends_on:
      - postgres_v0
      - postgres_v1
    restart: unless-stopped
    networks:
      - postgres_network

volumes:
  postgres_data:
  postgres_data_v1:
  pgadmin_data:

networks:
  postgres_network:
    driver: bridge
```

## 2. การเริ่มต้นใช้งาน

1. สร้าง network และ volume:
```bash
docker network create postgres_network
```

2. รัน container ทั้งหมด:
```bash
docker compose up -d
```

3. ตรวจสอบว่า container ทำงานอยู่:
```bash
docker ps
```

## 3. การเชื่อมต่อกับ PostgreSQL ผ่าน pgAdmin

### 3.1 เข้าสู่ระบบ pgAdmin

1. เปิดเว็บเบราว์เซอร์ไปที่:
```
http://localhost:5050
```

2. ล็อกอินด้วยข้อมูลจาก .env:
- Email: `admin@example.com`
- Password: `admin_password`

### 3.2 เพิ่ม PostgreSQL V0 Server

1. คลิกขวาที่ "Servers" → "Register" → "Server"
2. ใน General tab:
   - Name: `PostgreSQL V0`

3. ใน Connection tab:
   - Host name/address: `postgres_v0`
   - Port: `5432`
   - Maintenance database: `db_v0`
   - Username: `user_v0`
   - Password: `password_v0`
   - Save password: ✓

### 3.3 เพิ่ม PostgreSQL V1 Server

1. คลิกขวาที่ "Servers" → "Register" → "Server"
2. ใน General tab:
   - Name: `PostgreSQL V1`

3. ใน Connection tab:
   - Host name/address: `postgres_v1`
   - Port: `5432`
   - Maintenance database: `db_v1`
   - Username: `user_v1`
   - Password: `password_v1`
   - Save password: ✓

### 3.4 ทดสอบการเชื่อมต่อ

1. คลิกขวาที่แต่ละ Server แล้วเลือก "Connect Server"
2. ตรวจสอบการเชื่อมต่อใน Dashboard
3. สามารถดู databases และ schemas ได้ในแต่ละ Server

## 4. การเข้าถึง PostgreSQL โดยตรง

### 4.1 เชื่อมต่อ PostgreSQL V0 จาก Host

```bash
# ใช้ port จาก .env
psql -h localhost -p ${POSTGRES_PORT} -U user_v0 db_v0
```

### 4.2 เชื่อมต่อ PostgreSQL V1 จาก Host

```bash
psql -h localhost -p 5433 -U user_v1 db_v1
```

### 4.3 เข้าถึง Container โดยตรง

```bash
# เข้าถึง PostgreSQL V0
docker exec -it postgres_v0 psql -U user_v0 db_v0

# เข้าถึง PostgreSQL V1
docker exec -it postgres_v1 psql -U user_v1 db_v1
```

## 5. การใช้งาน PostgreSQL ผ่าน pgAdmin

### 5.1 สร้างฐานข้อมูลใหม่
1. คลิกขวาที่ Databases
2. เลือก Create → Database
3. กรอกชื่อฐานข้อมูลและตั้งค่าตามต้องการ

### 5.2 นำเข้าและส่งออกข้อมูล
1. คลิกขวาที่ฐานข้อมูล
2. เลือก Backup หรือ Restore
3. ทำตามขั้นตอนในหน้าต่าง Wizard

### 5.3 ตัวอย่าง SQL Query
```sql
-- สร้างตาราง
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- เพิ่มข้อมูล
INSERT INTO users (username, email) 
VALUES ('user1', 'user1@example.com');

-- ค้นหาข้อมูล
SELECT * FROM users WHERE username LIKE 'user%';

-- อัพเดทข้อมูล
UPDATE users SET email = 'new_email@example.com' 
WHERE username = 'user1';
```

## 6. การจัดการ Container และข้อมูล

### 6.1 การจัดการ Container
```bash
# ดูล็อกของ container
docker logs postgres_v0
docker logs postgres_v1
docker logs my_pgadmin

# รีสตาร์ท container
docker restart postgres_v0
docker restart postgres_v1
docker restart my_pgadmin

# หยุดการทำงานทั้งหมด
docker compose down
```

### 6.2 การสำรองและกู้คืนข้อมูล
```bash
# สำรอง PostgreSQL V0
docker exec postgres_v0 pg_dump -U user_v0 db_v0 > backup_v0.sql

# สำรอง PostgreSQL V1
docker exec postgres_v1 pg_dump -U user_v1 db_v1 > backup_v1.sql

# กู้คืนข้อมูล V0
docker exec -i postgres_v0 psql -U user_v0 db_v0 < backup_v0.sql

# กู้คืนข้อมูล V1
docker exec -i postgres_v1 psql -U user_v1 db_v1 < backup_v1.sql
```

## 7. การแก้ไขปัญหา

### 7.1 ปัญหาการเชื่อมต่อ pgAdmin
```bash
# ตรวจสอบ network
docker network inspect postgres_network

# ตรวจสอบการเชื่อมต่อระหว่าง container
docker exec my_pgadmin ping postgres_v0
docker exec my_pgadmin ping postgres_v1

# ตรวจสอบ log
docker logs my_pgadmin
```

### 7.2 ปัญหาการเชื่อมต่อ PostgreSQL
```bash
# ตรวจสอบสถานะ
docker ps | grep postgres

# ตรวจสอบ log
docker logs postgres_v0
docker logs postgres_v1

# ทดสอบการเชื่อมต่อภายใน container
docker exec postgres_v0 pg_isready
docker exec postgres_v1 pg_isready
```

## 8. แนวทางการรักษาความปลอดภัย

### 8.1 การตั้งค่าพื้นฐาน
- ใช้รหัสผ่านที่ซับซ้อนและไม่ซ้ำกัน
- เก็บข้อมูลสำคัญใน `.env` เสมอ
- อัพเดท image เป็นประจำ
- สำรองข้อมูลอย่างสม่ำเสมอ

### 8.2 การตั้งค่าขั้นสูง
- เปิดใช้งาน SSL/TLS
- จำกัด IP ที่สามารถเข้าถึง
- ตั้งค่า PostgreSQL authentication
- ตรวจสอบ log อย่างสม่ำเสมอ