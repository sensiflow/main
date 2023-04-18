This section will walk you through the process of installing and configuring the Image Processor module of the Sensiflow's system. This module is responsible for processing the images captured by the camera and sending the results to the Sensiflow's system.

The module is composed of two parts:

- Instance Manager: This is the main component of the module. It is responsible for managing the instances of the Image Processor.

- Image Processor: This is the component that processes the images captured by the camera. It is responsible for detecting the objects in the image and sending the results to the Sensiflow's system.

## Technologies

The Instance Manager is developed in python and uses the following technologies:

- [pika](https://pika.readthedocs.io/en/stable/): Pika is a pure-Python implementation of the AMQP protocol that tries to stay fairly independent of the underlying network support library.

- [Docker SDK for Python](https://docker-py.readthedocs.io/en/stable/): The Docker SDK for Python is a library for working with the Docker Engine API.

- [psycopg](https://www.psycopg.org/): Psycopg is the most popular PostgreSQL database adapter for the Python programming language.

The Image Processor instance is developed in python and uses the following technologies:

- [OpenCV](https://opencv.org/): OpenCV is an open source computer vision and machine learning software library. It is used for image processing.

- [Pytorch](https://pytorch.org/): Pytorch is an open source machine learning framework. It is used for object detection.

## Pre-requisites

Prior to installation, the following prerequisites must be met:

- [Docker](https://docs.docker.com/get-docker/) needs to be installed on the machine where the module will be deployed, even if the module is not run within a Docker container. The Instance Manager communicates with the Docker daemon to manage Image Processor instances, which are implemented as Docker containers.

- [Poetry](https://python-poetry.org/docs/) needs to be installed on the machine where the module will be deployed. Poetry is a Python tool for managing dependencies and creating reproducible builds. It simplifies the declaration and management of project dependencies, virtual environments, and packaging.

## Installation

You can install the Image Processor module in two ways:

- [Using Docker](#using-docker)

- [Manually](#manually)

For a reliable and streamlined installation, it is recommended to use Docker to install the Image Processor module. Docker automatically handles dependencies, ensuring correct versions are installed. Manual installation may require manual dependency management, which can be error-prone.

### Manually
