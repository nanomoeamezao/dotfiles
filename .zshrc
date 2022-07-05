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
#
alias sc='sudo systemctl'
alias scs='sudo systemctl start'
alias scst='sudo systemctl stop'
alias scr='sudo systemctl restart'
alias vim='nvim'
alias doom='~/.emacs.d/bin/doom'
alias docip='sudo docker inspect -f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias ssh='kitty +kitten ssh'
alias la='exa -1la --icons'
alias ll='exa -1l --icons'
alias dockerpostlogs='sudo docker exec -w /var/lib/postgresql/data/pg_log postgres sh -c "ls -1r | head -n 1 | xargs tail -f -n 200"'
alias dockercppostconf='sudo docker cp /home/neo/code/testing_images/postgres/postgresql.conf postgres:/var/lib/postgresql/data/postgresql.conf && sudo docker restart postgres'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/git.plugin.zsh 
source ~/.zsh/docker.plugin.zsh
source ~/.zsh/docker-compose.plugin.zsh
autoload -U compinit colors zcalc
compinit -d
colors
#[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
