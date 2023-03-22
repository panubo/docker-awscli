FROM python:3.10.4-alpine3.15

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more \
  AWS_CLI_VERSION=1.27.96 \
  AWS_CLI_CHECKSUM=c8085a4701a63d99f44fcc2e8eab78a5264ee0a2705f4e0193317428dd5ede55

RUN set -x \
  && apk --update add --no-cache bash groff jq \
  ;

RUN set -x \
  && apk --update add --no-cache ca-certificates wget unzip \
  && cd /tmp \
  && wget -nv https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip -O /tmp/awscli-bundle-${AWS_CLI_VERSION}.zip \
  && echo "${AWS_CLI_CHECKSUM}  awscli-bundle-${AWS_CLI_VERSION}.zip" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum awscli-bundle-${AWS_CLI_VERSION}.zip)"; exit 1; )) \
  && unzip awscli-bundle-${AWS_CLI_VERSION}.zip \
  && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && apk del wget unzip \
  && rm -rf /tmp/* \
  ;

ENTRYPOINT ["/usr/local/bin/aws"]
