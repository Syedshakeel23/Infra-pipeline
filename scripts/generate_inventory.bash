#!/bin/bash

FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip)

cat > ../ansible/inventory.ini <<EOF
[frontend]
$FRONTEND_IP ansible_user=ec2-user

[backend]
$BACKEND_IP ansible_user=ubuntu
EOF

