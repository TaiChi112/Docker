# Docker on WS## - 🏃‍♂️ **ประสิทธิภาพสูง**: ใช้ทรัพยากรน้อยกว่า Docker Desktop มาก
- 💾 **ประหยัด RAM**: ลดการใช้หน่วยความจำได้หลายร้อย MBสารบัญ
1. [ข้อกำหนดเบื้องต้น](#ข้อกำหนดเบื้องต้น)
2. [การติดตั้ง WSL 2](#การติดตั้ง-wsl-2)
3. [การติดตั้ง Docker Engine บน WSL](#การติดตั้ง-docker-engine-บน-wsl)
4. [การตั้งค่าและเริ่มต้นใช้งาน Docker](#การตั้งค่าและเริ่มต้นใช้งาน-docker)
5. [การทดสอบการใช้งาน](#การทดสอบการใช้งาน)
6. [คำสั่งพื้นฐาน](#คำสั่งพื้นฐาน)
7. [การแก้ปัญหาที่พบบ่อย](#การแก้ปัญหาที่พบบ่อย)
8. [ตัวอย่างการใช้งาน](#ตัวอย่างการใช้งาน)
9. [สรุปขั้นตอนสำคัญ](#สรุปขั้นตอนสำคัญ)
10. [การติดตั้งและใช้งาน Rust และ Node.js บน WSL](#การติดตั้งและใช้งาน-rust-และ-nodejs-บน-wsl)้นใช้งาน Docker บน Windows Subsystem for Linux

> **🚀 เร็ว • 💪 เบา • 🔧 ประหยัดทรัพยากร**
>
> คู่มือสมบูรณ์สำหรับการติดตั้งและใช้งาน **Docker Engine โดยตรงบน WSL** โดยไม่ต้องใช้ Docker Desktop ที่ทำให้เครื่องหนัก!

## ✨ จุดเด่นของการใช้ Docker Engine บน WSL

- 🏃‍♂️ **ประสิทธิภาพสูง**: ใช้ทรัพยากรน้อยกว่า Docker Desktop มาก
- � **ประหยัด RAM**: ลดการใช้หน่วยความจำได้หลายร้อย MB
- ⚡ **เริ่มต้นเร็ว**: Docker service เริ่มทำงานได้ทันทีโดยไม่ต้องรอ GUI
- 🔒 **ความปลอดภัย**: รันโดยตรงใน Linux environment ที่มีความปลอดภัยสูง
- 🎯 **ควบคุมได้ง่าย**: จัดการ Docker service ด้วยคำสั่ง Linux แบบดั้งเดิม

## �📋 สารบัญ
1. [ข้อกำหนดเบื้องต้น](#ข้อกำหนดเบื้องต้น)
2. [การติดตั้ง WSL 2](#การติดตั้ง-wsl-2)
3. [การติดตั้ง Docker Engine บน WSL](#การติดตั้ง-docker-engine-บน-wsl)
4. [การตั้งค่าและเริ่มต้นใช้งาน Docker](#การตั้งค่าและเริ่มต้นใช้งาน-docker)
5. [การทดสอบการใช้งาน](#การทดสอบการใช้งาน)
6. [คำสั่งพื้นฐาน](#คำสั่งพื้นฐาน)
7. [การแก้ปัญหาที่พบบ่อย](#การแก้ปัญหาที่พบบ่อย)
8. [ตัวอย่างการใช้งาน](#ตัวอย่างการใช้งาน)
9. [สรุปขั้นตอนสำคัญ](#สรุปขั้นตอนสำคัญ)

---

## 🔧 ข้อกำหนดเบื้องต้น

### ระบบปฏิบัติการ
- Windows 10 version 2004 หรือใหม่กว่า (Build 19041+)
- Windows 11 (แนะนำ)

### ฮาร์ดแวร์
- CPU ที่รองรับ virtualization (Intel VT-x หรือ AMD-V)
- RAM อย่างน้อย 2GB (แนะนำ 4GB+)
- พื้นที่ดิสก์ว่างอย่างน้อย 10GB

### การเปิดใช้งาน Features
- Windows Subsystem for Linux
- Virtual Machine Platform

> **หมายเหตุ:** การติดตั้งแบบนี้ไม่ต้องใช้ Docker Desktop ทำให้ประหยัดทรัพยากรระบบมากขึ้น

---

## 🐧 การติดตั้ง WSL 2

### วิธีที่ 1: ใช้ PowerShell (แนะนำ)
เปิด PowerShell ในฐานะ Administrator และรันคำสั่ง:

```powershell
# ติดตั้ง WSL
wsl --install

# ตรวจสอบเวอร์ชัน WSL
wsl --version

# ตั้ค่า WSL เป็นเวอร์ชัน 2 (ถ้าจำเป็น)
wsl --set-default-version 2
```

### วิธีที่ 2: การติดตั้งแบบ Manual

1. **เปิดใช้งาน WSL และ Virtual Machine Platform**
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

2. **รีสตาร์ทเครื่อง**

3. **ดาวน์โหลดและติดตั้ง Linux Kernel Update Package**
   - ดาวน์โหลดจาก: https://aka.ms/wsl2kernel
   - ติดตั้งไฟล์ที่ดาวน์โหลดมา

4. **ตั้งค่า WSL 2 เป็นเวอร์ชันเริ่มต้น**
```powershell
wsl --set-default-version 2
```

5. **ติดตั้ง Linux Distribution**
```powershell
# ดูรายการ distributions ที่มี
wsl --list --online

# ติดตั้ง Ubuntu (แนะนำ)
wsl --install -d Ubuntu
```

### การตรวจสอบการติดตั้ง WSL
```bash
# ตรวจสอบรายการ WSL ที่ติดตั้ง
wsl -l -v

# ผลลัพธ์ควรแสดงเป็น VERSION 2
#   NAME      STATE           VERSION
# * Ubuntu    Running         2
```

---

## 🐳 การติดตั้ง Docker Engine บน WSL

### ติดตั้ง Docker Engine โดยตรงใน WSL (ไม่ใช้ Docker Desktop)

เปิด WSL Terminal และทำตามขั้นตอนต่อไปนี้:

#### 1. อัปเดตระบบและติดตั้ง dependencies
```bash
# อัปเดต package lists
sudo apt update && sudo apt upgrade -y

# ติดตั้ง packages ที่จำเป็น
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https
```

#### 2. เพิ่ม Docker official GPG key
```bash
# สร้าง directory สำหรับ keyrings
sudo mkdir -p /etc/apt/keyrings

# ดาวน์โหลดและเพิ่ม Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

#### 3. เพิ่ม Docker repository
```bash
# เพิ่ม Docker repository ใน apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 4. ติดตั้ง Docker Engine
```bash
# อัปเดต package lists อีกครั้ง
sudo apt update

# ติดตั้ง Docker Engine และ Docker Compose
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### 5. เพิ่ม user เข้า docker group
```bash
# เพิ่ม current user เข้า docker group
sudo usermod -aG docker $USER

# รีสตาร์ท shell session (หรือ logout/login ใหม่)
newgrp docker
```

---

## ⚙️ การตั้งค่าและเริ่มต้นใช้งาน Docker

### เริ่มต้น Docker Service

```bash
# เริ่มต้น Docker service
sudo service docker start

# ตรวจสอบสถานะ Docker service
sudo service docker status

# ตั้งค่าให้ Docker เริ่มต้นอัตโนมัติ (สำหรับ systemd)
# หมายเหตุ: WSL อาจไม่รองรับ systemd โดยค่าเริ่มต้น
# sudo systemctl enable docker
```

### การตั้งค่าให้ Docker เริ่มอัตโนมัติใน WSL

เนื่องจาก WSL ไม่มี systemd โดยค่าเริ่มต้น เราจะตั้งค่าให้เริ่ม Docker service ใน shell profile:

```bash
# เพิ่มคำสั่งเริ่ม Docker ใน .bashrc หรือ .zshrc
echo 'sudo service docker start > /dev/null 2>&1' >> ~/.bashrc
# หรือสำหรับ zsh:
echo 'sudo service docker start > /dev/null 2>&1' >> ~/.zshrc

# ตั้งค่า sudo ให้ไม่ต้องใส่ password สำหรับ docker service (แนะนำ)
echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/service docker start, /usr/sbin/service docker stop, /usr/sbin/service docker restart" | sudo tee /etc/sudoers.d/docker-service
```

### การแก้ปัญหา Permission (สำคัญ!)

หลังจากเพิ่ม user เข้า docker group แล้ว ต้องทำการ logout และ login ใหม่ หรือใช้วิธีใดวิธีหนึ่งต่อไปนี้:

```bash
# วิธีที่ 1: รีสตาร์ท WSL (แนะนำ)
# ใน Windows PowerShell:
# wsl --shutdown
# จากนั้นเปิด WSL ใหม่

# วิธีที่ 2: ใช้คำสั่งในขณะนั้น
newgrp docker

# วิธีที่ 3: รัน Docker ด้วย sudo ชั่วคราว
sudo docker run hello-world
```

### การตรวจสอบการติดตั้ง

```bash
# ตรวจสอบเวอร์ชัน Docker
docker --version

# ตรวจสอบสถานะ Docker
docker info

# ตรวจสอบ Docker Compose
docker compose version
```

---

## 🧪 การทดสอบการใช้งาน

### Hello World Container
```bash
# รัน Hello World container
docker run hello-world

# ผลลัพธ์ที่ควรได้รับ:
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
```

### ทดสอบ Web Server
```bash
# รัน Nginx web server
docker run -d -p 8080:80 --name test-nginx nginx

# ตรวจสอบ container ที่ทำงาน
docker ps

# ทดสอบเข้าถึงเว็บไซต์
curl http://localhost:8080

# หยุดและลบ container
docker stop test-nginx
docker rm test-nginx
```

---

## 📚 คำสั่งพื้นฐาน

### Container Management
```bash
# ดู containers ที่ทำงาน
docker ps

# ดู containers ทั้งหมด (รวมที่หยุดแล้ว)
docker ps -a

# รัน container แบบ interactive
docker run -it ubuntu:20.04 bash

# รัน container แบบ background
docker run -d nginx

# หยุด container
docker stop <container_id>

# ลบ container
docker rm <container_id>

# ลบ containers ทั้งหมดที่หยุดแล้ว
docker container prune
```

### Image Management
```bash
# ดูรายการ images
docker images

# ดาวน์โหลด image
docker pull ubuntu:20.04

# สร้าง image จาก Dockerfile
docker build -t myapp .

# ลบ image
docker rmi <image_id>

# ลบ images ที่ไม่ใช้
docker image prune
```

### Network และ Volume
```bash
# ดูรายการ networks
docker network ls

# ดูรายการ volumes
docker volume ls

# สร้าง volume
docker volume create myvolume

# รัน container พร้อม mount volume
docker run -v myvolume:/data ubuntu
```

---

## 🔧 การแก้ปัญหาที่พบบ่อย

### ปัญหา: Docker service ไม่เริ่มทำงาน
**วิธีแก้:**
```bash
# ตรวจสอบสถานะ Docker service
sudo service docker status

# เริ่ม Docker service ถ้าหยุดทำงาน
sudo service docker start

# ตรวจสอบ Docker daemon logs
sudo journalctl -u docker.service

# รีสตาร์ท Docker service
sudo service docker restart
```

### ปัญหา: Permission denied เมื่อใช้คำสั่ง docker
**วิธีแก้ (เรียงตามลำดับความแนะนำ):**

#### วิธีที่ 1: รีสตาร์ท WSL (แนะนำมากที่สุด)
```powershell
# ใน Windows PowerShell หรือ CMD
wsl --shutdown
# รอ 5 วินาที แล้วเปิด WSL ใหม่
```

#### วิธีที่ 2: ใช้คำสั่งตรวจสอบและแก้ไข
```bash
# ตรวจสอบว่าอยู่ใน docker group หรือไม่
groups $USER

# ถ้าไม่เห็น "docker" ในรายการ ให้เพิ่ม
sudo usermod -aG docker $USER

# รีสตาร์ท shell session
newgrp docker
```

#### วิธีที่ 3: ใช้ sudo ชั่วคราว (กรณีเร่งด่วน)
```bash
# รัน Docker ด้วย sudo จนกว่าจะแก้ permission ได้
sudo docker run hello-world
sudo docker ps
```

> **⚠️ หมายเหตุ**: การเปลี่ยน group membership จะมีผลเต็มที่เมื่อเริ่ม session ใหม่เท่านั้น

### ปัญหา: คำสั่ง docker ไม่ทำงานใน WSL
**วิธีแก้:**
1. ตรวจสอบว่า Docker service ทำงานหรือไม่: `sudo service docker status`
2. เริ่ม Docker service: `sudo service docker start`
3. ตรวจสอบว่าอยู่ใน docker group: `groups $USER`

### ปัญหา: Performance ช้า
**วิธีแก้:**
1. เก็บไฟล์โปรเจคใน WSL file system (`/home/user/` แทน `/mnt/c/`)
2. ปิด Windows Defender real-time scanning สำหรับ WSL folders
3. เพิ่ม RAM ให้ WSL ใน `.wslconfig`

### ไฟล์ .wslconfig (สำหรับปรับแต่ง Performance)
สร้างไฟล์ `.wslconfig` ใน `C:\Users\<username>\`:
```ini
[wsl2]
memory=8GB
processors=4
swap=2GB
localhostForwarding=true
```

---

## 💡 ตัวอย่างการใช้งาน

### 1. Web Development Environment
```bash
# สร้าง development environment สำหรับ Node.js
docker run -it --rm -v $(pwd):/app -w /app -p 3000:3000 node:16 bash

# หรือใช้ Docker Compose
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  web:
    image: node:16
    working_dir: /app
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    command: bash
    tty: true
    stdin_open: true
EOF

docker-compose up -d
docker-compose exec web bash
```

### 2. Database Development
```bash
# รัน MySQL database
docker run -d \
  --name mysql-dev \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=myapp \
  -p 3306:3306 \
  mysql:8.0

# รัน PostgreSQL database
docker run -d \
  --name postgres-dev \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=myapp \
  -p 5432:5432 \
  postgres:13
```

### 3. Multi-container Application
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
  
  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

```bash
# รันด้วย Docker Compose
docker-compose up -d

# ดู logs
docker-compose logs -f

# หยุดทุก services
docker-compose down
```

---

## 🚀 Best Practices

### 1. File System Performance
- เก็บโค้ดใน WSL file system (`/home/user/projects/`) แทน Windows file system (`/mnt/c/`)
- ใช้ VSCode with WSL extension สำหรับการพัฒนา

### 2. Resource Management
- ใช้ `.dockerignore` เพื่อลดขนาด build context
- ลบ unused containers และ images เป็นประจำ
- ใช้ multi-stage builds สำหรับ production images

### 3. Security
- อย่ารัน containers ในฐานะ root เมื่อไม่จำเป็น
- ใช้ official images จาก Docker Hub
- อัพเดท base images เป็นประจำ

### 4. การจัดการ Docker Service
```bash
# คำสั่งพื้นฐานในการจัดการ Docker service
sudo service docker start    # เริ่ม service
sudo service docker stop     # หยุด service
sudo service docker restart  # รีสตาร์ท service
sudo service docker status   # ตรวจสอบสถานะ
```

---

## 📖 แหล่งข้อมูลเพิ่มเติม

- [Docker Documentation](https://docs.docker.com/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Docker Engine Installation](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

## 🆘 การขอความช่วยเหลือ

หากพบปัญหาในการใช้งาน:
1. ตรวจสอบ [การแก้ปัญหาที่พบบ่อย](#การแก้ปัญหาที่พบบ่อย)
2. ดู Docker Desktop logs
3. ตรวจสอบ GitHub Issues ของ Docker Desktop
4. สอบถามใน Docker Community Forums

---

## 📝 สรุปขั้นตอนสำคัญ

### 🎯 Quick Start Guide - ทำตามนี้เลย!

#### ✅ ขั้นตอนที่ 1: ติดตั้ง WSL 2
```powershell
# ใน PowerShell (Administrator)
wsl --install
wsl --set-default-version 2
```

#### ✅ ขั้นตอนที่ 2: ติดตั้ง Docker Engine
```bash
# ใน WSL Terminal
# 1. อัพเดทระบบ
sudo apt update && sudo apt upgrade -y

# 2. ติดตั้ง dependencies
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. เพิ่ม Docker GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. เพิ่ม Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. ติดตั้ง Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### ✅ ขั้นตอนที่ 3: ตั้งค่า Permissions และ Auto-start
```bash
# 1. เพิ่ม user เข้า docker group
sudo usermod -aG docker $USER

# 2. ตั้งค่า sudo passwordless สำหรับ Docker service
echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/service docker start, /usr/sbin/service docker stop, /usr/sbin/service docker restart" | sudo tee /etc/sudoers.d/docker-service

# 3. เพิ่ม auto-start ใน shell profile
echo 'sudo service docker start > /dev/null 2>&1' >> ~/.zshrc
# หรือ ~/.bashrc สำหรับ bash

# 4. เริ่ม Docker service
sudo service docker start
```

#### ✅ ขั้นตอนที่ 4: ทดสอบ
```bash
# รีสตาร์ท WSL เพื่อให้ permissions มีผล (สำคัญ!)
# ใน Windows PowerShell: wsl --shutdown
# จากนั้นเปิด WSL ใหม่

# ทดสอบ Docker (ควรทำงานโดยไม่ต้องใช้ sudo)
docker run hello-world
docker --version
docker compose version

# หากยังมี permission error ให้ใช้ sudo ชั่วคราว:
# sudo docker run hello-world
```

#### 🔍 การตรวจสอบสถานะหลังติดตั้ง
```bash
# ตรวจสอบว่า Docker service ทำงานหรือไม่
sudo service docker status

# ตรวจสอบว่าอยู่ใน docker group หรือไม่
groups $USER

# ตรวจสอบเวอร์ชัน Docker ที่ติดตั้ง
docker --version                    # Docker version 28.4.0, build d8eb465
docker compose version             # Docker Compose version v2.39.4

# ทดสอบการทำงาน
docker run hello-world
```

### 🚨 ข้อควรระวัง

1. **Permission Issues**: หลังจากเพิ่ม user เข้า docker group แล้ว **ต้องรีสตาร์ท WSL** หรือ logout/login ใหม่
2. **Docker Service**: ต้องเริ่ม Docker service ก่อนใช้งาน: `sudo service docker start`
3. **File Permissions**: เก็บโปรเจคใน WSL file system (`/home/user/`) แทน Windows file system (`/mnt/c/`) เพื่อประสิทธิภาพดีกว่า

### 💡 เคล็ดลับประสิทธิภาพ

- **ประหยัด RAM**: วิธีนี้ใช้หน่วยความจำเพียง ~30MB แทนที่จะเป็นหลายร้อย MB ของ Docker Desktop
- **เร็วกว่า**: Docker Engine เริ่มทำงานภายใน 2-3 วินาที
- **ควบคุมได้ดี**: สามารถจัดการ Docker service ด้วยคำสั่ง Linux มาตรฐาน
- **เสถียร**: ไม่มี GUI ที่อาจจะค้างหรือใช้ทรัพยากรโดยไม่จำเป็น

### ⚙️ สถานะระบบที่ทดสอบแล้ว

| คอมโพเนนต์ | เวอร์ชัน | สถานะ |
|-----------|---------|--------|
| Docker Engine | 28.4.0, build d8eb465 | ✅ ติดตั้งสำเร็จ |
| Docker Compose | v2.39.4 | ✅ ทำงานได้ |
| WSL Version | 2 | ✅ พร้อมใช้งาน |
| Ubuntu | ติดตั้งใน WSL | ✅ ทำงานปกติ |

**การใช้หน่วยความจำ**: Docker service ใช้เพียง ~28MB RAM (เทียบกับ Docker Desktop ที่ใช้ 300-500MB+)

### 🎉 ผลลัพธ์ที่ได้

✅ Docker Engine ทำงานโดยตรงบน WSL  
✅ ไม่ต้องใช้ Docker Desktop  
✅ ประหยัดทรัพยากรระบบมากขึ้น  
✅ Docker และ Docker Compose พร้อมใช้งาน  
✅ เริ่มอัตโนมัติทุกครั้งที่เปิด WSL  

---

**🎉 ยินดีด้วย! ตอนนี้คุณมี Docker ที่เร็วและเบาพร้อมใช้งานแล้ว!**

> **📚 อ่านเพิ่มเติม**: [Docker Documentation](https://docs.docker.com/) | [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

---

# การติดตั้งและใช้งาน Rust และ Node.js บน WSL

หลังจากการติดตั้ง Docker แล้ว คุณอาจต้องการติดตั้งภาษาโปรแกรมมิ่งและเครื่องมือสำหรับการพัฒนาโปรแกรมเพิ่มเติม นี่คือขั้นตอนการติดตั้ง Rust และ Node.js บน WSL:

## 📦 การติดตั้ง Node.js บน WSL

Node.js เป็น JavaScript runtime ที่ใช้สำหรับการพัฒนาแอปพลิเคชัน web, server-side และอื่นๆ

### วิธีที่ 1: การติดตั้งโดยใช้ NodeSource repository (แนะนำ)

```bash
# 1. เพิ่ม NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# 2. ติดตั้ง Node.js
sudo apt-get install -y nodejs
```

### วิธีที่ 2: การติดตั้งโดยใช้ NVM (Node Version Manager)

```bash
# 1. ดาวน์โหลดและติดตั้ง NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. โหลด NVM สู่ terminal session ปัจจุบัน
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 3. ติดตั้ง Node.js เวอร์ชันล่าสุด
nvm install node

# หรือติดตั้งเวอร์ชันเฉพาะ เช่น
# nvm install 20
```

### การตรวจสอบการติดตั้ง Node.js

```bash
# ตรวจสอบเวอร์ชัน Node.js
node --version
# v20.19.5 (หรือเวอร์ชันล่าสุด)

# ตรวจสอบเวอร์ชัน npm
npm --version
# 11.6.0 (หรือเวอร์ชันล่าสุด)
```

### การใช้งาน Node.js ทั่วไป

```bash
# สร้างโปรเจค Node.js ใหม่
mkdir my-node-project
cd my-node-project
npm init -y

# สร้างไฟล์ JavaScript ง่ายๆ
echo 'console.log("Hello from Node.js!");' > index.js

# รันโปรแกรม
node index.js
```

## 🦀 การติดตั้ง Rust บน WSL

Rust เป็นภาษาโปรแกรมมิ่งที่เน้นความปลอดภัยและประสิทธิภาพ เหมาะสำหรับการพัฒนาระบบ, CLI tools และแอปพลิเคชันที่ต้องการประสิทธิภาพสูง

### การติดตั้งโดยใช้ Rustup (เครื่องมือทางการ)

```bash
# 1. ดาวน์โหลดและรัน Rustup installer
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 2. เลือก "1) Proceed with standard installation" เมื่อถูกถาม
# หรือใช้ -y flag เพื่อข้ามการยืนยัน
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 3. โหลด Rust environment ในการ session ปัจจุบัน
source "$HOME/.cargo/env"
```

### การตั้งค่า Rust ให้พร้อมใช้งานในทุก session

```bash
# เพิ่มใน .bashrc หรือ .zshrc (ตามแต่ shell ที่คุณใช้)
echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
# หรือสำหรับ zsh
echo 'source "$HOME/.cargo/env"' >> ~/.zshrc
```

### การตรวจสอบการติดตั้ง Rust

```bash
# ตรวจสอบเวอร์ชัน Rust
rustc --version
# rustc 1.90.0 (หรือเวอร์ชันล่าสุด)

# ตรวจสอบเวอร์ชัน Cargo (Rust package manager)
cargo --version
# cargo 1.90.0 (หรือเวอร์ชันล่าสุด)
```

### การใช้งาน Rust ทั่วไป

```bash
# สร้างโปรเจค Rust ใหม่
cargo new my-rust-project
cd my-rust-project

# โปรเจคนี้จะมีโครงสร้างพื้นฐาน และโค้ด Hello World ที่พร้อมรัน

# คอมไพล์และรันโปรเจค
cargo run

# build สำหรับ production (optimized)
cargo build --release
```

## 🔄 การอัปเดต Rust และ Node.js

### อัปเดต Node.js

```bash
# หากติดตั้งผ่าน NodeSource:
sudo apt update
sudo apt upgrade nodejs -y

# หากติดตั้งผ่าน NVM:
nvm install --lts
nvm use --lts
```

### อัปเดต Rust

```bash
# อัปเดต Rustup และ components ทั้งหมด
rustup update
```

## 📚 แหล่งข้อมูลเพิ่มเติม

- Node.js: [Official Documentation](https://nodejs.org/docs)
- Rust: [The Rust Programming Language Book](https://doc.rust-lang.org/book/)
- npm: [npm Documentation](https://docs.npmjs.com/)
- Cargo: [The Cargo Book](https://doc.rust-lang.org/cargo/)

## 🔗 การใช้ Node.js และ Rust ร่วมกับ Docker

การใช้ Node.js และ Rust ร่วมกับ Docker ช่วยให้คุณสร้าง containers ที่มีสภาพแวดล้อมที่สอดคล้องกันสำหรับการพัฒนาและการ deploy

### Node.js กับ Docker

```bash
# ตัวอย่าง Dockerfile สำหรับ Node.js application
cat > Dockerfile << 'EOF'
FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["node", "index.js"]
EOF

# สร้าง image
docker build -t my-node-app .

# รัน container
docker run -p 3000:3000 my-node-app
```

### Rust กับ Docker

```bash
# ตัวอย่าง Dockerfile สำหรับ Rust application (multi-stage build)
cat > Dockerfile << 'EOF'
FROM rust:1.90 as builder

WORKDIR /usr/src/app
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
COPY --from=builder /usr/src/app/target/release/my-app /usr/local/bin/my-app

CMD ["my-app"]
EOF

# สร้าง image
docker build -t my-rust-app .

# รัน container
docker run my-rust-app
```

## 🚀 เทคนิคและคำแนะนำ

### สำหรับ Node.js

1. **ใช้ `.nvmrc`** - สร้างไฟล์ `.nvmrc` เพื่อกำหนดเวอร์ชัน Node.js ที่ใช้ในโปรเจค
2. **ใช้ `package-lock.json`** - ล็อคเวอร์ชันของ dependencies เพื่อความสอดคล้อง
3. **ติดตั้ง global packages** - `npm install -g <package>` สำหรับ CLI tools ที่ใช้บ่อย

### สำหรับ Rust

1. **ใช้ `rustfmt` และ `clippy`** - เครื่องมือพื้นฐานสำหรับ formatting และ linting
2. **ใช้ `cargo check`** - ตรวจสอบโค้ดเร็วกว่า `cargo build`
3. **ติดตั้ง binary crates** - `cargo install <crate>` สำหรับ CLI tools ที่เขียนด้วย Rust

---

เมื่อคุณติดตั้ง Docker, Node.js และ Rust บน WSL ตามขั้นตอนข้างต้น คุณจะมีสภาพแวดล้อมการพัฒนาที่สมบูรณ์พร้อมสำหรับการสร้างแอปพลิเคชันที่หลากหลาย!