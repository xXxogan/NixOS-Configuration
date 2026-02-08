{ config, pkgs, username, homeDirectory, ... }: {
  
  home = {
    inherit username homeDirectory;
    stateVersion = "24.11"; # Должна совпадать с версией home-manager в flake inputs
    
    packages = with pkgs; [
      neofetch
      htop
      # git # git уже есть в systemPackages, но можно оставить и тут для локальной настройки
    ];
  };

  programs.bash = {
    enable = true;
    shellAliases = 
      let
        flakePath = "${homeDirectory}/nixos-config"; 
      in {
        # Обновляем всё сразу одной командой
        rebuild = "sudo nixos-rebuild switch --flake ${flakePath}#nixos";
        v = "vim";
      };
  };

  # Чтобы git работал корректно, лучше настроить его через HM
  programs.git = {
    enable = true;
    userName = "Xogan";
    userEmail = "youremail@example.com";
  };
}
