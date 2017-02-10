FROM buildpack-deps:jessie

MAINTAINER Pijus Navickas <pijus.navickas@gmail.com>

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

# Set up Docker.
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_DOWNLOAD_URL https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz
ENV DOCKER_DOWNLOAD_SHA256 97892375e756fd29a304bd8cd9ffb256c2e7c8fd759e12a55a6336e15100ad75
RUN set -x \
	&& curl -fSL "${DOCKER_DOWNLOAD_URL}" -o docker.tgz \
	&& echo "${DOCKER_DOWNLOAD_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz


# Set up Golang.
ENV GOLANG_VERSION 1.7.5
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 2e4dd6c44f0693bef4e7b46cc701513d74c3cc44f2419bf519d7868b12931ac3

RUN curl -fsSL "${GOLANG_DOWNLOAD_URL}" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/local/go/bin:${PATH}

RUN mkdir -p "${GOPATH}/src" "${GOPATH}/bin" && chmod -R 777 "${GOPATH}"
WORKDIR ${GOPATH}

# Set up entry point.
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
CMD ["sh"]
