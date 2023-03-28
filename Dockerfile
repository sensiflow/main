FROM squidfunk/mkdocs-material

COPY docs-requirements.txt /docs/requirements.txt

RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

COPY ../mkdocs.yml .