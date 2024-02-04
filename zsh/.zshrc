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
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# prompt
setopt PROMPT_SUBST
PROMPT="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$reset_color%}[%{$fg[yellow]%}%~%{$reset_color%}]: "
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

# ALIASES

## Utilities
alias ll="exa -l"
alias l="exa -la"
alias bm="bashmount"
alias wget="aria2c -x 16 -s 16"
alias vim="nvim"
alias k="kubectl"
alias c="clear && pwd && ll"
alias cd="z"
alias cdi="zi"
alias zshedit="vim /home/darko/.zshrc"
alias cggpg="gpg --quiet --decrypt /home/darko/workspace/keys/chatgpt.txt.gpg > /dev/null"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

neofetch --off
