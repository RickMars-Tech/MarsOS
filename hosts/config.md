<h1 align="center">Mars Configuration Options</h1>
<p align="center"> 
Complete reference for all Mars modules and configuration options
</p>

[← Back to Creating Hosts](./host.md) | [Back to Main README](../README.md)

---

## Overview

All custom options are under the `config.mars` namespace to avoid conflicts with native NixOS configurations. This reference documents all available Mars modules.

## DISCLAIMER

This documentation is a work in progress. New Mars modules and options are being added regularly. Check back for updates or contribute by opening an issue or pull request.

---

## Table of Contents

- [Boot Options](#boot-options-marsboot)
- [Security Options](#security-options-marssecurity)
- [Hardware Options](#hardware-options-marshardware)
  - [ASUS Specific](#asus-specific-marshardwareasus)
  - [CPU Configuration](#cpu-configuration-marshardwarecpu)
  - [Laptop Optimizations](#laptop-optimizations-marshardwarelaptopoptimizations)
- [Graphics Options](#graphics-options-marshardwaregraphics)
  - [AMD/RADEON](#amdradeon-marshardwaregraphicsamd)
  - [NVIDIA Open Source](#nvidia-open-source-marshardwaregraphicsnvidiafree)
  - [NVIDIA Proprietary](#nvidia-proprietary-marshardwaregraphicsnvidiapro)
  - [NVIDIA Prime](#nvidia-prime-marshardwaregraphicsnvidiaproprime)
- [Shell Options](#shell-options-marsshell)
- [Desktop Options](#desktop-options-marsdesktop)
- [Development Options](#development-options-marsdev)
- [Gaming Options](#gaming-options-marsgaming)

---

## Boot Options (`mars.boot`)

Control boot-related configurations including secure boot, boot splash, and kernel selection.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `secureBoot` | boolean | `false` | Enable Secure Boot using Lanzaboote |
| `plymouth` | boolean | `false` | Enable Plymouth boot splash screen |
| `kernel.version` | string | `"stable"` | Kernel version (`"stable"`, `"latest"`, `"rc"`) |

**Example:**
```nix
mars.boot = {
  secureBoot = true;
  plymouth = true;
  kernel.version = "latest";
};
```

---

## Security Options (`mars.security`)

Configure system security tools and sudo replacements.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `doas` | boolean | `false` | Enable doas as sudo replacement |
| `sudo-rs` | boolean | `false` | Enable Sudo-RS as traditional sudo replacement |

**Example:**
```nix
mars.security.doas = true;
```

> **Note:** Only enable one of `doas` or `sudo-rs`, not both.

---

## Hardware Options (`mars.hardware`)

### ASUS Specific (`mars.hardware.asus`)

ASUS laptop-specific configurations and optimizations.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable ASUS-specific configurations |
| `battery.chargeUpto` | integer | `100` | Battery charge limit percentage (20-100) |
| `battery.enableChargeUptoScript` | boolean | `true` | Script to temporarily set the charge limit |

**Example:**
```nix
mars.hardware.asus = {
  enable = true;
  battery.chargeUpto = 80;
};
```

> **Tip:** Setting charge limit to 80% can significantly extend battery lifespan.

### CPU Configuration (`mars.hardware.cpu`)

CPU vendor-specific optimizations.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `amd.enable` | boolean | `false` | Enable AMD CPU optimizations |
| `intel.enable` | boolean | `false` | Enable Intel CPU optimizations |

**Example:**
```nix
mars.hardware.cpu.amd.enable = true;
```

> **Note:** Only enable the option matching your CPU vendor.

### Laptop Optimizations (`mars.hardware.laptopOptimizations`)

Power management and laptop-specific tweaks.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `laptopOptimizations` | boolean | `false` | Enable power management and laptop-specific tweaks |

**Example:**
```nix
mars.hardware.laptopOptimizations = true;
```

> **Includes:** TLP, auto-cpufreq, powertop optimizations, and laptop-mode-tools.

---

## Graphics Options (`mars.hardware.graphics`)

Configure graphics drivers and GPU-specific settings.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable graphics drivers |

### AMD/RADEON (`mars.hardware.graphics.amd`)

AMD/RADEON graphics driver configuration.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable AMD graphics drivers |
| `compute.enable` | boolean | `false` | Enable compute/AI optimizations |
| `compute.rocm` | boolean | `false` | Enable ROCm platform support |
| `compute.openCL` | boolean | `false` | Enable OpenCL support |
| `compute.hip` | boolean | `false` | Enable HIP runtime support |

**Example:**
```nix
mars.hardware.graphics = {
  enable = true;
  amd = {
    enable = true;
    compute.enable = false;  # Enable for machine learning/compute
  };
};
```

### NVIDIA Open Source (`mars.hardware.graphics.nvidiaFree`)

Open-source NVIDIA driver (Nouveau).

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable open-source NVIDIA drivers |

**Example:**
```nix
mars.hardware.graphics = {
  enable = true;
  nvidiaFree.enable = true;
};
```

> **Note:** Performance is generally lower than proprietary drivers.

### NVIDIA Proprietary (`mars.hardware.graphics.nvidiaPro`)

Proprietary NVIDIA driver configuration.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable proprietary NVIDIA drivers |
| `nvenc` | boolean | `false` | Enable NVENC hardware encoding |
| `driver` | string | `"stable"` | Driver version (`"stable"`, `"latest"`, `"beta"`, `"production"`, `"legacy_470"`, `"legacy_390"`) |
| `wayland-fixes` | boolean | `false` | Apply Wayland compatibility fixes |

**Example:**
```nix
mars.hardware.graphics = {
  enable = true;
  nvidiaPro = {
    enable = true;
    nvenc = true;
    driver = "beta";
    wayland-fixes = true;
  };
};
```

### NVIDIA Prime (`mars.hardware.graphics.nvidiaPro.prime`)

NVIDIA Prime configuration for hybrid graphics (laptops with iGPU + dGPU).

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable NVIDIA Prime for hybrid graphics |
| `igpu.vendor` | string | `null` | Integrated GPU vendor (`"amd"` or `"intel"`) |
| `igpu.port` | string | `null` | Integrated GPU PCI port (e.g., `"PCI:35:0:0"`) |
| `dgpu.port` | string | `null` | Discrete GPU PCI port (e.g., `"PCI:1:0:0"`) |

**Example:**
```nix
mars.hardware.graphics = {
  enable = true;
  amd = {
    enable = true;
  };
  nvidiaPro = {
    enable = true;
    nvenc = true;
    driver = "beta";
    prime = {
      enable = true;
      igpu = {
        vendor = "amd";
        port = "PCI:35:0:0";
      };
      dgpu.port = "PCI:1:0:0";
    };
    wayland-fixes = true;
  };
};
```

> **Finding PCI Ports:** Use `lspci | grep -E "VGA|3D"` to identify your GPU PCI addresses.

**Example Output:**
```
01:00.0 VGA compatible controller: NVIDIA Corporation ...
35:00.0 VGA compatible controller: Advanced Micro Devices ...
```
Convert `01:00.0` to `PCI:1:0:0` and `35:00.0` to `PCI:35:0:0`.

---

## Desktop Options (`mars.desktop`)

Desktop environment and productivity tools.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `graphics` | boolean | `false` | Include graphics/creation tools (OBS, GIMP, Inkscape, etc.) |

**Example:**
```nix
mars.desktop.graphics = true;
```

---

## Shell Options (`mars.shell`)

Shell configuration options.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `bash` | boolean | `true` | Enable Bash as the default shell |
| `fish` | boolean | `false` | Enable Fish shell (overrides bash if enabled) |

**Example:**
```nix
mars.shell.fish = true;
```

---

## Development Options (`mars.dev`)

Development tools and programming language environments.

### Git Configuration (`mars.dev.git`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Git with configuration |
| `username` | string | `null` | Git username |
| `email` | string | `null` | Git email |

### Programming Languages (`mars.dev.languages`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `nix` | boolean | `false` | Enable Nix development tools (nixfmt, nil, etc.) |
| `python` | boolean | `false` | Enable Python development environment |
| `octave` | boolean | `false` | Enable GNU Octave (MATLAB alternative) |
| `rust` | boolean | `false` | Enable Rust toolchain (rustc, cargo, etc.) |
| `javascript` | boolean | `false` | Enable Node.js and npm |

**Example:**
```nix
mars.dev = {
  git = {
    enable = true;
    username = "YourUsername";
    email = "your.email@example.com";
  };
  languages = {
    nix = true;
    python = true;
    rust = true;
  };
};
```

---

## Gaming Options (`mars.gaming`)

Gaming-related packages and optimizations with automatic performance tuning.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable gaming packages and optimizations |
| `extra-gaming-packages` | boolean | `false` | Include additional gaming tools and emulators |

### Gaming Performance Optimizations

When `mars.gaming.enable = true`, the following optimizations are automatically applied:

**Environment Variables:**
- `DXVK_STATE_CACHE = "1"` - Enables shader caching for Proton/Wine games
- `DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk"` - Shader cache location
- `DXVK_HUD = "compiler"` - Shows shader compilation info
- `__GL_THREADED_OPTIMIZATIONS = "1"` - Multi-threaded OpenGL rendering
- `__GL_SHADER_DISK_CACHE = "1"` - OpenGL shader disk cache
- `RADV_PERFTEST = "gpl,nggc,sam"` - AMD experimental features (when AMD GPU enabled)

**Included Packages:**
- **MangoHUD** - Performance overlay (FPS, temps, GPU/CPU usage)
- **GOverlay** - GUI for MangoHUD configuration
- **libstrangle** - Frame rate limiter
- **lm_sensors** - Hardware monitoring
- **vkBasalt** - Vulkan post-processing (sharpening, CAS, color correction)

**Kernel Optimizations (when gaming enabled):**
- `tsc=reliable` - Faster timekeeping
- `clocksource=tsc` - Use TSC for timing
- `preempt=full` - Full preemption for lower latency
- Additional sysctl tuning from CachyOS

### Gamemode (`mars.gaming.gamemode`)

Feral GameMode for performance optimization during gaming.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Feral GameMode |
| `amdOptimizations` | boolean | `false` | Enable AMD-specific optimizations |
| `nvidiaOptimizations` | boolean | `false` | Enable NVIDIA-specific optimizations |

**What GameMode Does:**
- Sets CPU governor to `performance` for maximum clock speeds
- Increases I/O priority to 0 (highest) for game processes
- Manages integrated GPU power balance intelligently
- Applies GPU-specific optimizations (AMD/NVIDIA)
- Optional ASUS laptop profile switching (Performance mode)

**Example:**
```nix
mars.gaming.gamemode = {
  enable = true;
  nvidiaOptimizations = true;  # or amdOptimizations
};
```

> **Note:** GameMode also includes automatic renice (priority 10), screensaver inhibit, and split-lock mitigation disable.

### Gamescope (`mars.gaming.gamescope`)

Micro-compositor for gaming with built-in frame limiting and scaling.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Gamescope compositor |

**Features:**
- MangoHUD integration via `--mangoapp`
- Vulkan rendering preferred over OpenGL
- Realtime scheduling for reduced input latency
- Wayland client support
- Optional adaptive sync (VRR/FreeSync)

**Usage:**
```bash
# Launch a game through Gamescope
gamescope -W 1920 -H 1080 -r 144 -- game_executable

# In Steam, add to launch options:
gamescope -f -- %command%
```

**Example:**
```nix
mars.gaming.gamescope.enable = true;
```

### Minecraft (`mars.gaming.minecraft`)

Minecraft launcher and Java configurations.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `prismlauncher.enable` | boolean | `false` | Enable Prism Launcher |
| `extraJavaPackages.enable` | boolean | `false` | Include additional Java versions (8, 17, 21) |

### Steam (`mars.gaming.steam`)

Valve Steam gaming platform.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Steam |
| `openFirewall` | boolean | `false` | Open Steam ports in firewall |
| `hardware-rules` | boolean | `false` | Enable hardware-specific udev rules (controllers, VR) |

**Complete Gaming Example:**
```nix
mars.gaming = {
  enable = true;
  extra-gaming-packages = true;
  
  gamemode = {
    enable = true;
    nvidiaOptimizations = true;
  };
  
  gamescope.enable = true;
  
  steam = {
    enable = true;
    openFirewall = true;
    hardware-rules = true;
  };
  
  minecraft = {
    prismlauncher.enable = true;
    extraJavaPackages.enable = true;
  };
};
```

---

## Complete Configuration Example

Here's a complete example combining multiple Mars modules:
```nix
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "mars-workstation";

  mars = {
    # Boot
    boot = {
      secureBoot = true;
      plymouth = true;
      kernel.version = "latest";
    };

    # Security
    security.doas = true;

    # Hardware
    hardware = {
      rootSSD = true;
      cpu.amd.enable = true;
      graphics = {
        enable = true;
        amd = {
          enable = true;
        };
        nvidiaPro = {
          enable = true;
          nvenc = true;
          driver = "stable";
          prime = {
            enable = true;
            igpu = {
              vendor = "amd";
              port = "PCI:35:0:0";
            };
            dgpu.port = "PCI:1:0:0";
          };
          wayland-fixes = true;
        };
      };
    };

    # Shell
    shell.fish = true;

    # Desktop
    desktop.graphics = true;

    # Development
    dev = {
      git = {
        enable = true;
        username = "developer";
        email = "dev@example.com";
      };
      languages = {
        nix = true;
        python = true;
      };
    };

    # Gaming
    gaming = {
      enable = true;
      gamemode = {
        enable = true;
        nvidiaOptimizations = true;
      };
      gamescope.enable = true;
      steam = {
        enable = true;
        hardware-rules = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
```

---

[← Back to Creating Hosts](./host.md) | [Back to Main README](../README.md)
