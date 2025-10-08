self:
{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) types;
  inherit (pkgs) coreutils;

  timeType = types.addCheck types.str (s: builtins.match "^[0-2][0-9]:[0-5][0-9]$" s != null);
  cfg = config.services.capTUre;

  scheduleModule =
    { config, name, ... }:
    let
      jobName = config.name;
      sanitized = lib.strings.sanitizeDerivationName name;
      channelArg = lib.escapeShellArg config.channel;
      script = pkgs.writeShellScript "capTUre-${sanitized}" ''
        set -euo pipefail
        base_dir=/var/lib/capTUre
        sub_path="$(date +%Y/%m/%d)"
        mkdir -p "$base_dir/$sub_path"
        output_file="$base_dir/$sub_path/${sanitized}.ts"
        exec ${coreutils}/bin/timeout ${toString (config.duration * 60)}s \
          ${cfg.package}/bin/capTUre record \
          --channel ${channelArg} \
          --output-file "$output_file"
      '';
    in
    {
      options = {
        name = lib.mkOption {
          type = types.str;
          default = name;
          defaultText = "<attribute name>";
          description = "Label for the recording job; also used in the output filename.";
        };

        weekday = lib.mkOption {
          type = types.enum [
            "Monday"
            "Tuesday"
            "Wednesday"
            "Thursday"
            "Friday"
            "Saturday"
            "Sunday"
          ];
          description = "Weekday on which the recording starts.";
        };

        start = lib.mkOption {
          type = timeType;
          description = "Start time (24-hour HH:MM).";
        };

        duration = lib.mkOption {
          type = types.addCheck types.int (n: n > 0);
          description = "Recording length in minutes.";
        };

        channel = lib.mkOption {
          type = types.str;
          description = "Channel identifier passed to `capTUre record --channel`.";
        };

        atRoot = lib.mkOption {
          internal = true;
          default = { };
        };
      };

      config = {
        atRoot = lib.mkIf cfg.enable {
          systemd.services."capTUre-${sanitized}" = {
            description = "capTUre job ${jobName}";
            path = [
              cfg.package
              coreutils
            ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = script;
              StateDirectory = "capTUre";
              User = cfg.user;
              Group = cfg.group;
            };
          };

          systemd.timers."capTUre-${sanitized}" = {
            description = "Timer for capTUre job ${jobName}";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "${config.weekday} *-*-* ${config.start}:00";
              Persistent = true;
            };
          };
        };
      };
    };
in
{
  options.services.capTUre = {
    enable = lib.mkEnableOption "capTUre";

    package = lib.mkPackageOption self.packages.${pkgs.system} "default" {
      default = "default";
      pkgsText = "capTUre.packages.\${pkgs.system}.default";
    };

    user = lib.mkOption {
      type = types.str;
      default = "capTUre";
      description = "System user account that runs the scheduled capTUre recordings.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "capTUre";
      description = "Primary group used for the scheduled capTUre recordings.";
    };

    schedule = lib.mkOption {
      description = "List of weekly recording jobs that capTUre should run.";
      default = { };
      example = {
        morningLecture = {
          name = "Theoretical Computer Science";
          weekday = "Monday";
          start = "07:30";
          duration = 60;
          channel = "gm1";
        };
      };
      type = types.attrsOf (types.submodule scheduleModule);
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge (
      [
        {
          environment.systemPackages = [ cfg.package ];
          systemd.services = lib.mkMerge (
            map (entry: entry.atRoot.systemd.services or { }) (lib.attrValues cfg.schedule)
          );
          systemd.timers = lib.mkMerge (
            map (entry: entry.atRoot.systemd.timers or { }) (lib.attrValues cfg.schedule)
          );
        }
        {
          users.groups.${cfg.group} = { };
          users.users.${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            home = "/var/lib/capTUre";
            createHome = true;
          };
        }
      ]
    )
  );
}
