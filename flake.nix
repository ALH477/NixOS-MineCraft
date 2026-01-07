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

          postBuild = ''
            # 1. Wrap the binary
            wrapProgram $out/bin/prismlauncher \
              --prefix PATH : ${pkgs.lib.makeBinPath (javaRuntimes ++ extraTools)} \
              --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath runtimeLibs} \
              --set JAVA_HOME ${pkgs.jdk21.home} \
              --set GAMEMODERUNEXEC "env LD_PRELOAD=${pkgs.gamemode}/lib/libgamemodeauto.so"

            # 2. Fix Desktop Integration
            # CRITICAL FIX: We must remove the symlinks created by symlinkJoin 
            # before we can replace them with our modified versions.
            rm -f $out/share/applications/*.desktop

            # Copy the original desktop files to the output
            cp ${pkgs.prismlauncher}/share/applications/*.desktop $out/share/applications/
            
            # Ensure the copied file is writable so we can modify it
            chmod +w $out/share/applications/*.desktop

            # Update the desktop file to use our wrapped binary and custom name
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
