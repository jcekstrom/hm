# KDE Plasma 6 desktop environment
{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  programs.firefox.enable = true;

  # KDE-specific system packages
  environment.systemPackages = with pkgs; [
    kdePackages.discover
    kdePackages.isoimagewriter
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.partitionmanager
    kdePackages.sddm-kcm
    kdiff3
    haruna
    hardinfo2
  ];
}
