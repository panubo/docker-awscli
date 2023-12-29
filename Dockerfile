FROM python:3.10-alpine3.19

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more \
  AWS_CLI_VERSION=1.32.10 \
  AWS_CLI_CHECKSUM=f6a1ff64f7a4162eead497c112ba3c1842506da014621f4f599fe60ccb68ec86

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
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  ;

ENTRYPOINT ["/usr/local/bin/aws"]
