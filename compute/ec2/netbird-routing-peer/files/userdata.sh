#! /usr/bin/env bash

# Add the repository
tee /etc/yum.repos.d/netbird.repo <<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

# Import the file
dnf config-manager --add-repo /etc/yum.repos.d/netbird.repo

# Install the package
dnf install -y netbird jq

# Download netbird config file
aws secretsmanager get-secret-value \
    --secret-id ${secret_name} \
    --region ${region} \
    --output text \
    --query SecretString | jq -r '."setup-key"' > /etc/netbird/setup.key

# Run netbird
netbird up --setup-key-file /etc/netbird/setup.key
