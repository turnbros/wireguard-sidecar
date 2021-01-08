FROM centos:7
ENV INTERFACE_NAME=wg0
ENV WIREGUARD_IP=""
ENV WIREGUARD_KEY_PATH=""
ENV WIREGUARD_CONFIG_PATH=""
ENV WIREGUARD_EXTRA_ROUTED_CIDRS=""
RUN yum install -y epel-release &&\
    yum install -y iproute &&\
    yum install -y kernel-plus wireguard-tools &&\
    yum install -y net-tools
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
