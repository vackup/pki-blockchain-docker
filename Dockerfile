#Based on https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324

############################
# STEP 1 build executable binary
############################

FROM golang:1.12-alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update 
RUN apk add --no-cache git gcc musl-dev curl

#RUN add-apt-repository -y ppa:ethereum/ethereum


WORKDIR $GOPATH/src/app
COPY . .
# install glide
RUN curl https://glide.sh/get | sh

RUN glide install

# Fetch dependencies.
# Using go get.
#RUN go get -d -v

#RUN ./vendor/github.com/ethereum/go-ethereum/cmd/abigen --abi ./scontract/abi/pki_abi.json --pkg main --type LuxUni_PKI --out bind_pki.go --bin ./scontract/bin/pki_scont.bin
#RUN ./vendor/github.com/ethereum/go-ethereum/cmd/abigen --abi ./scontract/abi/pki_abi_web.json --pkg main --type LuxUni_PKI_web --out bind_pki_web.go
#RUN ./vendor/github.com/ethereum/go-ethereum/cmd/abigen --abi ./scontract/abi/pki_abi_valid.json --pkg main --type LuxUni_PKI_valid --out bind_pki_valid.go

# Build the binary.
#RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/pki-rest
RUN GOOS=linux GOARCH=amd64 go build pki-rest.go bind_pki.go pki_conf.go
RUN GOOS=linux GOARCH=amd64 go build pki-web.go bind_pki.go bind_pki_web.go pki_conf.go

#CMD ["go", "run", "pki-web.go"]

############################
# STEP 2 build a small image pki-rest
############################
#FROM scratch

# Copy our static executable.
#COPY --from=builder /go/src/app/pki-rest /go/bin/
#COPY --from=builder /go/src/app/config/pki-conf.json /go/bin/config/
#COPY --from=builder /go/src/app/pki-rest /go/bin/pki-rest

# Run the app binary.
#ENTRYPOINT ["./pki-rest"]
#ENTRYPOINT ["/go/bin/pki-web"]

############################
# STEP 3 build a small image pki-web
############################
#FROM scratch

# Copy our static executable.
#COPY --from=builder /go/src/app/pki-web /go/bin/pki-web

# Run the app binary.
#ENTRYPOINT ["/go/bin/pki-web"]