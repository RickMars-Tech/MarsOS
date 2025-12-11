<h1 align="center">Creating Custom Hosts</h1>
<p align="center"> 
Guide for creating new hosts and understanding the flake options
</p>

## Overview

To manage different hosts using the same configuration base, I've created several abstractions that simplify the system configuration process. All custom options are under the `config.mars` namespace to avoid conflicts with native NixOS configurations.

## Mars Options Reference

All options follow the `mars.<category>.<option>` structure. Below is a comprehensive reference:

### Boot Options (`mars.boot`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `secureBoot` | boolean | `false` | Enable Secure Boot using Lanzaboote |
| `plymouth` | boolean | `false` | Enable Plymouth boot splash screen |
| `kernel.version` | string | `"stable"` | Kernel version (`"stable"`, `"latest"`, `"zen"`, `"hardened"`) |

**Example:**
```nix
mars.boot = {
  secureBoot = true;
  plymouth = true;
  kernel.version = "latest";
};
```

---

### Security Options (`mars.security`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `doas` | boolean | `false` | Enable doas as sudo replacement |

**Example:**
```nix
mars.security.doas = true;
```

---

### Hardware Options

#### ASUS Specific (`mars.asus`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable ASUS-specific configurations |
| `battery.chargeUpto` | integer | `100` | Battery charge limit percentage (20-100) |

**Example:**
```nix
mars.asus = {
  enable = true;
  battery.chargeUpto = 80;
};
```

#### CPU Configuration (`mars.cpu`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `amd.enable` | boolean | `false` | Enable AMD CPU optimizations |
| `intel.enable` | boolean | `false` | Enable Intel CPU optimizations |

#### Laptop Optimizations (`mars.laptopOptimizations`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `laptopOptimizations` | boolean | `false` | Enable power management and laptop-specific tweaks |

---

### Graphics Options (`mars.graphics`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable graphics drivers |

#### AMD/RADEON (`mars.graphics.amd`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable AMD graphics drivers |
| `vulkan` | boolean | `false` | Enable Vulkan support |
| `opengl` | boolean | `false` | Enable OpenGL support |
| `compute.enable` | boolean | `false` | Enable ROCm for compute workloads |

#### NVIDIA Open Source (`mars.graphics.nvidiaFree`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable open-source NVIDIA drivers |

#### NVIDIA Proprietary (`mars.graphics.nvidiaPro`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable proprietary NVIDIA drivers |
| `nvenc` | boolean | `false` | Enable NVENC hardware encoding |
| `driver` | string | `"stable"` | Driver version (`"stable"`, `"beta"`, `"production"`) |
| `wayland-fixes` | boolean | `false` | Apply Wayland compatibility fixes |

#### NVIDIA Prime (`mars.graphics.nvidiaPro.prime`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable NVIDIA Prime for hybrid graphics |
| `igpu.vendor` | string | `null` | Integrated GPU vendor (`"amd"` or `"intel"`) |
| `igpu.port` | string | `null` | Integrated GPU PCI port (e.g., `"PCI:35:0:0"`) |
| `dgpu.port` | string | `null` | Discrete GPU PCI port (e.g., `"PCI:1:0:0"`) |

**Example:**
```nix
mars.graphics = {
  enable = true;
  amd = {
    enable = true;
    vulkan = true;
    opengl = true;
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

---

### Desktop Options (`mars.desktop`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `graphics` | boolean | `false` | Include graphics/creation tools (OBS, GIMP, etc.) |

---

### Development Options (`mars.dev`)

#### Git Configuration (`mars.dev.git`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Git with configuration |
| `username` | string | `null` | Git username |
| `email` | string | `null` | Git email |

#### Programming Languages (`mars.dev.languages`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `nix` | boolean | `false` | Enable Nix development tools |
| `python` | boolean | `false` | Enable Python development environment |
| `octave` | boolean | `false` | Enable GNU Octave |
| `rust` | boolean | `false` | Enable Rust toolchain |
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
  };
};
```

---

### Gaming Options (`mars.gaming`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable gaming packages and optimizations |
| `extra-gaming-packages` | boolean | `false` | Include additional gaming tools and emulators |

#### Gamemode (`mars.gaming.gamemode`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Feral GameMode |
| `amdOptimizations` | boolean | `false` | Enable AMD-specific optimizations |
| `nvidiaOptimizations` | boolean | `false` | Enable NVIDIA-specific optimizations |

#### Gamescope (`mars.gaming.gamescope`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Gamescope compositor |

#### Minecraft (`mars.gaming.minecraft`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `prismlauncher.enable` | boolean | `false` | Enable Prism Launcher |
| `extraJavaPackages.enable` | boolean | `false` | Include additional Java versions |

#### Steam (`mars.gaming.steam`)

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | `false` | Enable Steam |
| `openFirewall` | boolean | `false` | Open Steam ports in firewall |
| `hardware-rules` | boolean | `false` | Enable hardware-specific udev rules |

**Example:**
```nix
mars.gaming = {
  enable = true;
  gamemode = {
    enable = true;
    nvidiaOptimizations = true;
  };
  steam = {
    enable = true;
    hardware-rules = true;
  };
  minecraft.prismlauncher.enable = true;
};
```

---

## Creating a New Host

### Step 1: Create Host Directory
```bash
mkdir -p hosts/your-hostname
cd hosts/your-hostname
```

### Step 2: Create `disko.nix`

Define your disk layout using Disko. Example for a simple single-disk setup:
```nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";  # Adjust to your disk
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
```

### Step 3: Create `default.nix`
```nix
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  # Set your hostname
  networking.hostName = "your-hostname";

  # Configure Mars options
  mars = {
    # Add your configuration here
    boot.kernel.version = "latest";
    
    # Example: Desktop with AMD CPU and GPU
    cpu.amd.enable = true;
    graphics = {
      enable = true;
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
```

### Step 4: Add Host to Flake

Edit your `flake.nix` to include the new host:
```nix
nixosConfigurations = {
  your-hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ ./hosts/your-hostname ];
  };
};
```

### Step 5: Build and Deploy
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

---

## Example Configurations

### Desktop PC (AMD CPU + NVIDIA GPU)
```nix
mars = {
  cpu.amd.enable = true;
  graphics = {
    enable = true;
    nvidiaPro = {
      enable = true;
      driver = "stable";
      wayland-fixes = true;
    };
  };
  gaming.enable = true;
  desktop.graphics = true;
};
```

### Intel Laptop
```nix
mars = {
  laptopOptimizations = true;
  cpu.intel.enable = true;
  graphics = {
    enable = true;
    intel.enable = true;
  };
  dev.languages = {
    nix = true;
    python = true;
  };
};
```

---

## Tips

- Use `nix flake show` to see all available configurations
- Test configurations in a VM before deploying to hardware
- Check hardware compatibility before enabling specific drivers
- Start with minimal options and add features incrementally
