# Use powerline
#USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
fpath=(/usr/share/zsh/site-functions/ $fpath)
fpath=(~/.zsh $fpath)
# Use manjaro zsh prompt
#if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#  source /usr/share/zsh/manjaro-zsh-prompt
#fi
#
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/git.plugin.zsh 
source ~/.zsh/docker.plugin.zsh
source ~/.zsh/docker-compose.plugin.zsh
autoload -U compinit colors zcalc
compinit -d
colors
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

alias sc='sudo systemctl'
alias scs='sudo systemctl start'
alias scst='sudo systemctl stop'
alias scr='sudo systemctl restart'
alias vim='nvim'
alias podman='sudo podman'
alias doom='~/.emacs.d/bin/doom'
alias docip='sudo docker inspect -f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias ssh='kitty +kitten ssh'
alias la='exa -1la --icons'
alias ll='exa -1l --icons'
alias gdsp="git diff origin/sprint -- . ':^gen' ':^server/models'"
alias dockerpostlogs='sudo docker exec -w /var/lib/postgresql/data/pg_log postgres sh -c "ls -1r | head -n 1 | xargs tail -f -n 200"'
alias dockercppostconf='sudo docker cp /home/neo/code/testing_images/postgres/postgresql.conf postgres:/var/lib/postgresql/data/postgresql.conf && sudo docker restart postgres'
alias gco='fzf-git-checkout'

