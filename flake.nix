{
  description = "DeMoD LLC Production-grade Minecraft Suite";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        javaRuntimes = with pkgs; [ jdk8 jdk17 jdk21 ];
        extraTools = with pkgs; [ gamemode mangohud gnutar zip unzip ];

        runtimeLibs = with pkgs; [
          libpulseaudio pipewire openal libGL libglvnd mesa vulkan-loader
          glfw wayland libxkbcommon xorg.libX11 xorg.libXcursor
          xorg.libXrandr xorg.libXext xorg.libXxf86vm xorg.libXi
          udev stdenv.cc.cc.lib
        ];

      in
      {
        packages.default = pkgs.symlinkJoin {
          name = "prism-launcher-optimized";
          paths = [ pkgs.prismlauncher ] ++ javaRuntimes ++ extraTools;
          buildInputs = [ pkgs.makeWrapper ];

          # Added logic to fix desktop icons and menu entries for Production UX
          postBuild = ''
            # 1. Wrap the binary
            wrapProgram $out/bin/prismlauncher \
              --prefix PATH : ${pkgs.lib.makeBinPath (javaRuntimes ++ extraTools)} \
              --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath runtimeLibs} \
              --set JAVA_HOME ${pkgs.jdk21.home} \
              --set GAMEMODERUNEXEC "env LD_PRELOAD=${pkgs.gamemode}/lib/libgamemodeauto.so"

            # 2. Fix Desktop Integration
            # We copy the upstream desktop file and replace the Exec path to point to our wrapped version
            mkdir -p $out/share/applications
            cp -r ${pkgs.prismlauncher}/share/icons $out/share/ 2>/dev/null || true
            cp ${pkgs.prismlauncher}/share/applications/*.desktop $out/share/applications/
            
            substituteInPlace $out/share/applications/*.desktop \
              --replace "Exec=prismlauncher" "Exec=$out/bin/prismlauncher" \
              --replace "Name=Prism Launcher" "Name=Minecraft (DeMoD Optimized)"
          '';

          meta = with pkgs.lib; {
            description = "Optimized Minecraft launcher environment with bundled JREs and performance tools";
            homepage = "https://github.com/DeMoD-LLC";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/prismlauncher";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.default ];
          shellHook = ''
            echo "-------------------------------------------------------"
            echo " DeMoD LLC - Minecraft Production Environment"
            echo "-------------------------------------------------------"
            echo " Optimized launcher available: prismlauncher"
            echo "-------------------------------------------------------"
          '';
        };
      }
    );
}
