# Linux Monitoring Agent Project

## Introduction

This project is a lightweight system monitoring solution designed to collect, store, and analyze basic hardware and resource usage information from multiple Linux machines. Each host runs a small monitoring agent that records system details such as CPU configuration and memory capacity, along with ongoing usage metrics like free memory, CPU activity, and disk availability. All collected data is sent to a centralized PostgreSQL database, making it easy to review system performance over time and compare different machines.

The project demonstrates how common DevOps tools and practices—such as Bash scripting, Docker, Git, Linux utilities, and SQL—can be combined to build a simple yet practical monitoring platform.

---

## Quick Start

```bash
# 1. Start PostgreSQL using Docker
./scripts/psql_docker.sh create postgres password

# 2. Create database tables
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# 3. Register this host (run once per machine)
./scripts/host_info.sh localhost 5432 host_agent postgres password

# 4. Collect usage data (manual test)
./scripts/host_usage.sh localhost 5432 host_agent postgres password

# 5. Automate usage collection every minute
crontab -e
# Add the following line:
* * * * * /bin/bash /home/rocky/jarvis_data_eng_JobyChacko/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password >> /tmp/host_usage.log 2>&1
```

---

## Implementation

This project follows a simple agent-based design. Each Linux host runs two Bash scripts: one that registers the machine’s hardware information in the database, and another that periodically captures system usage data. A central PostgreSQL database, running inside a Docker container, stores all collected information. Automation is handled using `cron`, which schedules the usage script to run at fixed time intervals.

### Architecture

The system consists of multiple Linux hosts connected to a single PostgreSQL database. Each host runs a monitoring agent that sends data to the database.

<img width="676" height="581" alt="image" src="https://github.com/user-attachments/assets/560fd285-384e-4faa-bf2e-dd3fe8a1282f" />

```
### Scripts
psql_docker.sh and host_info.sh manages the PostgreSQL database using Docker. It can create, start, and stop the database container.

```bash
./scripts/psql_docker.sh create psql_user psql_password
./scripts/psql_docker.sh start
./scripts/psql_docker.sh stop
```
---

### host_info.sh

Collects static hardware information from the host, such as CPU details and total memory, and inserts it into the `host_info` table.

```bash
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
```

---

### host_usage.sh

Collects runtime system usage data, including free memory, CPU activity, and disk availability, and inserts it into the `host_usage` table.

```bash
./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

---

### Crontab

Schedules the `host_usage.sh` script to run automatically every minute, enabling continuous monitoring without manual intervention.

```bash
* * * * * /bin/bash /home/rocky/jarvis_data_eng_JobyChacko/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password >> /tmp/host_usage.log 2>&1
```

---

### queries.sql

Contains analytical SQL queries used to answer business-style questions, such as:
- Grouping hosts by hardware configuration to compare system capacity.
- Calculating average memory usage over fixed time intervals to identify performance trends and potential resource bottlenecks.

---

## Database Modeling

### host_info

| Column | Description |
|--------|-------------|
| id | Unique identifier for each host |
| hostname | Fully qualified host name |
| cpu_number | Number of CPU cores |
| cpu_architecture | CPU architecture type (e.g., x86_64) |
| cpu_model | CPU model name |
| cpu_mhz | CPU speed in MHz |
| l2_cache | L2 cache size |
| timestamp | Time when the host was registered |
| total_mem | Total system memory |

---

### host_usage

| Column | Description |
|--------|-------------|
| timestamp | Time when the usage data was collected |
| host_id | Reference to the host in `host_info` |
| memory_free | Amount of free memory |
| cpu_idle | CPU idle percentage |
| cpu_kernel | CPU usage by the system |
| disk_io | Disk input/output activity |
| disk_available | Available disk space |

---

## Test

The project was tested by running each script manually and verifying that records were successfully inserted into the database using `SELECT` queries. The database schema was validated by executing the DDL script and confirming that all required tables and constraints were created correctly. The cron job was tested by waiting several minutes and checking the database to ensure that new usage records appeared automatically over time.

---

## Deployment

The source code is version-controlled using Git and hosted on GitHub. PostgreSQL is deployed as a Docker container to ensure a consistent and portable database environment. Each Linux host runs the monitoring scripts locally, and `cron` is used to automate periodic data collection.

---

## Improvements

- Add a web-based dashboard to visualize system performance trends using charts and graphs.
- Secure database credentials by using environment variables or a secrets manager instead of passing them as command-line arguments.
- Enhance the agent to detect hardware changes and automatically update host records in the database.
