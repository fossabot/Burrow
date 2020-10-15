# stage 1: builder
FROM golang:1.15.2-alpine as builder

ENV BURROW_SRC /usr/src/Burrow/

RUN apk add --no-cache git curl
COPY . $BURROW_SRC
WORKDIR $BURROW_SRC

RUN go mod tidy && go build -o /tmp/ ./...

# stage 2: runner
FROM alpine:3.12

COPY --from=builder /tmp/burrow /app/
COPY --from=builder /tmp/configure /etc/burrow/
ADD ./entrypoint.sh /etc/burrow/entrypoint.sh

CMD ["/etc/burrow/entrypoint.sh"]
