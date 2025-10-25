default:
  just --list

install:
    sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin/master#darwin-rebuild -- switch --flake .

deploy:
    sudo darwin-rebuild switch --flake .

rollback:
  sudo darwin-rebuild switch --rollback --flake .

repl:
    nix repl
