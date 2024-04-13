FROM ubuntu:22.04

RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    git \
    wget \
    unzip \
    cron \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /build && cp /etc/crontab /build

WORKDIR /build

ENTRYPOINT ["cat", "./crontab"]
