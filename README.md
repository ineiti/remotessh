# remotessh

Configure a remote connection through ssh.

Teamviewer is great, but under some circumstances it's not possible:
* low-bandwidth - waiting for the screen to show is sloooow
* IoT-devices where it's not installable

Other solutions like VPN might be too difficult to install.

I struggled mostly with the first point and searched for a long time a way to access a compter remotely through ssh.
Because the sharing-feature of Macs or opening a ssh-port under Linux doesn't work through NAT, 
`remotessh` solves the problem by connecting to a server:

```ascii
Remote computer ---->  public server  <---- control computer

sshd listening on      can connect          needs access to
port 2222              to remote computer   public server
ssh port-forwarding    through port 2222
to server
```

On the control-computer, you initialize the keys:

```bash
./scripts/install.sh user@host
```

And then you zip the whole directory and send it to your 'remote computer'.
Now your friend unzips it and runs either

```bash
./scripts/start_remote.sh
```

or double-clicks on the `start_remote.scpt` if he has a Mac.
Now you can connect to your public server and run

```bash
./connect_remote.sh
```

And _voila_, you're connected to the remote computer via ssh.

# Security

This gives access to your public server to the user from the remote computer.
Each time you run `install.sh`, a new keypair is created for the remote computer, and
the public server has the public key installed in its `authorized_keys`.
