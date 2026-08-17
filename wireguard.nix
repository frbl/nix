{ ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = [ "10.6.213.177/32" ];
    dns = [ "10.0.0.243" ];
    privateKeyFile = "/etc/wireguard/privatekey";
    peers = [{
      publicKey = "KFhDIugLhih90Y69eREd3R0qX6WQ7+D1Lxidbm0phDI=";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      endpoint = "212.56.48.49:1337";
      persistentKeepalive = 25;
    }];
  };
}
