# Contributing to the image processor module

This section will help you start the development environment for the image processor module.

## Module overview and definitions

The image-processor module is the module responsible for managing worker instances that detect objects in the device's video stream and write the collected insights to the database.

The module is composed of the following components:

- **Instance Manager** - The Instance Manager is responsible for managing the image processor workers. It communicates with the API to receive commands to start, stop, and delete instances. It is a consumer of the `Instance Controller Queue` from the message broker to receive _device status updates_ and _device delete requests_ from the `API`. It also publishes messages to acknowledge device status updates and device delete requests using the `ACK Device Status Queue` and `ACK Device Delete Queue` respectively.

- **Image Processor Worker** - The Image Processor Worker is responsible for processing the video stream and writing the metrics to the database. There is one worker running for each device with the `ACTIVE` status. This is the only statement that we guarantee. However, there can be less workers than devices with the stopped or paused status, because the [scheduler](#instance-manager-scheduler) might have stopped or deleted some instances to free up resources. The worker runs in a _Docker_ container and runs machine learning inferences to detect objects in the video stream. The insights are then written to the metrics database.

- **Instance Manager Scheduler** - This scheduler checks for long paused instances and stops them. It also checks for long stopped instances and deletes them. The scheduler is an optional component that was built to recover from unexpected errors that might occur in the `Instance Manager` and to clean up some instances that might have been left in a paused or stopped state, to free up resources automatically.

## Pre-requisites

- [Docker](https://docs.docker.com/get-docker/) needs to be installed on the machine where the module will be developed, even if the module is not run within a _Docker_ container, the Instance Manager communicates with the _Docker_ daemon to manage Image Processor instances, which run within Docker containers.

- [Python 3.8 - 3.10](https://www.python.org/downloads/) needs to be installed on your environment.

- [Poetry](https://python-poetry.org/docs/) needs to be installed on your machine. Poetry is a Python tool for managing dependencies and creating reproducible builds. It simplifies the declaration and management of project dependencies, virtual environments, and packaging.

### Installing and running the required dependencies

Once all the pre-requisites are met, the following steps need to be followed:

1.  #### Clone the main repository and navigate to the `root` directory

    ```sh
    git clone https://github.com/sensiflow/main
    ```

    ```sh
    cd main
    ```

    Followed by cloning the image-processor module:

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

    The RabbitMQ Message Broker needs 3 queues to be created:

    1. A controller queue that sends control messages to the Instance Manager

    - An acknowledge queue for the Instance Manager to send acknowledgements to the API about changing the state of an instance
    - An acknowledge queue for the Instance Manager to send acknowledgements to the API about deleting an instance

    The configuration files of the rabbitmq broker are in the [rabbit-init](https://github.com/sensiflow/main/blob/main/rabbit-init) folder.

    Otherwise you'll have to create them manually using a rabbitmq management tool.

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

The application is configured by environment variables and a configuration file.

#### Environment variables

The `ENVIRONMENT` environment variable is used to determine which configuration file to use. The configuration file is located in the `configs` directory and is named `${ENVIRONMENT}.ini`.

The file follows the [INI](https://en.wikipedia.org/wiki/INI_file) format.

The amount of configuration files is not limited to the ones that are already there. You can create as many as you want and name them as you wish. The only requirement is that the name of the file should match the value of the `ENVIRONMENT` environment variable when running the application.

##### Restricted profiles

The only **restricted** values for the `ENVIRONMENT` environment variable are:

- **prod** - used for the production environment
- **ci** - used for the continuous integration environment
- **test** - used for the testing environment

#### Example

Here's an example running the application by using a `dev` profile:

First let's set the `ENVIRONMENT` environment variable to `dev`:

=== "Linux, Windows Powershell or MacOS"

    ```bash
    export ENVIRONMENT=dev
    ```

=== "Windows CMD"

    ```bash
    set ENVIRONMENT=dev
    ```

Because you set the `ENVIRONMENT` environment variable to `dev`, you should create a `dev.ini` file in the `configs` folder to run the application.

```bash
├── main
│   ├── image-processor
│   │   ├── configs
│   │   │   ├── dev.ini
```

The config file reference can be found [here](../getting-started/config-file-reference.md).

##### Configuration File Example

Here's an example of a `dev.ini` file. This is the file that you should use if you ran the services using `docker compose`.

```ini
[DATABASE]
URL=postgres://postgres:postgres@localhost:5432

[RABBITMQ]
HOST=localhost
PORT=5672
USER=guest
PASSWORD=guest
INSTANCE_CONTROLLER_QUEUE=instance_ctl
ACK_DEVICE_STATUS_QUEUE=instance_ack_device_state
ACK_DEVICE_DELETE_QUEUE=instance_ack_device_delete

[HARDWARE_ACCELERATION]
PROCESSING_MODE=CPU
CUDA_VERSION=11.7 # Without PROCESSING_MODE=GPU, this is irrelevant
```

##### Application entry point

The application entry point is located in the `image_processor` directory and is named `run.py`.

```bash
├── main
│   ├── image-processor
│   │   ├── run.py
```

To run it, use the following command in the same terminal where you activated the virtual environment and set the environment variables:

```bash
poetry run python run.py
```

Run the scheduler in a separate process:

```bash
poetry run python scheduler.py
```

#### Scalability

The application is designed to be scalable. You can run multiple instances of the instance manager application.

The same doesn't apply to the scheduler. The scheduler is designed to run only one instance. Running multiple instances of the scheduler is a waster of resources and can cause unexpected behavior (improbable, but possible).

## Running code checks separately

### Running tests

#### Requirements

To run the integration tests you need to have the following services running:

- [PostgreSQL Database](https://www.postgresql.org/download/)
- [RabbitMQ Message Broker](https://www.rabbitmq.com/download.html)
- [Docker Engine](https://docs.docker.com/engine/install/)

#### Test configuration

The tests can be configured by the `test` profile. Because the tests use the `ENVIRONMENT=test` environment variable, you should create a `test.ini` file in the `configs` folder to run the tests. with the required services running.

Of course if you have docker installed, you can run the services using `docker compose` with the `docker-compose.test.yml` file in the root directory, this file serves both to the image-processor and api tests.

With the test services running use the following command in the same terminal where you activated the virtual environment:

```bash
poetry run pytest
```

### Running the linter

To run the linter, use the following command in the same terminal where you activated the virtual environment:

```bash
poetry run flake8
```

## Running code checks

The code checks use [tox](https://tox.readthedocs.io/en/latest/).

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

Tox will run the code checks for python versions `3.8`, `3.9` and `3.10`. When developing, we recommend running code checks separately for the python version you are using. We recommend running tox just before committing your changes since it takes a significant amount of time to run.
