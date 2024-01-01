FROM python:3.12-alpine3.19

ENV \
  PYTHONIOENCODING=UTF-8 \
  PYTHONUNBUFFERED=0 \
  PAGER=more

RUN set -x \
  && apk --update add --no-cache bash groff jq \
  ;

RUN set -x \
  && apk --update add --no-cache ca-certificates wget unzip \
  && cd /tmp \
  && AWS_CLI_VERSION=2.15.5 \
  && AWS_CLI_CHECKSUM_X86_64=c2758413f86f4e9cd729a8cc2d2f60b590b22e1935c42809d115e616a276d50c \
  && AWS_CLI_CHECKSUM_AARCH64=f460619647d9f233f7f3b8414ef2f89d06b2edd588fe9de6ca1f974d1756cbae \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        AWS_CLI_CHECKSUM="${AWS_CLI_CHECKSUM_X86_64}"; \
        AWS_CLI_ARCH="x86_64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        AWS_CLI_CHECKSUM="${AWS_CLI_CHECKSUM_AARCH64}"; \
        AWS_CLI_ARCH="aarch64"; \
      fi \
  && wget -nv https://awscli.amazonaws.com/awscli-exe-linux-${AWS_CLI_ARCH}-${AWS_CLI_VERSION}.zip -O /tmp/awscliv2.zip \
  && printf '%s  %s\n' "${AWS_CLI_CHECKSUM}" "awscliv2.zip" > /tmp/SHA256SUM \
  && (cd /tmp && sha256sum -c SHA256SUM || (echo "Expected $(sha256sum awscliv2.zip)"; exit 1; )) \
  && unzip /tmp/awscliv2.zip \
  && /tmp/aws/install \
  && apk del wget unzip \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  ;

ENTRYPOINT ["/usr/local/bin/aws"]