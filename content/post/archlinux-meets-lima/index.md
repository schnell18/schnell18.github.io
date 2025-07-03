---
title: 📈 Run an ArchLinux sandbox with Lima on MacOS
summary: This post explores how to run virtual machine work loads on MacOS efficiently with latest open-source virtualization software Lima.
date: 2025-07-02
authors:
  - admin
tags:
  - Lima
  - ArchLinux
  - Virtual Machine
---

## Background

MacBook is solid. Recently, I sold a ten years old 2013 MBP which works
smoothly without any glitch. I believe this is why MacBook laptops are a go-to
choice among developers: according to the [2024 Stack Overflow Developer
Survey](https://www.linkedin.com/pulse/why-software-developers-choose-macbooks-dimitar-stojkoski-d1nyf?utm_source=chatgpt.com),
**30.65% of professional developers report using macOS**.

Although being a firm MacBook supporter, I still need tinker with various Linux
distros from time to time. However, dual-boot with Linux is not particularly
feasible as 1) switching to Linux requires reboot, 2) Linux support of apple
hardware is problematic for quite a few Linux distros. This leads to the
virtualization solutions like Parallels, VMware. However, paying a hefty price
for occasional use is far from wise. Enters Lima.

## Overview

[Lima](https://github.com/lima-vm/lima) (short for *Linux Machines*) is a
lightweight virtual machine manager that enables you to run Linux virtual
machines on macOS with ease. It's designed to provide a developer-friendly
environment for container tooling, testing, and Linux workflows directly from
your macOS terminal. There are plenty of benefits of Lima, for example:

- Runs Linux VMs efficiently and seamlessly on macOS
- Easy provisioning with declarative YAML files
- Shares host file system and port forwarding
- Integrated with Docker and nerdctl

With Lima, we can

- Experiment with different Linux distributions in isolated environments
- Run container workloads with rootless Docker/nerdctl
- Develop cross-platform software
- Sandbox for package and software testing

Lima's declarative way to describe the virtual machine to build obviates the
need of dedicated tools like vagrant, or custom shell script. In this post,
I'll take advantage of this feature to build a recent ArchLinux with capability
to run GUI application, fast mirror for software download, enable AUR and yay
to install latest software conveniently.

## Define the ArchLinux VM

A LimaVM instance can be defined declaratively with a YAML configuration file.
To build the proposed ArchLinux VM, we need customize the YAML as follows:

- Specify CPU cores, memory capacity
- Specify the pre-built cloud image of ArchLinux
- Set fast mirror using system provision script
- Setup SSH and XWindow display using user provision script
- Setup AUR and yay using user provision script

Here’s the complete YAML for the ArchLinux VM to build:

```yaml

minimumLimaVersion: 1.1.0

cpus: 6
memory: 8GiB
mountType: virtiofs
networks:
  - vzNAT: true
rosetta:
  enabled: true
  binfmt: true
vmType: vz
base:
  - template://_default/mounts
images:
  - location: "https://geo.mirror.pkgbuild.com/images/v20250615.366044/Arch-Linux-x86_64-cloudimg-20250615.366044.qcow2"
    arch: "x86_64"
    digest: "sha256:a8fb36fd4a60ac606c99efd01f5ef959612d11748e8b686001b37e29411b00a4"

  # Fallback to the latest release image.
  # Hint: run `limactl prune` to invalidate the cache
  - location: https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
    arch: x86_64
provision:
  - mode: system
    script: |
      #!/bin/bash
      set -eux -o pipefail
      # Use New Zealand mirrors
      cat<<'EOF' > /etc/pacman.d/mirrorlist

      # New Zealand
      Server = https://mirror.fsmg.org.nz/archlinux/$repo/os/$arch
      Server = https://archlinux.ourhome.kiwi/$repo/os/$arch
      Server = https://nz.arch.niranjan.co/$repo/os/$arch
      Server = https://mirror.2degrees.nz/archlinux/$repo/os/$arch
      EOF
      pacman -Syyu --noconfirm --needed base-devel git
  # Install yay as normal user
  - mode: user
    script: |
      #!/bin/bash
      set -eux -o pipefail
      cd /tmp && \
      git clone https://aur.archlinux.org/yay.git && \
      cd yay && \
      makepkg --noconfirm -si && \
      cd && \
      rm -fr /tmp/yay
  # Setup XWindow and SSH
  - mode: user
    script: |
      #!/bin/bash
      set -eux -o pipefail
      if ! grep "User git" ~/.ssh/config; then
          HOST_USER=$(ls /Users)
          cat<<EOF >> ~/.ssh/config
      Host github.com
        User git
        Port 22
        StrictHostKeyChecking no
        PasswordAuthentication no
        IdentityFile /Users/$HOST_USER/.ssh/id_ed25519
      EOF
      fi

      if ! grep -e "^export DISPLAY=host.lima.internal:0" ~/.bashrc; then
          echo "export DISPLAY=host.lima.internal:0" >> ~/.bashrc
      fi
```


### Define the VM

The key parameters to define a VM include:

- **`cpus`**: Allocate CPU cores for the VM.
- **`memory`**: Allocate memory for the VM.
- **`images`**: Cloud image used to boot ArchLinux. The example YAML uses a recent ArchLinux cloud image

<!-- - **`provision`**: Scripts run automatically after the VM is created, used to set up fast mirrors, install AUR helper, and configure GUI support. -->
<!---->

### Enable Fast Mirrors

ArchLinux has plenty of mirrors to accelerate software download globally. The
first system provision script in the example YAML: specifies the mirrors like
explicitly as follows:

```sh
# Use New Zealand mirrors
cat<<'EOF' > /etc/pacman.d/mirrorlist

# New Zealand
Server = https://mirror.fsmg.org.nz/archlinux/$repo/os/$arch
Server = https://archlinux.ourhome.kiwi/$repo/os/$arch
Server = https://nz.arch.niranjan.co/$repo/os/$arch
Server = https://mirror.2degrees.nz/archlinux/$repo/os/$arch
EOF
pacman -Syyu --noconfirm --needed base-devel git
```
This script sets up the fast mirrors for user in New Zealand.
Alternatively, you can discover the nearest mirror list by running:

```sh
pacman -Sy --noconfirm reflector
reflector --country New_Zealand --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
```

### Share Host SSH Keys

By default, Lima mounts the your home directory under the `/Users` directory
inside the VM. The second user provision script in the previous YAML
setup the SSH keys sharing as follows:

```sh
      if ! grep "User git" ~/.ssh/config; then
          HOST_USER=$(ls /Users)
          cat<<EOF >> ~/.ssh/config
      Host github.com
        User git
        Port 22
        StrictHostKeyChecking no
        PasswordAuthentication no
        IdentityFile /Users/$HOST_USER/.ssh/id_ed25519
      EOF
      fi
```

This avoids duplicating the SSH keys in the ArchLinux VM. However, don't share
your sensitive private SSH key like this when the applications running inside
the VM can't be trusted.

{{% callout warning %}}
> **Security Alert**: Sharing your private SSH key poses a risk if the VM
> runs untrusted applications. Consider generating a dedicated SSH key for VM
> usage with limited access.
{{% /callout %}}

### Setup GUI Applications using X Window

Even though LimaVM runs headlessly, you can still run GUI apps by pointing the
DISPLAY to MacOS. The second user provision script sets up the DISPLAY
environment variable as follows:

   ```sh
   if ! grep -e "^export DISPLAY=host.lima.internal:0" ~/.bashrc; then
       echo "export DISPLAY=host.lima.internal:0" >> ~/.bashrc
   fi
   ```

By this way, the DISPLAY environment variable is automatically exported when
user logs in. The special hostname `host.lima.internal` is a Lima specific way
to refer to the host.

#### MacOS Setup

MacOS doesn't come with compatible X Window server out-of-box. The XQuartz
package is a good X Window server to use.

1. **Install XQuartz on macOS**

   Download and install from [https://www.xquartz.org/](https://www.xquartz.org/).
   Or simply using Homebrew as:

   ```sh
   brew install xquartz
   ```

2. **Enable Connections**

   Open XQuartz preferences:

   - Go to *Security*
   - Check **Allow connections from network clients**
   - Quit XQuartz

3. **Allow VM Access**

   Restart XQuartz and launch xterm and type:

   ```sh
   xhost + 127.0.0.1
   ```


### Enable AUR and Install `yay`

The [Arch User Repository (AUR)](https://aur.archlinux.org/) is a
community-driven repository for Arch users, containing thousands of
user-contributed packages. [`yay`](https://github.com/Jguer/yay) is a popular
AUR helper that simplifies searching and installing AUR packages.
The two components must be set up properly in order to install latest software
conveniently.

The previous example YAML's first user provision script sets up AUR and yay as
follows:

```sh
cd /tmp && \
      git clone https://aur.archlinux.org/yay.git && \
      cd yay && \
      makepkg --noconfirm -si && \
      cd && \
      rm -fr /tmp/yay
```

## Launch and Validate

### Launch the ArchLinux VM

First, make sure Lima is installed, otherwise install it with Homebrew:

```sh
brew install lima

```
Then you launch the ArchLinux defined in previous YAML as follows:

```sh
limactl start archlinux.yaml

```

It takes a while to download the cloud image, create the vm and startup for the
first time.

### Validate the ArchLinux VM

Once the ArchLinux is fully started, you can connect to it as follows:

```sh
limactl shell archlinux
```

#### Test X Window Setup

In the shell to the ArchLinux VM, install the `xeyes` package as follows:

```sh
sudo pacmac -Sy xorg-xeyes

```

Now you can test if X Window works properly by running `xeyes` inside the VM
like:

```sh
xeyes &
```
You should be able to see the eyes on MacOS screen.


## Conclusion

Running ArchLinux inside LimaVM provides a powerful and flexible development
sandbox directly on macOS. With the ability to share SSH keys, run GUI
applications via XQuartz, leverage fast mirrors, and access AUR packages using
yay, it becomes a practical tool for developers looking to experiment with
Linux environments efficiently and safely.

For complete example source and launching script, visit the [Lima ArchLinux VM
example](https://github.com/schnell18/vCluster/tree/master/lima/archlinux). For
more information about Lima, visit the [LimaVM GitHub
repo](https://github.com/lima-vm/lima).
