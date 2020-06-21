typeset -U PATH path
path=("$HOME/.local/bin" "$HOME/.gem/ruby/2.6.0/bin" "$path[@]")
export PATH
export GOPATH="$HOME/codes/go"
export PATH="$GOPATH/bin:$PATH"
export ZSH="/home/neozumm/.oh-my-zsh"
export TERM="alacritty"
export MESA_LOADER_DRIVER_OVERRIDE="iris"
export BATTHEME="TwoDark"
export LESSOPEN="| $(which highlight) %s --out-format xterm256 --line-numbers --quiet --force --style pablo"
export LESS="-R --mouse --wheel-lines=5"
export EDITOR=nvim
export VISUAL=nvim
export LIBVA_DRIVER_NAME="iHD"
export XDG_CONFIG_HOME="$HOME/.config"    
export XDG_CACHE_HOME="$HOME/.cache"
export MAKEFLAGS="-j4"
export NNN_BMS="m:/mnt;h:~;a:~/.config/awesome;"
export NNN_PLUG="j:autojump;"

