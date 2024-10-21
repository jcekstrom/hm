

.PHONY: update
update:
	home-manager switch -b old --show-trace --flake .#myprofile

clean:
	nix-collect-garbage -d
