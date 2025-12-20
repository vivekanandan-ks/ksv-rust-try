{
  description = "Flet GUI App with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";

    naersk.url = "github:nix-community/naersk";

  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          self',
          inputs',
          pkgs,
          ...
        }:
        let
          naerskLib = pkgs.callPackage inputs.naersk { };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
              #glib
            ];

            nativeBuildInputs = [ pkgs.pkg-config ];

            env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

          };

          packages.default = pkgs.rustPlatform.buildRustPackage {
            name = "rust-app";
            src = ./.;
            buildInputs = [ pkgs.glib ];
            nativeBuildInputs = [ pkgs.pkg-config ];
            cargoLock.lockFile = ./Cargo.lock;
          };

          packages.naersk = naerskLib.buildPackage {
            src = ./.;
            buildInputs = [ pkgs.glib ];
            nativeBuildInputs = [ pkgs.pkg-config ]; 
          };

        };
    };
}
