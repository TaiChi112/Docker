# PostgreSQL 18.1 + pgAdmin (Docker Compose) — สำหรับ Docker Engine บน WSL

สแต็กนี้ตั้งใจทำให้ “production‑grade ในระดับ config” มากกว่าแค่ `up` แล้วใช้ได้ โดยใช้:
- `postgres:18.1`
- `dpage/pgadmin4:latest`
- healthcheck, secrets, configs, persistent volumes, logging rotation, hardening (no-new-privileges, cap_drop)

> โฟลเดอร์นี้ออกแบบให้รันจากใน WSL (ไม่ต้องมี Docker Desktop)

---

## 1) Prerequisites (ใน WSL)

ตรวจว่า Docker Engine และ Docker Compose ใช้งานได้:

```bash
docker version
docker compose version
```

ถ้า Docker daemon ยังไม่รัน (ขึ้น error ประมาณ cannot connect to daemon) ให้สตาร์ทตาม distro ของคุณ เช่น:

```bash
sudo service docker start
# หรือ
sudo systemctl start docker
```

> แนะนำให้ใช้ไฟล์โปรเจกต์ใน filesystem ของ WSL จะเร็วกว่า แต่ถ้าอยู่บนไดรฟ์ Windows ก็ใช้ได้ (เช่น `/mnt/d/...`).

---

## 2) เตรียมไฟล์ .env และ secrets

เข้าไปที่โฟลเดอร์โปรเจกต์จาก WSL:

```bash
cd /mnt/d/RepositoryVS/Docker/docker-postgresql
```

สร้าง `.env` จากตัวอย่าง:

```bash
cp .env.example .env
```

สร้างรหัสผ่านแบบ file‑based secrets (สำคัญ: อย่าใส่รหัสผ่านใน `.env`):

```bash
mkdir -p secrets
printf '%s' 'ChangeMe-Postgres-StrongPassword' > secrets/postgres_password.txt
printf '%s' 'ChangeMe-pgAdmin-StrongPassword'  > secrets/pgadmin_password.txt
chmod 600 secrets/*.txt
```

---

## 3) Run

```bash
docker compose pull
docker compose up -d
```

เช็คสถานะ:

```bash
docker compose ps
docker compose logs -f postgres
docker compose logs -f pgadmin
```

หยุด/เริ่มใหม่:

```bash
docker compose stop
docker compose start
```

ลบคอนเทนเนอร์ (ข้อมูลยังอยู่ใน named volumes):

```bash
docker compose down
```

รีเซ็ตทุกอย่างรวมข้อมูล (ระวังข้อมูลหาย):

```bash
docker compose down -v
```

---

## 4) Connect

### 4.1 ต่อเข้า Postgres ด้วย psql (จากในคอนเทนเนอร์)

```bash
docker compose exec -it postgres bash
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

### 4.2 เปิด pgAdmin

เปิดเบราว์เซอร์บน Windows:

- http://localhost:5050

ล็อกอินด้วย:
- Email: ค่า `PGADMIN_DEFAULT_EMAIL` ใน `.env`
- Password: เนื้อหาใน `secrets/pgadmin_password.txt`

จากนั้น Server จะถูก pre-register จาก `pgadmin/servers.json` (ชื่อ “Postgres (docker)”).
- Host: `postgres`
- Port: `5432`
- Username/DB: ตาม `.env`
- Password: ใช้รหัสผ่านเดียวกับ `secrets/postgres_password.txt`

---

## 5) หมายเหตุเกี่ยวกับความปลอดภัย/การเปิดพอร์ต

ค่าเริ่มต้นใน compose จะ bind Postgres/pgAdmin เฉพาะ `127.0.0.1` เพื่อไม่ให้เครื่องอื่นใน LAN มาเชื่อมต่อได้โดยไม่ตั้งใจ

ถ้าต้องการให้เครื่องอื่นในเครือข่ายต่อได้ (ระวังมาก):
- ตั้ง `POSTGRES_BIND_ADDRESS=0.0.0.0` และ/หรือ `PGADMIN_BIND_ADDRESS=0.0.0.0` ใน `.env`
- และควรจำกัด `pg_hba.conf` ให้เข้มงวดขึ้น (อย่าเปิดกว้างเกินจำเป็น)

---

## 6) ไฟล์สำคัญ

- `docker-compose.yml` โครงหลักของสแต็ก
- `postgres/postgresql.conf` tuning + logging + pg_stat_statements
- `postgres/pg_hba.conf` policy การอนุญาตเชื่อมต่อ
- `postgres/initdb/*.sql` สร้าง extensions (ทำงานครั้งแรกเท่านั้น)
- `pgadmin/servers.json` server registration สำหรับ pgAdmin
- `secrets/*.txt` เก็บรหัสผ่าน (ถูก ignore ด้วย `.gitignore`)
