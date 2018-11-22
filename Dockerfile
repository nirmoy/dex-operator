#
# Dockerfile for generating an official image
# (see Dockerfile.local if you want something
# faster for development)
#

FROM opensuse:tumbleweed as builder

RUN zypper in -y make git go1.11

ENV GOPATH="/go"
ENV GOBIN="/go/bin"
ENV PATH="/usr/bin:/bin:/usr/local/bin:/go/bin"

# Copy stuff to the image...
# (check the .dockerignore file for exclusions)
ADD . /go/src/github.com/kubic-project/dex-operator
WORKDIR /go/src/github.com/kubic-project/dex-operator

RUN make -C /go/src/github.com/kubic-project/dex-operator clean all

####################
# final stage
####################
FROM opensuse:tumbleweed

ARG BUILD_DIR="/go/src/github.com/kubic-project/dex-operator"
ARG BUILT_EXE="cmd/dex-operator/dex-operator"

COPY --from=builder $BUILD_DIR/$BUILT_EXE /usr/local/bin/dex-operator
RUN                 chmod 755 /usr/local/bin/dex-operator

CMD ["/usr/local/bin/dex-operator"]
