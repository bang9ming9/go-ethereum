# Support setting various labels on the final image
ARG COMMIT=""
ARG VERSION=""
ARG BUILDNUM=""

# Build Geth in a stock Go builder container
FROM golang:1.22-alpine3.20 as builder

RUN apk add --no-cache gcc musl-dev linux-headers git ca-certificates openssl

# Define the location for custom certificates
ARG cert_location=/usr/local/share/ca-certificates

# Fetch and install certificates for github.com and proxy.golang.org
RUN openssl s_client -showcerts -connect github.com:443 </dev/null 2>/dev/null | \
    openssl x509 -outform PEM > ${cert_location}/github.crt && \
    update-ca-certificates
RUN openssl s_client -showcerts -connect proxy.golang.org:443 </dev/null 2>/dev/null | \
    openssl x509 -outform PEM > ${cert_location}/proxy.golang.crt && \
    update-ca-certificates

WORKDIR /go-ethereum
# Get dependencies - will also be cached if we won't change go.mod/go.sum
COPY go.mod go.sum ./
RUN go mod download

ADD . .
RUN go run build/ci.go install -static ./cmd/geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:3.20

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth"]

# Add some metadata labels to help programmatic image consumption
ARG COMMIT=""
ARG VERSION=""
ARG BUILDNUM=""

LABEL commit="$COMMIT" version="$VERSION" buildnum="$BUILDNUM"
