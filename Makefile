

.PHONY: update
update:
	home-manager switch --flake .#myprofile

clean:
	nix-collect-garbage -d
