# Minecraft Optimized Environment

This repository provides a professional-grade Nix flake for a performance-optimized Minecraft environment using the Prism Launcher. Managed by DeMoD LLC, this configuration bundles multiple Java Runtime Environments (JREs), system-level performance optimizations, and native controller support into a single, reproducible, and portable package.

![MineCraft](minecrraft-nixos.jpg)

## Features

* **Prism Launcher**: A modern, open-source launcher for managing multiple Minecraft instances, modpacks, and accounts with high efficiency.
* **Unified Java Suite**: Pre-configured with OpenJDK 8, 17, and 21 (LTS). These are automatically injected into the launcher's environment for seamless version switching.
* **Feral GameMode Integration**: Automated CPU and GPU governor optimization to ensure the game receives maximum system priority during gameplay.
* **Advanced Controller Support**: Native SDL2 and libusb libraries are bundled and linked to support controllers via mods such as Controlify or MidnightControls.
* **MangoHud**: A comprehensive Vulkan and OpenGL overlay for real-time monitoring of FPS, frame timings, and hardware utilization.
* **Native Library Hardening**: Hardcoded paths for PulseAudio, Wayland, X11, and Vulkan to ensure stability across different Linux distributions and NixOS versions.
* **Desktop UX Integration**: Automatically creates a system application menu entry titled "Minecraft (DeMoD Optimized)" with high-resolution icons and pre-set execution paths.

## Usage

### Prerequisites

Ensure you have Nix installed with Flakes enabled. Your `nix.conf` or `~/.config/nix/nix.conf` should include:

```
experimental-features = nix-command flakes

```

### Running the Launcher

To launch the environment immediately without permanent installation:

```bash
nix run

```

### Installing to your System Profile

To make the launcher available in your application menu and system PATH permanently:

```bash
nix profile install .

```

### Configuration in Prism Launcher

For the best production experience, perform the following configuration steps upon the first launch:

1. **Java Setup**: Navigate to **Settings** > **Java**. Click the **Auto-detect** button. The launcher will automatically find the Nix-provided Java paths for versions 8, 17, and 21.
2. **Performance**: Navigate to **Settings** > **General**. Check the **Enable Feral GameMode** box.
3. **Controller Support**: Ensure you have installed a controller mod (like Controlify). Because SDL2 is injected via the flake, your controller should be recognized automatically.
4. **Overlay**: To use MangoHud, enter `mangohud` in the **Wrapper command** field within the specific instance settings.

## Hardware Permissions (NixOS Users)

For controller support to function correctly on NixOS, ensure your user has permission to access input devices. Add the following to your `/etc/nixos/configuration.nix`:

```nix
hardware.uinput.enable = true;
users.users.<your_username>.extraGroups = [ "input" ];

```

## License

Copyright (c) 2026 DeMoD LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
