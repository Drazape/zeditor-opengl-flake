{
  description = "Zeditor compiled for OpenGL graphics";

  inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		zeditor = {
			type="github"; owner="zed-industries"; repo="zed";
			inputs = {
				nixpkgs.follows = "nixpkgs";
				flake-parts.follows = "flake-parts";
			};
		};
  };

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { inputs', ... }: {
				packages = {
				  zeditor-opengl-src = inputs'.zeditor.packages.default.override { withGLES = true; };
				};
			};
		};

	# from official Zed flake
	nixConfig = {
		extra-substituters = [
			"https://zed.cachix.org"
		];
		extra-trusted-public-keys = [
			"zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
		];
	};
}
