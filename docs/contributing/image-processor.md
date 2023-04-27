# Contributing to the image processor module

This section will help you start the development environment for the image processor module.

## Pre-requisites

- [Docker](https://docs.docker.com/get-docker/) needs to be installed on the machine where the module will be deployed, even if the module is not run within a Docker container. The Instance Manager communicates with the Docker daemon to manage Image Processor instances, which run within Docker containers.

- [Python 3.8 - 3.10](https://www.python.org/downloads/) needs to be installed on your environment.

- [Poetry](https://python-poetry.org/docs/) needs to be installed on the machine where the module will be deployed. Poetry is a Python tool for managing dependencies and creating reproducible builds. It simplifies the declaration and management of project dependencies, virtual environments, and packaging.

### Installing and running the required dependencies

Once all the pre-requisites are met, the following steps need to be followed:

1.  #### Clone the main repository and navigate to the `root` directory

    ```sh
    git clone https://github.com/sensiflow/main
    ```

    Followed by:

    ```sh
    cd main
    ```

    ```sh
    git clone https://github.com/sensiflow/image-processor
    ```

2.  #### Run the required services

    Before running the application, make sure you have all the services running. The following services are required:

    - [PostgreSQL Database](https://www.postgresql.org/download/)
    - [RabbitMQ Message Broker](https://www.rabbitmq.com/download.html)
    - [RTSP Server (MediaMTX)](https://github.com/aler9/media-mtx)

    ##### Using docker-compose

    If you are using Docker, the main repository contains a [docker-compose.yml](https://github.com/sensiflow/main/blob/main/docker-compose.yml) file that can be used to start all the required services with the recommended configurations and schemas without having to install them manually.

    To start the services using docker-compose, run the following command:

    ```sh
    docker compose up -d
    ```

    ##### Manually

    If you are not using Docker, you will need to install and run the services manually.

    ###### PostgreSQL Database

    To populate the database with the required tables and data you can use the [create_schema.sql](https://github.com/sensiflow/main/blob/main/sql/init/create_schema.sql) sql file in `sql/init/` folder.

    Run it in your database management tool of choice.

    ###### RabbitMQ Message Broker

    The RabbitMQ Message Broker does not require any additional configuration. The instance queue is created automatically when the application starts. You only have to provide the queue name and server information in the configuration file.

3.  #### Virtual environment

    4.  Navigate to the `image-processor` directory:

        ```sh
        cd image-processor
        ```

    5.  Activate the virtual environment:

        ```bash
        poetry shell
        ```

    6.  Install the dependencies:
        ```bash
        poetry install
        ```

4.  #### Create a branch for your changes

    ```sh
    git checkout -b <branch-name>
    ```

    !!! note "Branch naming convention"

        For now we are not enforcing any branch naming convention.

## Running the application

### Configuring the application

#### Environment variables

To run the application for development, set the `ENVIRONMENT` environment variable to `dev`:

=== "Linux, Windows Powershell or MacOS"

    ```bash
    export ENVIRONMENT=dev
    ```

=== "Windows CMD"

    ```bash
    set ENVIRONMENT=dev
    ```

#### Configuration file

The application can be configured using a configuration file.

The file follows the [INI](https://en.wikipedia.org/wiki/INI_file) format that contains the configuration parameters. The configuration file is located in the `configs` directory and is named `${ENVIRONMENT}.ini`.

You should create a `dev.ini` file in the `configs` folder to run the application.

```bash
├── image-processor
│   ├── configs
│   │   ├── dev.ini
```

The config file reference can be found [here](../getting-started/config-file-reference.md).

##### Example

Here's an example of a `dev.ini` file. This is the file that you should use if you ran the services using docker-compose.

```ini
[DATABASE]
URL=postgres://postgres:postgres@localhost:5432

[RABBITMQ]
HOST=localhost
PORT=5672
USER=guest
PASSWORD=guest
INSTANCE_QUEUE=instance_ctl

[HARDWARE_ACCELERATION]
PROCESSING_MODE=CPU
CUDA_VERSION=11.7 # Without PROCESSING_MODE=GPU, this is irrelevant

```

##### Application entry point

The application entry point is located in the `image_processor` directory and is named `run.py`.

```bash
├── image-processor
│   ├── run.py
```

To run it, use the following command in the same terminal where you activated the virtual environment and set the environment variables:

```bash
poetry run python run.py
```

## Running code checks

The code checks are run using [tox](https://tox.readthedocs.io/en/latest/).

Tox runs the following checks:

- Linter ([flake8](https://flake8.pycqa.org/en/latest/)) - a tool for enforcing style consistency across Python projects
- Tests ([pytest](https://docs.pytest.org/en/stable/)) - a testing framework for Python

To run the code checks, use the following command in the same terminal where you activated the virtual environment:

```bash
poetry run tox
```

!!! note "Run tox before committing"

    It is recommended to run tox before committing your changes to the repository.
    The ci will run tox on the branch on pull request, so it is better to run it locally
    and fix any issues before pushing your changes.

Tox will run the code checks for python versions `3.8`, `3.9` and `3.10`, which can be time consuming. When developing, we recommend running code checks separately for the python version you are using. We recommend running tox just before committing your changes.

## Running code checks separately

### Running tests

To run the tests, use the following command in the same terminal where you activated the virtual environment:

```bash
poetry run pytest
```

### Running the linter

To run the linter, use the following command in the same terminal where you activated the virtual environment:

```bash
poetry run flake8
```
