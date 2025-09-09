{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.qbittorrent-container;
in

{
  options.qbittorrent-container = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to install the qbittorrent systemd service";
    };

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the qbittorrent systemd service";
    };

    envFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Path to a .env file after decryption (use agenix).";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.qbittorrent = {
      description = "qBittorrent headless inside a protonvpn-protected docker container.";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = lib.mkIf cfg.autostart [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = "/etc/qbittorrent";
        ExecStart = "${pkgs.docker}/bin/docker compose up -d";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
      };
    };

    system.activationScripts.qbittorrent.text = ''
      cp -a ${./.}/. /etc/qbittorrent/
      cp ${cfg.envFile} /etc/qbittorrent/.env
    '';
  };
}
