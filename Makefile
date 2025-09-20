
.PHONY: switch-ora switch-mac switch-hm switch-ssm \
        build-lima start-lima shell-lima rebuild-lima \
        update clean

# NixOS: Framework 13 AMD (ora)
switch-ora:
	sudo nixos-rebuild switch --flake .#ora

# nix-darwin: macOS work laptop
switch-mac:
	darwin-rebuild switch --flake .#RESML-CT2334DN6X

# Standalone home-manager: primary Linux user
switch-hm:
	home-manager switch -b old --flake .#jce

# Standalone home-manager: AWS SSM user
switch-ssm:
	home-manager switch -b old --flake .#ssm-user

# Lima VM: build qcow2 image (output at result/nixos.qcow2)
build-lima:
	nix build .#lima-vm-img --out-link result/nixos.qcow2

# Lima VM: create and start the VM (run build-lima first)
start-lima:
	limactl start hosts/lima-vm/nixos.yaml --name nixos

# Lima VM: open a shell in the running VM
shell-lima:
	limactl shell nixos

# Lima VM: rebuild NixOS inside the running VM from this flake
rebuild-lima:
	limactl shell nixos -- sudo nixos-rebuild switch --flake .#lima-vm

# Update all flake inputs
update:
	nix flake update

clean:
	nix-collect-garbage -d
