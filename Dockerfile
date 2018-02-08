FROM python:alpine

ENV PYTHONIOENCODING=UTF-8 PYTHONUNBUFFERED=0 PAGER=more

RUN apk --update add bash groff jq && \
    # Cleanup
    rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir awscli

ENTRYPOINT ["/usr/local/bin/aws"]
