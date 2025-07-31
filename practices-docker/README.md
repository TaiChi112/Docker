- สมมติมี docker-compose.yml เเล้วต่อไปเราจะทำการ 

```sh
docker compose up -d
```

- ต่อไป check ว่า container ของเราทำงานอยู่หรือไม่

```sh
docker ps
```

- สมมติเราใช้ docker image ที่เป็น database เช่น psql , mysql หรือ mongo เราสามารถเข้าไปที่ container ได้ด้วยคำสั่ง

```sh
docker exec -it <container_name> sh
```

- ตอนนี้เราควรจะอยู่ใน shell ของ container แล้ว สามารถใช้ CLI ได้ปกติเช่น

```sh
ls
cat 
touch
mkdir
```

- เเต่ถ้าต้องการเข้าไปที่ database server เช่น psql หรือ mysql เราสามารถใช้คำสั่งดังนี้

```sh
psql -U <username> -d <database_name>
```
หรือ

```sh
mysql -u <username> -p
```

- ซึ่ง username และ database_name จะขึ้นอยู่กับการตั้งค่าของ docker-compose.yml ของเรา หรือไม่ใช่ก็จะอยู่ใน .env file ที่เราใช้ในการตั้งค่า environment 

- มาถึงจุดนี้เราควรจะอยู่ใน database server ตาม database ที่เราใช้ จุดนี้เราสามารถใช้คำสั่ง SQL ได้ตามปกติ เช่น

```sql
SELECT * FROM <table_name>;
INSERT INTO <table_name> (column1, column2) VALUES (value1, value2);
UPDATE <table_name> SET column1 = value1 WHERE condition;
DELETE FROM <table_name> WHERE condition;
```

- หรืออื่นๆ ตามที่เราต้องการทำงานกับ database ของเรา