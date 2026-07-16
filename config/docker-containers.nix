{ pkgs, ... }:

{
  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama Docker container";
      After = [ "docker.service" ];
      Requires = [ "docker.service" ];
    };
    Service = {
      ExecStartPre = [
        "-${pkgs.docker}/bin/docker stop ollama"
        "-${pkgs.docker}/bin/docker rm ollama"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run --name ollama --rm -p 11434:11434 -v ollama:/root/.ollama ollama/ollama";
      ExecStop = "${pkgs.docker}/bin/docker stop ollama";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes agent Docker container";
      After = [ "docker.service" ];
      Requires = [ "docker.service" ];
    };
    Service = {
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
