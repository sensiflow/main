# Sensiflow Main Repository

This repository contains the documentation and configuration files for the Sensiflow system and respective services.

## Repository Structure

The repository is structured as follows:

- `docs/`: Contains the documentation for the Sensiflow system.
- `docker/`: Contains the Dockerfiles for the Sensiflow services.
- `project-docs/`: Contains the reports and presentation files for the Sensiflow project.
- `rabbit-init`: Contains the RabbitMQ configuration files.
- `sql`: Contains the SQL scripts for the postgres database.

## Run project from this repository

Before running the project, make sure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/), [JDK 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html) and [Node.js 9.1.1+](https://nodejs.org/en/download/) installed on your machine.

The first step is to clone this repository:

```bash
git clone https://github.com/sensiflow/main.git
```

Next, navigate to the root of the repository:

```bash
cd main
```

Finally, run the following command to install the project

Linux/MaxOS/Wsl:

```bash
./install.sh
```

Windows:

```bash
./install.bat
```

To run the web application, run the following command:

```bash
docker-compose up --build -d
```

To run the instance manager and scheduler please refer to the [Image Processor installation guide](https://docs.sensiflow.org/contributing/image-processor).
