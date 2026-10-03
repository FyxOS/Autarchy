# Autarchy: Omarchy on FyxOS, built from Omarchy's own pinned source.
#
# Omarchy's defaults (default/, themes/, bin/) live read-only in the store at
# $OMARCHY_PATH, exactly where Omarchy's Lua config looks for them. Each user's
# ~/.config is seeded once from Omarchy's config/ templates, as Omarchy's own
# installer does: those are thin override files the user owns, and updating
# the flake input updates the defaults underneath them.
omarchySrc:
{ config, lib, pkgs, ... }:
let
  omarchy = pkgs.runCommand "omarchy-${omarchySrc.shortRev or "src"}" { } ''
    mkdir -p $out/share
    cp -r ${omarchySrc} $out/share/omarchy
    chmod -R u+w $out/share/omarchy
  '';
  omarchyPath = "${omarchy}/share/omarchy";

  seed = pkgs.writeShellScript "autarchy-seed" ''
    set -eu
    marker="$HOME/.local/state/autarchy/seeded"
    [ -e "$marker" ] && exit 0
    mkdir -p "$HOME/.config" "$(dirname "$marker")"
    # Omarchy's installer: cp -R config/* ~/.config/, without clobbering.
    cp -rn --no-preserve=mode ${omarchyPath}/config/. "$HOME/.config/"
    export OMARCHY_PATH=${omarchyPath} PATH=${omarchyPath}/bin:$PATH
    omarchy-theme-set tokyo-night || echo "autarchy: theme not applied yet" >&2
    touch "$marker"
  '';
in
{
  fyx.fhs.presets.desktop = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "hyprland-uwsm";

  environment.systemPackages = (import ./packages.nix pkgs) ++ [ omarchy ];
  environment.sessionVariables.OMARCHY_PATH = omarchyPath;
  environment.extraInit = ''
    export PATH="$PATH:${omarchyPath}/bin"
  '';

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    font-awesome
    ia-writer-duospace
  ];

  # What Omarchy enables rather than merely installs.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hardware.bolt.enable = true;
  virtualisation.docker.enable = true;
  networking.networkmanager.enable = true;
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  systemd.user.services.autarchy-seed = {
    description = "Seed ~/.config from Omarchy's templates (once)";
    wantedBy = [ "default.target" ];
    before = [ "graphical-session-pre.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = seed;
    };
  };
}
