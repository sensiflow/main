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

Before running the project, make sure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/), [JDK 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html) and [npm 9.1.1+](https://nodejs.org/en/download/) installed on your machine.

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

To run the instance manager and scheduler please refer to the [Image Processor installation guide](https://sensiflow.github.io/main/contributing/image-processor/).


### Use of SSL

The use of SSL is possible in the media server, API and nginx.

To use SSL, you must have a valid certificate and key file, and place them in the root directory folder.
These files must be named `server.crt` and `server.key` respectively.

#### API
To use SLL in the API a keystore file must be provided in the root directory folder, named `server.p12`.
Its password can be set as an environment variable `KEY_STORE_PASSWORD` in the `web-api` section present in the `docker-compose.yml` file.

After that, the `SECURE` environment variable must be set to `true` in the `web-api` section present in the `docker-compose.yml` file.

#### Media Server

On the media server config at `media-server-config/mediamtx.yml` change the encryption to `true` of the protocols you want to use SSL on.

#### Nginx

Two build arguments are available on the `nginx` section present in the `docker-compose.yml` file, `SECURE` and `API_SECURE`, which can be used to set whether the nginx server should use SSL, and whether the API should be accessed through SSL.