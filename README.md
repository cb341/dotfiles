# dotfiles

This is a collection of my dotfiles for my personal development setup.
Other than the dotfiles, I also have a few scripts that I use to automate some tasks.

## Docker Setup

Run the complete development environment in a container:

```bash
docker compose up -d
docker compose exec dotfiles zsh
```

## Configuration

- [Alacritty](./.config/alacritty/alacritty.toml)
- [Nvim](./.config/nvim/)
- [Lazygit](./lazygit/config.yml)
- [Tmux](./.tmux.conf)
- [Zsh profile](./.zshrc)
- [Utility Scripts](./scripts/)
- [NixOS Configuration](./nixos/configuration.nix)
- [NixOS Hardware Configuration](./nixos/hardware-configuration.nix)
- [Hyprland Configuration](./.config/hypr/hyprland.conf)

## License

The source files in this repository is licensed under the MIT license. See [LICENSE](./LICENSE) for more information.

