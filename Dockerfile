FROM python:latest

ENV PYTHONIOENCODING=UTF-8 PYTHONUNBUFFERED=0

RUN pip install awscli

ENTRYPOINT ["/usr/local/bin/aws"]
