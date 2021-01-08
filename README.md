# wireguard-sidecar

## Getting Started
```
# Make the config directory that will be mounted into the container
mkdir config_dir

# Generate the private-key and pipe it to a file
wg genkey > config_dir/private-key

# Create the wireguard config that will be used in the container
cat << EOF > config_dir/config.txt
[Interface]
ListenPort = 48732
PrivateKey = $(cat config_dir/private-key)

[Peer]
PublicKey = bnVueWFidXNpbmVzcwo=
AllowedIPs = 192.168.2.0/24
Endpoint = xxx.xxx.xxx.xxx:51820
EOF

# Start the docker container
docker run --rm -it \
    --cap-add=NET_ADMIN \
    --mount type=bind,source="$(pwd)"/config_dir,target=/root/config_dir \
    -e INTERFACE_NAME="wg0" \
    -e WIREGUARD_IP="192.168.2.2" \
    -e WIREGUARD_KEY_PATH="/root/config_dir/private-key" \
    -e WIREGUARD_CONFIG_PATH="/root/config_dir/config" \
    docker.pkg.github.com/turnbros/wireguard-sidecar/wireguard-sidecar:0.1.0 /bin/bash
```
