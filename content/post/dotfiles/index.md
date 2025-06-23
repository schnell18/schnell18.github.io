---
title:  📈 Level up your dotfiles with scripting
summary: Already using dotfiles? Still have trouble to replicate favorite development tools to another computer at ease? This post introduce an automated tool installation and setup by leverage shell scripting

date: 2025-05-27

# Featured image
# Place an image named `featured.jpg/png` in this page's folder and customize its options here.
image:

  caption: 'Image credit: [**Daniel Stoddart**](https://stoddart.github.io/)'

authors:
  - admin

tags:
  - dotfiles
  - neovim
  - tmux
  - bash
---

{{< toc mobile_only=true is_open=true >}}

## Background

The dotfiles scheme is a method for managing configuration files and settings
across Unix-like systems by storing them in a version-controlled repository and
using symbolic links or scripts to deploy them to their proper locations. The
name "dotfiles" comes from Unix convention where configuration files typically
begin with a dot (period), making them hidden by default in directory listings.
These files control everything from shell behavior (.bashrc, .zshrc) to text
editor settings (.config/nvim) to application preferences. As users accumulate
personalized configurations across multiple machines, managing these files
becomes increasingly complex. The dotfiles approach addresses this problem by
enable users to:

- Synchronize configurations across multiple computers or opererating systems
- Version control configuration changes
- Backup important settings
- Try new settings with peace of mind
- Share configurations with others
- Quickly set up new development environments

## The gaps

The modern tools tend to update increasingly faster. Take text editor as an
example, the vanilla Vim releases roughly every 2-3 years. In contrast, neovim
updates every 6-12 months. This means the OS and distros could hardly
bundle latest neovim. This shifts the responsibility of installing latest tool
to end user. The dotfiles scheme manages static configuration files very well,
however, it lacks unified method to install software with diverse technology
stacks and runtime dependencies.

## A Solution

This post explores a solution by leveraging shell scripting as the bash and
PowerShell are the predominent scripting language for Unix-like OS and Windows
respectively. The installation of tool and its setup are unified. The proposed
solution is implemented in this [dotfiles][2] project, which automates common
development tools installation and configuration under MacOS and Linux
(currently only Ubuntu and Arch are supported) by leveraging [stow][1]. The
general procedure to setup a supported tool is:

- clone the [dotfiles][2] project
- change directory to `~/dotfiles` or whatever you see fit
- run `./setup.sh TOOL_NAME`

Here is the sequence of commands for your reference:

    cd $HOME
    git clone https://github.com/schnell18/dotfiles.git
    cd dotfiles
    ./setup.sh zsh

The `setup.sh` script automates the installation of the tool, its dependencies
and configure it using the preset configuration file.
To setup golang, git, lua, tmux, nvim in one go:

    cd dotfiles
    ./setup.sh golang git lua tmux nvim

To list the supported tools:

    cd dotfiles
    grep -e "^function setup_" setup.sh | cut -d' ' -f2 | cut -d'_' -f2

## Conclusion

The scripting approach is a viable solution for user are familiar with shell
scripting. It also eases integration of new tools. However, for user requires
Windows compatibility, it might be necessary to pick up the PowerShell
scripting. Neverless, it won't be extremely difficult since AI is everywhere.


[1]: https://www.gnu.org/software/stow/
[2]: https://github.com/schnell18/dotfiles
