{ config, pkgs, username, homeDirectory, ... }: {
	home = {
		inherit username homeDirectory;
		stateVersion = "25.05";
		
		packages = with pkgs; [
			neofetch
			htop
			git
		];
	};
	programs.bash = {
		enable = true;
		shellAliases = 
		let
			flakePath = "${homeDirectory}/nixos-config"; 
		in {
			rebuild = "sudo nixos-rebuild switch --flake ${flakePath}#nixos";
			hms = "home-manager switch --flake ${flakePath}#xogan";
			v = "vim";
		};
	};

}
