typeset -U PATH path
path=("$HOME/.local/bin" "$HOME/.config/composer/vendor/bin" "$HOME/.gem/ruby/2.6.0/bin" "$path[@]")
fpath=(/home/neozumm/.zsh-plugins/completions/src $fpath)
export PATH
export GOPATH="$HOME/codes/go"
export PATH="$GOPATH/bin:$PATH"
export ZSH="/home/neozumm/.oh-my-zsh"
export BATTHEME="TwoDark"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR=nvim
export VISUAL=nvim
export XDG_CONFIG_HOME="$HOME/.config"    
export XDG_CACHE_HOME="$HOME/.cache"
export MAKEFLAGS="-j4"
export TERM="xterm-kitty"
export TERMINFO="/usr/lib/kitty/terminfo"
