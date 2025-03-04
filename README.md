# pgconf-Lab-2025

## Name
Lab for __PGConf 2025 Training - Database Schema Changes With Minimal/No-Downtime__

# Pre-Req needs to be followed by participante
1. Docker service should be installed in your laptop/Desktop
2. Follow the steps from below links
    1. Ubuntu: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
    2. Windows: [https://docs.docker.com/desktop/install/windows-install/](https://docs.docker.com/desktop/install/windows-install/)
    3. Mac : [https://docs.docker.com/desktop/install/mac-install/](https://docs.docker.com/desktop/install/mac-install/)

## Description

>The Dockerized lab setup with Postgres 16 with replications setup.The container has pre built with below list of extensive tools :

* [PostgreSQL v16](https://www.postgresql.org/docs/16/index.html)
* [pgroll](https://github.com/xataio/pgroll)
* [pg-osc](https://github.com/shayonj/pg-osc)
* Sample Schema and usecases files present in location ```/var/lib/scripts/```


# Usage and steps to deploy container

## Change to DOCKER directory
```
git clone https://github.com/RajeshMadiwale/pgconf-2025-lab.git
cd  pgconf-2025-lab/pgconf-docker-2025
```
### Build Postgres container image 

```
docker build -t pgconf/pgdatabase:latest -f dockerfile-postgres .

```

### Launch and create container using docker compose 

#### Start pgconf container and initialize with sample schema 


```
docker-compose up -d postgres_pgconf
```

<!-- Adding Blockquote --> 
> $`\textcolor{red}{\text{IMPORTANT}}`$ After you start the pgconf container, it will take atleast 2 minutes to create the cluster.
You can check the progress using below command 

```
docker-compose logs  postgres_pgconf

```
<!-- Adding Blockquote --> 
> $`\textcolor{orange}{\text{NOTE}}`$ The logs should show something like below 
```

postgres_pgconf  | 2025-02-17 16:02:02 UTC [1]: [1-1] user=,db=,app=,client= LOG:  redirecting log output to logging collector process
postgres_pgconf  | 2025-02-17 16:02:02 UTC [1]: [2-1] user=,db=,app=,client= HINT:  Future log output will appear in directory "log".

```

### Verify all files and Connect to pgconf database

```
docker exec -it postgres_pgconf  bash

```

```
sudo su - postgres
ls -lrth /var/lib/scripts/
```

```
postgres@54d3b64b453e:/var/lib/scripts$ ls -lrth
-rw-r--r-- 1 postgres postgres  171 Feb 17 13:36 03_rename_table.json
-rw-r--r-- 1 postgres postgres  230 Feb 17 13:36 02_change_column_type.json
-rw-r--r-- 1 postgres postgres  428 Feb 17 13:36 01_add_column_to_users.json
-rw-rw-r-- 1 postgres postgres 2.2K Feb 17 14:19 sample_sql.sql
-rw-r--r-- 0 postgres postgres  227 Feb 17 14:20 pg-osc.txt

```

Create tables in the pgconf database

```
psql -d pgconf -f /var/lib/scripts/sample_sql.sql
```

```
psql -d pgconf 
```

```
pgconf=# \dt
            List of relations
 Schema |    Name     | Type  |  Owner   
--------+-------------+-------+----------
 public | customers   | table | postgres
 public | order_items | table | postgres
 public | orders      | table | postgres
 public | products    | table | postgres
 public | users       | table | postgres
(5 rows)

```

## Usecases for pgroll and pg-osc

### pgroll

```
cd /var/lib/scripts

```

__First initialize pgroll__

```
pgroll init --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable
```

__Case-1 : Add columns to existing table__

```
pgroll start --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 01_add_column_to_users.json
pgroll complete --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 01_add_column_to_users.json
```
__Case-2 : Column datatype change__

```
pgroll start --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 02_change_column_type.json
pgroll complete --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 02_change_column_type.json
```

__Case-3 : Rename existing table__

```
pgroll start --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 03_rename_table.json
pgroll complete --postgres-url postgres://postgres:password@localhost:5432/pgconf?sslmode=disable 03_rename_table.json

```

### pg-osc


__Case-1 : Add multiple columns to table__

```
export PGPASSWORD=<enter password>

pg-online-schema-change perform --alter-statement 'ALTER TABLE school ADD COLUMN "school_address" varchar(100); ALTER TABLE school ADD COLUMN "school_email" varchar(20);' --dbname "pgconf" --host "localhost" --username "postgres" --drop

```

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

1. __Rajesh.M__
2. __HariKrishna.B__

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
