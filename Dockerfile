# go mod init gitub.com/joescharf/testapp
# **** BUILD STAGE ****

FROM golang:1.13-buster as builder
ARG version="1.0.3" 
WORKDIR /app

# process wrapper
RUN go get -v github.com/abiosoft/parent

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .


# **** PROD STAGE ****
FROM alpine:latest 
RUN apk --no-cache add ca-certificates git tzdata

ARG version="1.0.3" 
LABEL caddy_version="$version"

ENV ACME_AGREE="true"

# Copy the executable
COPY --from=builder /app/app /usr/bin/caddy
# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY index.html .

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]