
# PostgreSQL & pgAdmin with Docker Compose

## โครงสร้าง docker-compose.yml

### 1. Service: Database Server (PostgreSQL)
- `image`: กำหนด image ของ PostgreSQL (เช่น postgres:16)
- `container_name`: ชื่อ container (เช่น postgres_db)
- `restart`: always (ให้ container restart อัตโนมัติ)
- `environment`:
    - `POSTGRES_USER`: ชื่อผู้ใช้ฐานข้อมูล (เช่น admin)
    - `POSTGRES_PASSWORD`: รหัสผ่านฐานข้อมูล (เช่น secret)
    - `POSTGRES_DB`: ชื่อฐานข้อมูล (เช่น mydb)
- `ports`: กำหนด port mapping (5432:5432)
- `volumes`: กำหนดตำแหน่งเก็บข้อมูลถาวรระหว่าง container กับ local (postgres_data:/var/lib/postgresql/data)

### 2. Service: Database Client (pgAdmin)
- `image`: กำหนด image ของ pgAdmin (เช่น dpage/pgadmin4:latest)
- `container_name`: ชื่อ container (เช่น pgadmin)
- `restart`: always
- `environment`:
    - `PGADMIN_DEFAULT_EMAIL`: อีเมลสำหรับเข้าสู่ระบบ pgAdmin (เช่น admin@local.com)
    - `PGADMIN_DEFAULT_PASSWORD`: รหัสผ่านสำหรับเข้าสู่ระบบ pgAdmin (เช่น secret)
- `ports`: กำหนด port mapping (5050:80)
- `depends_on`: ให้ pgAdmin รอ database server พร้อมก่อน

### 3. Volumes
- `postgres_data`: กำหนด volume สำหรับเก็บข้อมูลถาวรของ PostgreSQL

---

## วิธีใช้งาน pgAdmin เพื่อเชื่อมต่อกับ PostgreSQL

1. เปิดเว็บเบราว์เซอร์ไปที่ `http://localhost:5050`
2. Login ด้วย
     - Email: `admin@local.com`
     - Password: `secret`
3. Add New Server แล้วกรอกข้อมูลดังนี้

**General**
- Name: กำหนดชื่ออะไรก็ได้ เช่น postgres_db

**Connection**
- Host name/address: `db` (ถ้า pgAdmin อยู่ใน docker-compose เดียวกัน) หรือ `localhost` (ถ้าเข้าจากเครื่องจริง)
- Port: `5432`
- Username: `admin`
- Password: `secret`
- Maintenance database: `mydb`
- (Optional) Save Password: ติ๊กถูก "Save Password" เพื่อไม่ต้องกรอกใหม่ทุกครั้ง

---

## การเพิ่ม/ขยาย (Scale) Service Database Server

หากต้องการเพิ่ม service database server (เช่น ต้องการหลาย instance หรือหลาย database server):
1. เพิ่ม service ใหม่ในไฟล์ `docker-compose.yml` โดยเปลี่ยนชื่อ service, container_name, ports, volumes และ environment ให้ไม่ซ้ำกับของเดิม
2. สามารถใช้ pgAdmin ตัวเดิมในการเชื่อมต่อและจัดการ database server หลายตัวได้ โดยเพิ่ม server ใน pgAdmin ตามข้อมูลของแต่ละ service

**ตัวอย่าง**

```yaml
services:
    db:
        image: postgres:16
        container_name: postgres_db
        ...existing code...
    db2:
        image: postgres:16
        container_name: postgres_db2
        environment:
            POSTGRES_USER: admin2
            POSTGRES_PASSWORD: secret2
            POSTGRES_DB: mydb2
        ports:
            - "5433:5432"
        volumes:
            - postgres_data2:/var/lib/postgresql/data
    pgadmin:
        ...existing code...
volumes:
    postgres_data:
    postgres_data2:
```

**หมายเหตุ**
- ต้องกำหนด port, volume, และ environment ให้ต่างกันในแต่ละ service
- pgAdmin สามารถเพิ่ม server ได้ไม่จำกัดจำนวน (ขึ้นกับ resource)

---

## สรุป

- สามารถใช้ docker-compose นี้เพื่อรัน PostgreSQL และ pgAdmin ได้ทันที
- สามารถเพิ่ม/scale database server ได้โดยเพิ่ม service ใน compose file และเพิ่ม server ใน pgAdmin
- ข้อมูลสำคัญสำหรับเชื่อมต่อ (Connection info):
    - Host name/address: `db` หรือ `localhost`
    - Port: `5432` (หรือ port ที่กำหนด)
    - Username: `admin`
    - Password: `secret`
    - Maintenance database: `mydb`