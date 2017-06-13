FROM python:latest

ENV PYTHONIOENCODING=UTF-8 PYTHONUNBUFFERED=0

RUN apt-get update && \
    # Install Requirements
    apt-get install -y groff && \
    # Cleanup
    rm -rf /var/lib/apt/lists/*

RUN pip install awscli

ENTRYPOINT ["/usr/local/bin/aws"]
