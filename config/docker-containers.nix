{ pkgs, ... }:

{
  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes agent Docker container";
      After = [ "docker.service" ];
      Requires = [ "docker.service" ];
    };
    Service = {
      Environment = [ "DOCKER_HOST=unix://%t/docker.sock" ];
      ExecStartPre = [
        "-${pkgs.docker}/bin/docker stop hermes-agent"
        "-${pkgs.docker}/bin/docker rm hermes-agent"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run --name hermes-agent --rm nousresearch/hermes-agent";
      ExecStop = "${pkgs.docker}/bin/docker stop hermes-agent";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
