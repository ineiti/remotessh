#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILES="$DIR/../files"

LOGIN=$1
PORT=${2:-22}
if [ ! "$LOGIN" ]; then
  echo "Syntax: $0 user@host [port]"
  exit 1
fi
rm -f "$FILES"/*
mkdir -p "$FILES"
cp "$DIR/sshd_config" "$FILES"
echo $LOGIN > "$FILES/login"
echo $PORT > "$FILES/port"
echo "Creating host-keys"
for c in rsa dsa ecdsa ed25519; do
  ssh-keygen -q -N '' -t $c -f "$FILES/ssh_host_${c}_key"
done
echo "Creating personal key for connection"
ssh-keygen -q -N '' -f "$FILES/local_key"
echo "Connecting to remote host - please give password when asked"
ssh-keyscan -p $PORT ${LOGIN#*@} > "$FILES/known_hosts"
cat "$FILES/local_key.pub" | ssh -p $PORT $LOGIN -i "$FILES/local_key" "mkdir -p .ssh; cat - >> .ssh/authorized_keys"
echo "Copying remote public key for automatic connection"
ssh -p $PORT $LOGIN -i "$FILES/local_key" "test -f ~/.ssh/id_rsa.pub || ssh-keygen -N ''; cat ~/.ssh/id_rsa.pub" > "$FILES/authorized_keys"
#ssh -p $PORT $LOGIN -i "$FILES/local_key" "ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2222"
#cat "$FILES/"ssh_host_*.pub | ssh -p $PORT $LOGIN -i "$FILES/local_key" "cat - >> ~/.ssh/known_hosts"

echo
echo "Done - now you can run locally"
echo "  ./scripts/start_remote.sh"
echo "and on the remote host:"
echo "  ./connect_remote.sh"

