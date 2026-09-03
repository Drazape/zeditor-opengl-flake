{
  description = "Zeditor compiled for OpenGL graphics";

  inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
  };

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { pkgs, ... }: {
				packages = {
				  zeditor-opengl-src = pkgs.zed-editor.overrideAttrs (finalAttrs: previousAttrs: {
            # inject the GLES configuration flag required by Zed's gpui crate
            env = (previousAttrs.env or { }) // {
              RUSTFLAGS = "--cfg gles";
            };
            
            # explicitly ensure libGL is available during the CI build
            buildInputs = (previousAttrs.buildInputs or [ ]) ++ [ pkgs.libGL ];
          });
        };
			};
		};
}
