```
╔═════════════════════════════════════════════════╗
║               __      __  _____ __              ║░
║          ____/ /___  / /_/ __(_) /__  _____     ║░
║         / __  / __ \/ __/ /_/ / / _ \/ ___/     ║░
║       _/ /_/ / /_/ / /_/ __/ / /  __(__  )      ║░
║      (_)__,_/\____/\__/_/ /_/_/\___/____/       ║░
║                                                 ║░
╚═════════════════════════════════════════════════╝░
 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
```

# plasticine flavoured dotfiles

Repeatable systems with Nix, Nix Darwin, and Home Manager.

## Installation

> [!NOTE]
> These steps assume that nix is already installed on the machine. If that’s not the case then go do that first!
>
> `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`

Perform the initial run of `nix-darwin`:

```shell
nix-shell -p just --run 'just install'
```

Subsequent rebuilds can be achieved using:

```shell
# Deploy new changes
just deploy

# Rollback to a previous generation
just rollback
```

## Useful references

- https://searchix.ovh/options/darwin/search
- https://searchix.ovh/options/home-manager/search
