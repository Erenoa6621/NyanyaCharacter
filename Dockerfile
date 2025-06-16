FROM golang:1.21-alpine AS build
WORKDIR /src
COPY . .
RUN go mod download
RUN go build -o /go/bin/api ./cmd/api

FROM alpine:3.20
ENV TZ=Asia/Tokyo
COPY --from=build /go/bin/api /usr/local/bin/api
EXPOSE 8080
CMD ["api"]