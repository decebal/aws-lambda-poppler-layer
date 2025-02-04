FROM amazonlinux:latest

ENV SOURCE_DIR="/opt/jeylabs"
ENV INSTALL_DIR="/opt"

ENV PATH="/opt/bin:${PATH}" \
    LD_LIBRARY_PATH="${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib"

# Install zip

RUN set -xe; \
    LD_LIBRARY_PATH= yum -y install zip

# Copy All Binaries / Libaries

RUN set -xe; \
    mkdir -p ${INSTALL_DIR}

COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR} ${INSTALL_DIR}

# Test file

RUN set -xe; \
    mkdir -p /tmp/test

WORKDIR /tmp/test

RUN set -xe; \
    curl -Ls https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf --output sample.pdf

RUN set -xe; \
    /opt/bin/pdftoppm -png sample.pdf sample

RUN set -xe; \
    test -f /tmp/test/sample-1.png
