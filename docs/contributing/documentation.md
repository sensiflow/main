# Contributing to the documentation

This section will help you start writing documentation for our project.

!!! note "**Context directory**"
    
    The following instructions assume you are in the root directory of the project.

## Using pip

!!! warning "Python 3.7 or higher required"
    These instructions assume you have Python 3.7 or higher and pip installed. If you don't have Python installed, you can download it from the [Python website](https://www.python.org/downloads/).

If you don't want to install python, you should consider using [docker](#using-docker) to run the development server.

To install all documentation required dependencies:

```sh
pip install -r requirements.txt
```

Start the live-reload development server:
```sh
mkdocs serve
```

You're [done!](#done)

## Using Docker

Assuming you have Docker installed, you can use the provided Dockerfile to build a Docker image that will run the MkDocs development server with all the required dependencies.

### Build the Docker image

To build the documentation Docker image:

    docker build -t sensiflow-docs .

### Run a container from the image

=== "Linux or Windows Powershell"
    
    ```sh
    docker run -it --rm -p 8000:8000 -v ${PWD}:/docs sensiflow-docs
    ```

=== "Windows CMD"

    ```sh
    docker run --rm -it -p 8000:8000 -v %cd%:/docs sensiflow-docs   
    ```
        
        

## Done!

You should have a live-reloading development server running at [http://localhost:8000](http://localhost:8000).

Writing anything in the docs folder will automatically trigger a rebuild of the site.

