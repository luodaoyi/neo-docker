FROM ubuntu:16.04
MAINTAINER Jonatan <jonatan.blockchain@gmail.com>

ENV DOTNET_SDK_VERSION 2.0.0
ENV DOTNET_SDK_RELEASE dotnet-sdk-2.0.0-linux-x64.tar.gz
ENV DOTNET_SDK_DOWNLOAD_URL https://download.microsoft.com/download/1/B/4/1B4DE605-8378-47A5-B01B-2C79D6C55519/$DOTNET_SDK_RELEASE
ENV PATH="/opt/dotnet:${PATH}"

ENV NEOCLI_VERSION 2.7.6.1
ENV NEOCLI_SHA256 F93F74C5C4870856811CC2B717F2E554B4DE4880166DBF3F37AA640369E520C5
ENV NEOCLI_RELEASE neo-cli-linux-x64.zip
ENV NEOCLI_DOWNLOAD_URL https://github.com/neo-project/neo-cli/releases/download/v$NEOCLI_VERSION/$NEOCLI_RELEASE

RUN apt-get update && \
    apt-get -y install unzip dialog curl apt-transport-https ca-certificates && \
    apt-get -y install --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu-dev \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
        && \
    apt-get -y install libleveldb-dev libleveldb1v5 && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/*

RUN curl -sSL --output dotnet.tar.gz $DOTNET_SDK_DOWNLOAD_URL \
    && mkdir -p /opt/dotnet && tar zxf dotnet.tar.gz -C /opt/dotnet \
    && rm -rf dotnet.tar.gz

RUN curl -sSL --output neo-cli-ubuntu.zip $NEOCLI_DOWNLOAD_URL \
    && echo "$NEOCLI_SHA256 *neo-cli-ubuntu.zip" | sha256sum -c - \
    && unzip neo-cli-ubuntu.zip -d /opt/ \
    && rm -rf neo-cli-ubuntu.zip

EXPOSE 10333
WORKDIR /opt/neo-cli
ENTRYPOINT [ "dotnet", "neo-cli.dll" ]
