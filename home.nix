{ config, pkgs, ... }: {
	home = {
		username = "xogan";
		homeDirectory = "/home/xogan";
		stateVersion = "25.05";
		
		packages = with pkgs; [
			neofetch
			htop
		];
	};
	programs.bash = {
		enable = true;
		shellAliases = 
		let
			flakePath = "~/nix"; 
		in {
			rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
			hms = "home-manager switch --flake ${flakePath}";
			v = "vim";
		};
	};

}
