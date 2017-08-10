#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILES="$DIR/../files"
PORT=$( cat "$FILES/port" )
LOGIN=$( cat "$FILES/login" )
mkdir -p ~/.remotessh
cp "$FILES/authorized_keys" ~/.remotessh/authorized_keys
cp "$FILES/known_hosts" ~/.remotessh/known_hosts
pkill sshd
pkill -f "ssh -fNT"
if [ -z "$1" ]; then
  /usr/sbin/sshd -h "$FILES/ssh_host_rsa_key" -h "$FILES/ssh_host_dsa_key" -h "$FILES/ssh_host_ecdsa_key" -h "$FILES/ssh_host_ed25519_key" -f "$FILES/sshd_config" \
 -o "AuthorizedKeysFile=%h/.remotessh/authorized_keys"
  ssh -p $PORT -o "UserKnownHostsFile=$HOME/.remotessh/known_hosts" -i "$FILES/local_key" $LOGIN \
    "echo ssh -o StrictHostKeyChecking=no -p 2222 $USER@localhost > connect_remote.sh; chmod a+x connect_remote.sh"
  ssh -fNT -p $PORT -o "UserKnownHostsFile=$HOME/.remotessh/known_hosts" -i "$FILES/local_key" -R 2222:localhost:2222 $LOGIN
fi
