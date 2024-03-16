{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.rsl.vacuum-journalctl-cron;
in
{
  meta = {
    # description = "Cron to vacuum journalctl logs";
    maintainers = with lib; [ maintainers.anthonyroussel ];
  };

  options.rsl.vacuum-journalctl-cron = {
    enable = lib.mkEnableOption "Whether to auto vacuum journalctl logs";

    cronExpression = lib.mkOption {
      type = lib.types.str;
      default = "0 20 * * *";
      description = "Cron expression";
    };

    vacuumTime = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Vacuum time";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cron.systemCronJobs = [
      "${cfg.cronExpression} root ${pkgs.systemd}/bin/journalctl --vacuum-time=${toString cfg.vacuumTime}d"
    ];
  };
}
