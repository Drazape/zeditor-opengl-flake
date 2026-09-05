{
  description = "Zeditor compiled for OpenGL graphics";

  inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		zeditor-opengl-release = {
			url = "https://github.com/Drazape/zeditor-opengl-flake/releases/latest/download/zed-opengl-x86_64-linux.tar.gz";
			flake = false;
		};
  };

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { self', pkgs, lib, ... }: {
				packages = {
					default = self'.packages.zeditor-opengl;
					zeditor-opengl = pkgs.stdenvNoCC.mkDerivation {
						name = "zeditor-opengl";
						src = inputs.zeditor-opengl-release;

						installPhase = ''
							${lib.getExe' pkgs.coreutils "cp"} --recursive -- $src/ $out/
						'';

						meta = {
							description = "Zeditor compiled for OpenGL graphics";
							homepage = "https://github.com/Drazape/zeditor-opengl-flake";
							license = lib.licenses.gpl3;
							platforms = lib.platforms.linux;
						};
					};
				  zeditor-opengl-src = pkgs.zed-editor-fhs.overrideAttrs (finalAttrs: previousAttrs: {
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
