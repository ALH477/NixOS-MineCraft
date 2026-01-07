# Minecraft Optimized Environment

This repository provides a professional-grade Nix flake for a performance-optimized Minecraft environment using the Prism Launcher. It bundles multiple Java Runtime Environments (JREs) and system-level performance optimizations into a single, reproducible package.

## Features

* **Prism Launcher**: A modern, open-source launcher for managing multiple Minecraft instances and modpacks.
* **Multi-Java Suite**: Pre-configured with OpenJDK 8, 17, and 21 to support all versions of Minecraft from alpha to the latest releases.
* **Feral GameMode Integration**: Automated CPU and GPU governor optimization for reduced latency.
* **MangoHud**: Performance overlay for monitoring real-time FPS, frame timings, and hardware temperatures.
* **Native Library Hardening**: Hardcoded paths for PulseAudio, Wayland, X11, and Vulkan to ensure stability on NixOS.

## Usage

### Prerequisites

Ensure you have Nix installed with Flakes enabled. Your `nix.conf` should include:

```
experimental-features = nix-command flakes

```

### Running the Launcher

To launch the environment immediately without permanent installation:

```bash
nix run

```

### Installing to Profile

To make the launcher available globally in your application menu and system path:

```bash
nix profile install .

```

### Configuration in Prism Launcher

After starting the launcher, perform these steps for optimal performance:

1. **Java Setup**: Navigate to Settings -> Java. Click "Auto-detect" to find the Nix-provided Java paths for versions 8, 17, and 21.
2. **Performance**: Navigate to Settings -> General. Enable the "Feral GameMode" checkbox.
3. **Overlay**: To use MangoHud, enter `mangohud` in the "Wrapper command" field within the instance settings.

## License

Copyright (c) 2026 DeMoD LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
