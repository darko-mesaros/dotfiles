# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh"
# CURRENT zshrc REQUIREMENTS:
# exa
# bashmount
# fzf
# END REQUIREMENTS
autoload -U colors && colors
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# set this up for version control information (git branch)
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats " %F{blue}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats " %F{blue}%c%u(%b)%f %a"
zstyle ':vcs_info:*' stagedstr "%F{green}"
zstyle ':vcs_info:*' unstagedstr "%F{red}"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked() {
  if git --no-optional-locks status --porcelain 2> /dev/null | grep -q "^??"; then
    hook_com[staged]+="%F{red}"
  fi
}

# editor
export EDITOR="nvim"
export READER="zathura"

# path
export PATH="$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"

# prompt
# checks the hostname and sets the colors
case ${(%):-%m} in
  bessie)
    host_color=$fg[green]
    user_color=$fg[cyan]
    ;;
  devbox)
    host_color=$fg[blue]
    user_color=$fg[red]
    ;;
  jugoplastika)
    host_color=$fg[magenta]
    user_color=$fg[green]
    ;;
  *)
    host_color=$fg[white]
    user_color=$fg[yellow]
    ;;
esac

setopt PROMPT_SUBST
PROMPT="%{$user_color%}%n%{$reset_color%}@%{$host_color%}%m %{$reset_color%}[%{$fg[yellow]%}%~%{$reset_color%}]: "
# righthand promt (git info be here)
RPROMPT='$vcs_info_msg_0_'

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/darko/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(direnv hook zsh)"

# ALIASES

## Utilities
alias ll="eza -l --git"
alias l="eza -la --git"
alias bm="bashmount"
alias wget="aria2c -x 16 -s 16"
alias vim="nvim"
alias k="kubectl"
alias c="clear && pwd && ll"
alias cd="z"
alias cdi="zi"
alias zshedit="vim /home/darko/.zshrc"
alias cggpg="gpg --quiet --decrypt /home/darko/workspace/keys/chatgpt.txt.gpg > /dev/null"

# PROJECT 1999
#alias dec2='aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:aws:cloudformation:stack-name,Values=VisualVortex99Stack" --query "Reservations[].Instances[].[InstanceId, PublicIpAddress]"'
#alias vv99dl='aws s3 sync s3://visualvortex99-webassets/ .'
#alias vv99up='aws s3 sync . s3://visualvortex99-webassets/'
#alias vvconnect="aws ssm start-session --target $(sed 's/^"//' <<< $(dec2 | jq '.[0][0]') | sed 's/"$//')"
#alias vvtest="curl $(sed 's/^"//' <<< $(dec2 | jq '.[0][1]') | sed 's/"$//')"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## Needs Figlet and lolcat
function lolbanner {
  figlet -c -f ~/.local/share/fonts/figlet-fonts/ANSI\ Shadow.flf $@ | lolcat
}

## Needs BAT
function cht {
  curl cheat.sh/$@ | bat
}

# PYENV
#export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#source /usr/share/nvm/init-nvm.sh

### NNN
export NNN_USE_EDITOR=1
export NNN_BMS='h:~;c:~/.config;r:~/workspace/repos;w:~/workspace'
#### NNN COLORS
BLK="04"
CHR="04"
DIR="e4"
EXE="00"
REG="00"
HARDLINK="00"
SYMLINK="06"
MISSING="00"
ORPHAN="01"
FIFO="0F"
SOCK="0F"
OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_PLUG='p:preview-tui'

alias nnn="nnn -e"

source /usr/share/nvm/init-nvm.sh

# Show system info
fastfetch -c paleofetch.jsonc

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh"
