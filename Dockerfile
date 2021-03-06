# FROM centos:7 AS builder
# RUN yum group install -y "Development Tools" &&\
#     yum install -y epel-release &&\
#     yum install -y git &&\
#     yum install -y go
# RUN git clone https://github.com/WireGuard/wireguard-go.git &&\
#     cd wireguard-go &&\
#     make &&\
#     cp ./wireguard-go /tmp/wireguard-go

FROM golang:1.16-rc-alpine AS builder
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh make
RUN git clone https://github.com/WireGuard/wireguard-go.git &&\
    cd wireguard-go &&\
    make &&\
    cp ./wireguard-go /tmp/wireguard-go

FROM alpine:3.12.3
ENV INTERFACE_NAME=wg0
ENV WIREGUARD_IP=""
ENV WIREGUARD_KEY_PATH=""
ENV WIREGUARD_CONFIG_PATH=""
ENV WIREGUARD_EXTRA_ROUTED_CIDRS=""
RUN apk add -U wireguard-tools iproute2 net-tools
COPY --from=builder /tmp/wireguard-go /bin/wireguard-go
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh &&\
    chmod +x /bin/wireguard-go
ENTRYPOINT ["entrypoint.sh"]


#FROM centos:7
#ENV INTERFACE_NAME=wg0
#ENV WIREGUARD_IP=""
#ENV WIREGUARD_KEY_PATH=""
#ENV WIREGUARD_CONFIG_PATH=""
#ENV WIREGUARD_EXTRA_ROUTED_CIDRS=""
#RUN yum install -y epel-release &&\
#    yum install -y iproute &&\
#    yum install -y kernel-plus wireguard-tools &&\
#    yum install -y net-tools
#COPY --from=builder /tmp/wireguard-go /bin/wireguard-go
#COPY entrypoint.sh /bin/entrypoint.sh
#RUN chmod +x /bin/entrypoint.sh &&\
#    chmod +x /bin/wireguard-go
#ENTRYPOINT ["entrypoint.sh"]
