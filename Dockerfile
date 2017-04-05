FROM buildpack-deps:jessie

MAINTAINER Pijus Navickas <pijus.navickas@gmail.com>

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

# Set up Docker.
ENV DOCKER_VERSION 17.04.0-ce-rc2
ENV DOCKER_DOWNLOAD_URL https://test.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz
ENV DOCKER_DOWNLOAD_SHA256 64653090833c16e47426ada7dd85bec91d78e65beacd558e3b75ba4950e7be79
RUN set -x \
	&& curl -fSL "${DOCKER_DOWNLOAD_URL}" -o docker.tgz \
	&& echo "${DOCKER_DOWNLOAD_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz


# Set up Golang.
ENV GOLANG_VERSION 1.8
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca

RUN curl -fSL "${GOLANG_DOWNLOAD_URL}" -o golang.tar.gz \
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
