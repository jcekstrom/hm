{
inputs,
outputs,
pkgs,
...
}:# let
{
	imports = [
		inputs.nixvim.homeManagerModules.nixvim
		#./keymaps.nix
		./style.nix
		#./telescope.nix
		#./treesitter.nix
		#./harpoon.nix
		#./folds.nix
		#./lsp.nix
		#./completion.nix
		#./format.nix
		./lint.nix
		#./debug.nix
	];

	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		vimdiffAlias = true;
		globals = {
			mapleader = " ";
		};

		opts = {
			number = true;
			colorcolumn = "100";
			relativenumber = false;
			shiftwidth = 2;
			tabstop = 2;
			wrap = false;
			swapfile = false; #Undotree
			backup = false; #Undotree
			undofile = true;
			hlsearch = false;
			incsearch = true;
			termguicolors = true;
			scrolloff = 8;
			signcolumn = "yes";
			updatetime = 50;
			foldlevelstart = 99;
			expandtab = true;
		};

		plugins = {
			gitsigns.enable = true;
			oil.enable = true;
			undotree.enable = true;
			fugitive.enable = true;
      gitblame.enable = true;
			nvim-tree.enable = true;
      fzf-lua = {
        enable = true;
      };
		};
		extraPackages = with pkgs; [
			vimPlugins.awesome-vim-colorschemes
			# Formatters
		];
	};
}
