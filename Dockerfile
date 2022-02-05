FROM       arm64v8/debian

LABEL   os="ubuntu 8" \
        container.description="ubuntu with tini" \
        version="0.19.0" \
        maintainer="devops <devops@aem.design>" \
        imagename="tini" \
        test.command=" tini --version | sed -e 's/.*version \(.*\) -.*/\1/'" \
        test.command.verify="0.19.0"

ARG TINI_VERSION="v0.19.0"
ARG TINI_KEY="595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7"
ARG TINI_URL="https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64"
ARG GPG_KEYS="595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7"

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        wget \
        && \
    curl -fsSL ${TINI_URL} -o /bin/tini && \
    curl -fsSL ${TINI_URL}.asc -o /bin/tini.asc && \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${TINI_KEY} && \
    gpg --batch --verify /bin/tini.asc /bin/tini && \
    chmod +x /bin/tini

ENTRYPOINT ["/bin/tini", "--"]
