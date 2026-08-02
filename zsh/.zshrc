# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"
# CURRENT zshrc REQUIREMENTS:
# exa
# bashmount
# fzf
# END REQUIREMENTS
autoload -U edit-command-line

# Widget
zle -N edit-command-line

# keys — secrets live in a gitignored file, never in this tracked config
[[ -f "${HOME}/.config/zsh/secrets.zsh" ]] && source "${HOME}/.config/zsh/secrets.zsh"

# editor
export EDITOR="nvim"
export READER="zathura"

# path
export PATH="$HOME/go/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"

# prompt is handled by Starship (see `starship init zsh` near the bottom of this file)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS   # drop older duplicate commands
setopt HIST_IGNORE_SPACE      # don't record lines starting with a space
setopt HIST_REDUCE_BLANKS     # trim superfluous whitespace before saving
setopt HIST_VERIFY            # expand !! etc. onto the line before running
setopt SHARE_HISTORY          # share history live across concurrent sessions
setopt EXTENDED_HISTORY       # record timestamps
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# Keybinds
bindkey -M vicmd 'v' edit-command-line

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
alias zshedit="vim ~/.zshrc"
alias cggpg="gpg --quiet --decrypt \"$HOME/workspace/keys/chatgpt.txt.gpg\" > /dev/null"
#alias bat="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias wifi='nmcli dev wifi | sort -k3 -nr | awk '\''!seen[$2]++'\'''
alias q='kiro-cli'

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
alias oc="opencode"
alias ghosty="kiro-cli --tui --agent ghosty"

alias ideas="nvim ~/workspace/darko-ideas.md"

# nvm — lazy-loaded to keep shell startup fast.
# Sourcing nvm.sh auto-selects the default Node, which is the slow part. These
# shims defer that until the first nvm/node/npm/npx call, then remove
# themselves, source nvm for real, and re-run your command transparently.
_load_nvm() {
  unset -f nvm node npm npx 2>/dev/null
  source /usr/share/nvm/init-nvm.sh
}
for _cmd in nvm node npm npx; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd

# Grimoire patterns
export PATTERNS_DIR="$HOME/workspace/kiro-projects/better-agent/pattern-library/patterns"

# Show system info
# fastfetch -c paleofetch.jsonc

# STARSHIP.RS
eval "$(starship init zsh)"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/tmp/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/tmp/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/tmp/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/tmp/google-cloud-sdk/completion.zsh.inc"; fi

# The next line updates PATH for Nebius CLI.
if [ -f "$HOME/.nebius/path.zsh.inc" ]; then source "$HOME/.nebius/path.zsh.inc"; fi
# The next line enables shell command completion for Nebius CLI.
if [ -f "$HOME/.nebius/completion.zsh.inc" ]; then source "$HOME/.nebius/completion.zsh.inc"; fi
alias fix-memory="~/.local/bin/fix-memory"
