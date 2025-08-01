
install:
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME git
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME gnupg
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME jj
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME k9s
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME mise
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME postgres
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME ruby
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME zed
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME zsh
  @stow --verbose --ignore='.DS_Store' --restow --target $HOME ghostty
