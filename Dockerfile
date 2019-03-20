#Based on https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324

############################
# STEP 1 build executable binary
############################

FROM golang:1.12-alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update 
RUN apk add --no-cache git gcc musl-dev curl

#Copy app
WORKDIR $GOPATH/src/app
COPY . .

RUN chmod +x entrypoint.sh

# install glide
RUN curl https://glide.sh/get | sh

RUN glide install

# Build the binary.
RUN GOOS=linux GOARCH=amd64 go build pki-rest.go bind_pki.go pki_conf.go

ENTRYPOINT ["./entrypoint.sh"]