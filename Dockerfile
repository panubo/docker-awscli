FROM python:3.8-alpine3.10

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more \
  AWS_CLI_VERSION=1.18.155 \
  AWS_CLI_CHECKSUM=b18f2b90ee3715b500d840bac0aeeff5fcc0e215454fce638b7f6a4cb87d3a05

RUN set -x \
  && apk --update add --no-cache bash groff jq \
  ;

RUN set -x \
  && apk --update add --no-cache ca-certificates wget unzip \
  && cd /tmp \
  && wget -nv https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip -O /tmp/awscli-bundle-${AWS_CLI_VERSION}.zip \
  && echo "${AWS_CLI_CHECKSUM}  awscli-bundle-${AWS_CLI_VERSION}.zip" > /tmp/SHA256SUM \
  && sha256sum -c SHA256SUM \
  && unzip awscli-bundle-${AWS_CLI_VERSION}.zip \
  && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && apk del wget unzip \
  && rm -rf /tmp/* \
  ;

ENTRYPOINT ["/usr/local/bin/aws"]
