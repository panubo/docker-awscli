FROM python:alpine

ARG AWSCLI_VERSION

ENV PYTHONIOENCODING=UTF-8 PYTHONUNBUFFERED=0 PAGER=more

RUN apk --update add bash groff jq && \
    # Cleanup
    rm -rf /var/cache/apk/*

RUN if [ "${AWSCLI_VERSION}" == "latest" ]; then pip install --no-cache-dir awscli; else pip install --no-cache-dir awscli==${AWSCLI_VERSION}; fi

ENTRYPOINT ["/usr/local/bin/aws"]
