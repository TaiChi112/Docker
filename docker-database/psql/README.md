# Database Docker Compose Collection

คอลเลคชันของ Docker Compose configurations สำหรับ databases ยอดนิยม ครอบคลุมตั้งแต่ basic setup ไปจนถึง production-ready และ high-availability configurations

## 📑 Table of Contents

- [🗃️ รองรับ Databases](#🗃️-รองรับ-databases)
- [📁 โครงสร้างโปรเจค](#📁-โครงสร้างโปรเจค)  
- [🚀 Quick Start Guide](#🚀-quick-start-guide)
- [🎯 Special Patterns & Use Cases](#🎯-special-patterns--use-cases)
- [📚 Documentation & Guides](#📚-documentation--guides)
- [🏥 Health Monitoring](#🏥-health-monitoring)
- [🛡️ Security & Production Readiness](#🛡️-security--production-readiness)
- [📊 Monitoring & Observability](#📊-monitoring--observability)
- [💾 Backup Strategies](#💾-backup-strategies)
- [🧪 Testing & Validation](#🧪-testing--validation)
- [⚠️ Common Issues & Solutions](#⚠️-common-issues--solutions)

> **💡 เริ่มต้นที่นี่**: ถ้าไม่แน่ใจจะใช้ database ไหน ให้ดู [📖 Documentation Index](docs/README.md) สำหรับคำแนะนำการเลือก

## 🗃️ รองรับ Databases

| Database | เวอร์ชัน | Management UI | High Availability | Special Features |
|----------|---------|---------------|-------------------|------------------|
| **PostgreSQL** | 16 | pgAdmin | HAProxy + Replication | PostGIS, pgVector, Extensions |
| **MySQL** | 8.4 | phpMyAdmin | ProxySQL + Master-Slave | InnoDB Cluster, Slow Query Log |
| **MongoDB** | 7 | Mongo Express | Replica Set | Sharding, GridFS, Aggregation |
| **Redis** | 7 | RedisInsight | Sentinel + Clustering | Stack Modules, Pub/Sub, Streams |

## 📁 โครงสร้างโปรเจค

```
compose/
├── psql/                 # PostgreSQL configurations
│   ├── minimal/          # Basic setup
│   ├── dev/              # Development with pgAdmin
│   ├── prod/             # Production ready
│   ├── ha/               # High Availability
│   └── patterns/         # Special patterns (PostGIS, pgVector, etc.)
├── mysql/                # MySQL configurations  
│   ├── minimal/          # Basic setup
│   ├── dev/              # Development with phpMyAdmin
│   ├── prod/             # Production ready
│   ├── ha/               # High Availability with ProxySQL
│   └── patterns/         # Special patterns (Cluster, Backup, etc.)
├── mongo/                # MongoDB configurations
│   ├── minimal/          # Basic setup
│   ├── dev/              # Development with Mongo Express
│   ├── prod/             # Production ready
│   ├── ha/               # Replica Set configuration
│   └── patterns/         # Special patterns (Sharding, GridFS, etc.)
└── redis/                # Redis configurations
    ├── minimal/          # Basic setup
    ├── dev/              # Development with RedisInsight
    ├── prod/             # Production ready
    ├── ha/               # High Availability with Sentinel
    └── patterns/         # Special patterns (Stack, Cluster, etc.)
```

## 🚀 Quick Start Guide

### เลือก Database ที่ต้องการ

#### 🐘 PostgreSQL - Relational Database
```bash
# Minimal setup
cd compose/psql/minimal && docker compose up -d

# Development with pgAdmin
cd compose/psql/dev && docker compose -f docker-compose.dev.yml up -d
# เข้า pgAdmin: http://localhost:5050

# High Availability
cd compose/psql/ha && docker compose -f docker-compose.ha.yml up -d
```

#### 🐬 MySQL - Popular Relational Database  
```bash
# Minimal setup
cd compose/mysql/minimal && docker compose up -d

# Development with phpMyAdmin
cd compose/mysql/dev && docker compose -f docker-compose.dev.yml up -d
# เข้า phpMyAdmin: http://localhost:8080

# High Availability with ProxySQL
cd compose/mysql/ha && docker compose -f docker-compose.ha.yml up -d
```

#### 🍃 MongoDB - Document Database
```bash
# Minimal setup
cd compose/mongo/minimal && docker compose up -d

# Development with Mongo Express
cd compose/mongo/dev && docker compose -f docker-compose.dev.yml up -d
# เข้า Mongo Express: http://localhost:8081

# Replica Set for High Availability
cd compose/mongo/ha && docker compose -f docker-compose.ha.yml up -d
```

#### 🔴 Redis - In-Memory Database
```bash
# Minimal setup
cd compose/redis/minimal && docker compose up -d

# Development with RedisInsight
cd compose/redis/dev && docker compose -f docker-compose.dev.yml up -d  
# เข้า RedisInsight: http://localhost:8001

# High Availability with Sentinel
cd compose/redis/ha && docker compose -f docker-compose.sentinel.yml up -d
```

## 📚 Documentation & Guides

แต่ละ database มีเอกสารแยกเป็นหมวดหมู่ อ่านได้ตามความสนใจ:

### 📖 Database-Specific Documentation

| Database | เอกสาร | เนื้อหาโดยย่อ |
|----------|--------|---------------|  
| **PostgreSQL** | [\`docs/postgresql.md\`](docs/postgresql.md) | pgAdmin, PostGIS, pgVector, HAProxy, Replication |
| **MySQL** | [\`docs/mysql.md\`](docs/mysql.md) | phpMyAdmin, ProxySQL, Master-Slave, InnoDB Cluster |
| **MongoDB** | [\`docs/mongodb.md\`](docs/mongodb.md) | Mongo Express, Replica Sets, Sharding, GridFS |
| **Redis** | [\`docs/redis.md\`](docs/redis.md) | RedisInsight, Sentinel, Clustering, Stack Modules |

### 📋 Contents Preview

แต่ละเอกสารประกอบด้วย:
- **Quick Start Guide** - เริ่มต้นใช้งานได้ทันที
- **Configuration Details** - ตั้งค่าแบบละเอียด
- **Security Best Practices** - แนวทางปลอดภัย
- **Performance Optimization** - เทคนิคเพิ่มประสิทธิภาพ  
- **Monitoring & Observability** - การ monitor และ metrics
- **Backup & Recovery** - กลยุทธ์การสำรองและกู้คืน
- **Troubleshooting** - แก้ปัญหาที่พบบ่อย
- **Testing Checklist** - วิธีทดสอบระบบ

## 🏥 Health Monitoring

### Standard Health Checks

| Database | Health Check Command | Port | Interval |
|----------|---------------------|------|----------|
| **PostgreSQL** | \`pg_isready -U user -d db\` | 5432 | 10s |
| **MySQL** | \`mysqladmin ping -h localhost\` | 3306 | 10s |
| **MongoDB** | \`mongosh --eval "db.runCommand('ping')"\` | 27017 | 15s |
| **Redis** | \`redis-cli PING\` | 6379 | 10s |

### Management UIs & Monitoring

| Database | Web UI | URL | Monitoring Port |
|----------|---------|-----|----------------|
| **PostgreSQL** | pgAdmin | http://localhost:5050 | 9187 (Prometheus) |
| **MySQL** | phpMyAdmin | http://localhost:8080 | 9104 (Prometheus) |
| **MongoDB** | Mongo Express | http://localhost:8081 | 9216 (Prometheus) |  
| **Redis** | RedisInsight | http://localhost:8001 | 9121 (Prometheus) |

## 🔧 Quick Commands

### Validation & Testing
```bash
# Validate Docker Compose files
docker compose -f compose/[database]/[environment]/docker-compose*.yml config

# Start any configuration
docker compose -f compose/[database]/[environment]/docker-compose*.yml up -d

# Check container health
docker compose ps

# View logs
docker compose logs [service-name]

# Stop and cleanup
docker compose down -v
```

## 📄 License & Getting Started

**MIT License** - ดู [LICENSE](LICENSE) file สำหรับรายละเอียดเต็ม

### 🚀 เริ่มต้นใช้งาน
1. Clone repository นี้
2. เลือก database และ environment ที่ต้องการ
3. อ่านเอกสารใน [`docs/`](docs/) folder สำหรับรายละเอียด
4. รัน `docker compose up -d` เพื่อเริ่มใช้งาน

### 💡 แนะนำสำหรับผู้เริ่มต้น
- เริ่มจาก `minimal/` configurations
- ทดลอง `dev/` environments พร้อม management UIs
- อ่าน [`docs/README.md`](docs/README.md) เพื่อเลือก database ที่เหมาะสม

**⚠️ Disclaimer**: Configurations นี้เหมาะสำหรับ development และ testing ก่อนนำไปใช้ใน production โปรดปรับแต่ง security settings ให้เหมาะสม
