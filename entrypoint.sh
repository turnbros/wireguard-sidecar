#!/bin/bash

# Create the tunnel adapter
mkdir /dev/net
mknod /dev/net/tun c 10 200

# Create the wireguard interface
wireguard-go ${INTERFACE_NAME}

# Set the private key for this wireguard interface
wg set ${INTERFACE_NAME} private-key ${WIREGUARD_KEY_PATH}

# An IP address and peer can be assigned with ifconfig(8) or ip-address(8)
ip addr add ${WIREGUARD_IP}/24 dev ${INTERFACE_NAME}

# Configure the interfacing using the wg utility
wg setconf ${INTERFACE_NAME} ${WIREGUARD_CONFIG_PATH}

# Turn on the wireguard interface
ip link set up dev ${INTERFACE_NAME}

$@
