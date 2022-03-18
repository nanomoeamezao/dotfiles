# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
fpath=(/usr/share/zsh/site-functions/ $fpath)
# Use manjaro zsh prompt
#if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#  source /usr/share/zsh/manjaro-zsh-prompt
#fi
alias sc='sudo systemctl'
alias scs='sudo systemctl start'
alias scst='sudo systemctl stop'
alias scr='sudo systemctl restart'
alias vim='nvim'
alias doom='~/.emacs.d/bin/doom'
alias docip='sudo docker inspect -f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias ssh='kitty +kitten ssh'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -U compinit colors zcalc
compinit -d
colors
#[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
eval "$(starship init zsh)"
