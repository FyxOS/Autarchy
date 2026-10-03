# Boots Autarchy (stable) to a Hyprland session and checks that Omarchy's own
# config is what Hyprland loaded.
{ pkgs, modules }:
pkgs.testers.runNixOSTest {
  name = "autarchy-session";
  # Omarchy's list includes unfree apps (Obsidian); installs allow unfree too.
  node.pkgsReadOnly = false;
  nodes.machine = {
    nixpkgs.config.allowUnfree = true;
    imports = modules;
    users.users.alice = {
      isNormalUser = true;
      password = "alice";
    };
    services.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };
    virtualisation.memorySize = 4096;
    virtualisation.cores = 4;
  };
  testScript = ''
    machine.wait_for_unit("display-manager.service")
    machine.wait_until_succeeds("test -e /home/alice/.local/state/autarchy/seeded", timeout=300)

    with subtest("Omarchy's templates and defaults are in place"):
        machine.succeed("test -e /home/alice/.config/hypr/hyprland.lua")
        machine.succeed("grep -q OMARCHY_PATH /home/alice/.config/hypr/hyprland.lua")
        machine.succeed("su - alice -c 'test -d \"$OMARCHY_PATH/default/hypr\"'")
        machine.succeed("su - alice -c 'command -v omarchy-theme-set'")

    with subtest("Hyprland starts on Omarchy's Lua config"):
        # A running Hyprland has an instance socket (what hyprctl talks to);
        # nixpkgs wraps the binary, so the process is `.Hyprland-wrapped`.
        machine.wait_until_succeeds("ls /run/user/1000/hypr/*/.socket.sock", timeout=300)
        print(machine.succeed("su - alice -c 'HYPRLAND_INSTANCE_SIGNATURE=$(ls /run/user/1000/hypr) hyprctl version' | head -3"))
        # Omarchy's own autostart ran under uwsm.
        machine.wait_until_succeeds("pgrep -u alice -f omarchy-hyprland-monitor-watch", timeout=60)

    machine.sleep(20)
    machine.screenshot("autarchy")
  '';
}
