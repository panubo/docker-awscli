FROM python:3.8-alpine3.10

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more \
  AWS_CLI_VERSION=1.18.93 \
  AWS_CLI_CHECKSUM=37eaa4d25cb1b9786af4ab6858cce7dfca154d264554934690d99994a7bbd7a5

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
