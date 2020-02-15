FROM golang:alpine as build
COPY hello.go .
RUN go build -o hello hello.go
# above is ~350MB

FROM alpine as alpine-run
COPY --from=build /go/hello /hello
CMD ["/hello"]
# above is ~7MB

FROM scratch as scratch-run
COPY --from=build /go/hello /hello
CMD ["/hello"]
# above is ~2MB
