{ ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.19.210.245/32" ];
    dns = [ "10.0.0.243" ];
    privateKeyFile = "/etc/wireguard/privatekey";
    peers = [{
      publicKey = "9lyJHHd6OMiK5pu1BKdbO5FhxI0rx3p8Kakid63jFAM=";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      endpoint = "212.56.48.103:1337";
      persistentKeepalive = 25;
    }];
  };
}
