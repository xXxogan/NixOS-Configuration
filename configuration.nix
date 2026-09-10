# Edit this configuration file to define what should be installed on
# your system.

{ config, pkgs, lib, home-manager, username, homeDirectory, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      home-manager.nixosModules.home-manager
    ];

  # --- Настройки Home Manager ---
  # home-manager.enable = true;
  home-manager.useUserPackages = true;
  # Передаем аргументы (pkgs, lib и т.д.) автоматически через extraSpecialArgs, если нужно
  home-manager.users.${username} = import ./home.nix;

  # Если в home.nix нужны username/homeDirectory, их можно передать так:
  home-manager.extraSpecialArgs = { inherit username homeDirectory; };

  # --- Загрузчик ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Сеть ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Локаль и Время ---
  time.timeZone = "Asia/Novosibirsk";
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # ! ВАЖНО: Шрифты консоли для русского языка
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

  # --- Графическая среда (GNOME) ---
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # ! ВАЖНО: Настройка клавиатуры (US + RU) и переключение по Alt+Shift
    xkb = {
      layout = "us,ru";
      variant = "";
      options = "grp:lctrl_lshift_toggle";
    };
  };

  # --- Звук ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.roothashedPassword = "$6$cj44.peC5LuEO.u2$3DnoYW5JIprHgTMqyDN6MtFXaPSBO0eOfECWueCHgPlgsqdPhB/2tRICaZ.uad6yezPWYmvtDQmA6E8Sf61Ax1";

  # --- Пользователь (Объединенный блок) ---
  users.users.${username} = {
    isNormalUser = true;
    hashedPassword = "$6$cj44.peC5LuEO.u2$3DnoYW5JIprHgTMqyDN6MtFXaPSBO0eOfECWueCHgPlgsqdPhB/2tRICaZ.uad6yezPWYmvtDQmA6E8Sf61Ax1";
    description = "Xogan";
    home = homeDirectory;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # thunderbird
    ];
  };

  # --- Автологин ---
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = username;

  # Workaround for GNOME autologin issue
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # --- Пакеты и Программы ---
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    open-vm-tools
    # home-manager # Не обязательно ставить как пакет, если он подключен модулем, но можно оставить
  ];

  # VM Tools (Для VMware/Parallels)
  systemd.services.vmtoolsd.enable = true;

  # --- SSH и Nix Settings ---
  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05"; # Используй версию, с которой ставишь систему
}
