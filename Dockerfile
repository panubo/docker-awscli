FROM python:alpine

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more \
  AWS_CLI_VERSION=1.16.286 \
  AWS_CLI_CHECKSUM=7e99ea733b3d97b1fa178fab08b5d7802d0647ad514c14221513c03ce920ce83

RUN set -x \
  && apk --update add bash groff jq \
  && rm -rf /var/cache/apk/* \
  ;

RUN set -x \
  && apk add --no-cache ca-certificates wget unzip \
  && cd /tmp \
  && wget -nv https://s3.amazonaws.com/aws-cli/awscli-bundle-${AWS_CLI_VERSION}.zip -O /tmp/awscli-bundle-${AWS_CLI_VERSION}.zip \
  && echo "${AWS_CLI_CHECKSUM}  awscli-bundle-${AWS_CLI_VERSION}.zip" > /tmp/SHA256SUM \
  && sha256sum -c SHA256SUM \
  && unzip awscli-bundle-${AWS_CLI_VERSION}.zip \
  && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && apk del wget unzip \
  && rm -rf /tmp/* \
  ;

#RUN if [ "${AWSCLI_VERSION}" == "latest" ]; then pip install --no-cache-dir awscli; else pip install --no-cache-dir awscli==${AWSCLI_VERSION}; fi

ENTRYPOINT ["/usr/local/bin/aws"]
