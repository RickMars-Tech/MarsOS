<h1 align="center">Creating Custom Hosts</h1>
<p align="center"> 
Step-by-step guide for creating new hosts in MarsOS
</p>

[← Back to Main README](../README.md) | [View Configuration Options →](./config.md)

---

## Overview

MarsOS uses a modular approach to manage different hosts (machines) using the same configuration base. Each host has its own directory under `hosts/` with specific hardware and system configurations.

## Creating a New Host

### Step 1: Create Host Directory
```bash
mkdir -p hosts/your-hostname
cd hosts/your-hostname
```

### Step 2: Create `disko.nix`

Define your disk layout using Disko. Here are some common examples:

#### Simple Single-Disk Setup (ext4)
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

#### Setup with Swap Partition
```nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
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
            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
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

> **Tip:** Use `lsblk` to identify your disk devices before configuring Disko.

### Step 3: Create `default.nix`

This is your main host configuration file:
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
    # Boot configuration
    boot = {
      kernel.version = "latest";
      plymouth = true;
    };

    # Hardware configuration
    cpu.amd.enable = true;  # or cpu.intel.enable = true
    
    graphics = {
      enable = true;
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
      };
    };

    # Optional: Gaming
    gaming.enable = true;

    # Optional: Development tools
    dev = {
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
  };

  system.stateVersion = "25.11";
}
```

### Step 4: Add Host to Flake

Your host will be automatically detected! The `flake.nix` is configured to automatically include all hosts defined in the `hosts` attribute set.

To add your new host, edit `flake.nix` and add it to the `hosts` set:
```nix
# Define hosts
hosts = {
  boltz = [];
  rift = [];
  crest = [];
  your-hostname = [];  # Add your new host here
};
```

If you need extra modules specific to your host, you can add them:
```nix
hosts = {
  your-hostname = [
    # Add extra modules here if needed
    # ./path/to/extra-module.nix
  ];
};
```

### Step 5: Build and Deploy
```bash
# From the MarsOS directory
sudo nixos-rebuild switch --flake .#your-hostname
```

Or during installation:
```bash
sudo nixos-install --flake /mnt/etc/nixos/MarsOS#your-hostname
```

---

## Example Host Configurations

### Desktop PC (AMD CPU + NVIDIA GPU)
```nix
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "gaming-desktop";

  mars = {
    boot = {
      kernel.version = "latest";
      plymouth = true;
    };

    cpu.amd.enable = true;
    
    graphics = {
      enable = true;
      nvidiaPro = {
        enable = true;
        driver = "stable";
        nvenc = true;
        wayland-fixes = true;
      };
    };

    gaming = {
      enable = true;
      gamemode = {
        enable = true;
        nvidiaOptimizations = true;
      };
      steam.enable = true;
      gamescope.enable = true;
    };

    desktop.graphics = true;
  };

  system.stateVersion = "25.11";
}
```

### Intel Laptop
```nix
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "work-laptop";

  mars = {
    boot = {
      kernel.version = "stable";
      plymouth = true;
    };

    laptopOptimizations = true;
    cpu.intel.enable = true;
    
    graphics = {
      enable = true;
      intel.enable = true;
    };

    dev = {
      git = {
        enable = true;
        username = "developer";
        email = "dev@example.com";
      };
      languages = {
        nix = true;
        python = true;
        rust = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
```

### ASUS Laptop (Hybrid Graphics)
```nix
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "asus-laptop";

  mars = {
    boot = {
      secureBoot = true;
      plymouth = true;
      kernel.version = "latest";
    };

    security.doas = true;

    asus = {
      enable = true;
      battery.chargeUpto = 80;
    };

    laptopOptimizations = true;
    cpu.amd.enable = true;

    graphics = {
      enable = true;
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
      };
      nvidiaPro = {
        enable = true;
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

    gaming = {
      enable = true;
      gamemode = {
        enable = true;
        nvidiaOptimizations = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
```

---

## Tips & Best Practices

- **Use descriptive hostnames:** Choose names that indicate the machine type or purpose
- **Test in a VM first:** Before deploying to hardware, test your configuration in a virtual machine
- **Check hardware compatibility:** Verify your hardware is supported before enabling specific drivers
- **Start minimal:** Begin with basic options and add features incrementally
- **Use `nix flake show`:** See all available configurations with this command
- **Keep backups:** Always maintain backups of important data before reformatting
- **Document custom settings:** Add comments to explain non-obvious configuration choices

## Finding Hardware Information
```bash
# List all PCI devices (for GPU ports)
lspci | grep -E "VGA|3D"

# Check CPU information
lscpu

# List block devices (for disk configuration)
lsblk

# Check network devices
ip link show
```

---

## Troubleshooting

### Host Not Found

If `nixos-rebuild` can't find your host:
1. Verify the hostname in `hosts` attribute set in `flake.nix`
2. Ensure `default.nix` exists in `hosts/your-hostname/`
3. Check for syntax errors with `nix flake check`

### Disko Errors

If Disko fails during installation:
1. Verify disk paths with `lsblk`
2. Check partition sizes add up correctly
3. Ensure disk device is not mounted

### Graphics Issues

If graphics don't work properly:
1. Verify PCI ports with `lspci`
2. Check kernel messages with `dmesg | grep -i gpu`
3. Try different driver versions
4. Check [Configuration Options](./config.md) for driver-specific settings

---

[← Back to Main README](../README.md) | [View Configuration Options →](./config.md)
