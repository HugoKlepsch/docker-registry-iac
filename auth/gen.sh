#!/bin/env bash

pushd htpasswd-img

docker build -t htpasswd .

popd

read -p "Enter registry user: " user
echo
read -s -p "Enter registry password: " password
echo

read -p "Create user ${user}? Will append configuration to registry.password and save backup to registry.password.bak (y/N)" continue
echo

if [ "${continue}" != "y" ] ; then
  echo "Exiting"
  exit 0
fi

echo "Backing up registry.password -> registry.password.bak"
touch registry.password
cp registry.password registry.password.bak

echo "Appending user"
docker run --rm htpasswd -Bbn -C 10 "${user}" "${password}" >> registry.password
