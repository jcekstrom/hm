

.PHONY: update
update:
	home-manager switch -b old --flake .#myprofile

clean:
	nix-collect-garbage -d
