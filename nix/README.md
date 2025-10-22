# Nix Dotfiles

Repeatable machines with Nix, Nix Darwin, and Home Manager.

## Installation

> [!NOTE]
> These steps assume that nix is already installed on the machine. If that’s not the case then go do that first!

Perform the initial run of `nix-darwin`

```shell
sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
```

Subsequent rebuilds can be achieved using:

```shell
sudo darwin-rebuild switch --flake ~/.config/nix
```


## Useful Stuff

Get the hostname. Useful for inserting into the flake for targetting a particular machine.

```shell
scutil --get LocalHostName
```
