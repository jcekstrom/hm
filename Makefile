
.PHONY: switch-ora switch-mac switch-hm switch-ssm \
        build-lima build-lima-x86_64 build-lima-aarch64 \
        start-lima shell-lima rebuild-lima-x86_64 rebuild-lima-aarch64 \
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

# Lima VM: build x86_64 qcow2 image (run on ora)
build-lima-x86_64:
	nix build .#packages.x86_64-linux.lima-vm-img \
		--out-link result/nixos-x86_64.qcow2

# Lima VM: build aarch64 qcow2 image (run on Mac — uses linux-builder)
build-lima-aarch64:
	nix build .#packages.aarch64-linux.lima-vm-img \
		--out-link result/nixos-aarch64.qcow2

# Lima VM: build both architectures
build-lima: build-lima-x86_64 build-lima-aarch64

# Lima VM: create and start the VM (build image first)
# Lima picks the correct arch image automatically from nixos.yaml
start-lima:
	limactl start hosts/lima-vm/nixos.yaml --name nixos

# Lima VM: open a shell in the running VM
shell-lima:
	limactl shell nixos

# Lima VM: rebuild NixOS inside the running VM from this flake
rebuild-lima-x86_64:
	limactl shell nixos -- sudo nixos-rebuild switch --flake .#lima-vm

rebuild-lima-aarch64:
	limactl shell nixos -- sudo nixos-rebuild switch --flake .#lima-vm-aarch64

# Update all flake inputs
update:
	nix flake update

clean:
	nix-collect-garbage -d
