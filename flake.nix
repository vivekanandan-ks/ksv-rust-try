{
  description = "Flet GUI App with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";

    naersk.url = "github:nix-community/naersk";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

          fenixLib = inputs'.fenix.packages;
          rustToolchain = fenixLib.stable.toolchain;
        in
        {
          # devshell plain
          devShells.plain = pkgs.mkShell {
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

          #devshell fenix
          devShells.fenix = pkgs.mkShell {
            buildInputs = [ rustToolchain ];
            #env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          };

          # plain
          packages.plain = pkgs.rustPlatform.buildRustPackage {
            name = "rust-app";
            src = ./.;
            buildInputs = [ pkgs.glib ];
            nativeBuildInputs = [ pkgs.pkg-config ];
            cargoLock.lockFile = ./Cargo.lock;
          };

          # naersk
          packages.naersk = naerskLib.buildPackage {
            src = ./.;
            buildInputs = [ pkgs.glib ];
            nativeBuildInputs = [ pkgs.pkg-config ];
          };

          # fenix x plain
          packages.fenix-plain =
            (pkgs.makeRustPlatform {
              cargo = rustToolchain;
              rustc = rustToolchain;
            }).buildRustPackage
              {
                name = "rust-app";
                src = ./.;
                buildInputs = [ pkgs.glib ];
                nativeBuildInputs = [ pkgs.pkg-config ];
                cargoLock.lockFile = ./Cargo.lock;
              };

          # fenix x naersk
          packages.fenix-naersk =
            (naerskLib.override {
              cargo = rustToolchain;
              rustc = rustToolchain;
            }).buildPackage
              {
                src = ./.;
                buildInputs = [ pkgs.glib ];
                nativeBuildInputs = [ pkgs.pkg-config ];
              };

        };
    };
}
