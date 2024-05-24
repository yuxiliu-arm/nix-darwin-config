# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors ]; then
      eval "$(dircolors -b ~/.dircolors)"
    else
      eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls'
alias gg='git log --graph --oneline --all'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set defualt editor to lunarvim
export VISUAL=lvim
export EDITOR="$VISUAL"

# use `socks` prefix to execute commands via socks proxy
alias socks='ALL_PROXY=socks5://127.0.0.1:1080/' \
        'http_proxy=http://127.0.0.1:1080/' \
        'https_proxy=http://127.0.0.1:1080/' \
        'HTTP_PROXY=http://127.0.0.1:1080/' \
        'HTTPS_PROXY=http://127.0.0.1:1080/'

# Colors
export CLICOLOR=1
RESET_COLOR='\[\e[0m\]'

BRIGHT_BLACK='\[\e[30;1m\]'
RED='\[\e[31m\]'
# GREEN='\[\e[32m\]'
# YELLOW='\[\e[33m\]'
# BLUE='\[\e[34m\]'
DIRBLUE='\[\e[34;1m\]' # blue as is used by dircolors for dirs
CYAN='\[\e[36m\]'
# GRAY='\[\e[37;0m\]'

function color() {
  echo "$*${RESET_COLOR}"
}

function set_bash_prompt() {
  declare -ri exit_status="$?"

  declare -r username='\u'
  declare -r hostname='\h'
  declare -r working_dir='\w'

  declare exit_status_pr
  if [[ "${exit_status}" -ne 0 ]]; then
    exit_status_pr="[$(color "${RED}${exit_status}")]"
  else
    exit_status_pr=''
  fi

  declare username_pr
  if [[ -n "$IN_NIX_SHELL" ]]; then
    username_pr="$(color "${BRIGHT_BLACK}[nix-shell]")"
  else
    username_pr="$(color "${CYAN}${username}")"
  fi

  declare hostname_pr
  hostname_pr="$(color "${CYAN}${hostname}")"

  declare working_dir_pr
  working_dir_pr="$(color "${DIRBLUE}${working_dir}")"

  export GIT_PS1_DESCRIBE_STYLE='branch'
  export GIT_PS1_SHOWCOLORHINTS='y'
  export GIT_PS1_SHOWDIRTYSTATE='y'
  # export GIT_PS1_SHOWSTASHSTATE='y'
  export GIT_PS1_SHOWUNTRACKEDFILES='y'
  export GIT_PS1_SHOWUPSTREAM='auto'

  __git_ps1 "${username_pr}@${hostname_pr}:${working_dir_pr}" "${exit_status_pr} $ "
}

PROMPT_COMMAND=set_bash_prompt

# external files
extra-source () {
    [[ -f "$1" ]] && source "$1"
}
extra-source ~/.git-prompt.sh

# fzf completion
if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

__fzf_nvim__() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read -r item; do
    printf 'nvim %q ' "$item"
  done
  echo
}

fzf-nvim-widget() {
  local nvim_selected="$(__fzf_nvim__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$nvim_selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#nvim_selected} ))
}

if (( BASH_VERSINFO[0] < 4 )); then
  # CTRL-N - use nvim to edit the selected file
  bind -m emacs-standard '"\C-n": " \C-b\C-k \C-u`__fzf_nvim__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
  bind -m vi-command '"\C-n": "\C-z\C-n\C-z"'
  bind -m vi-insert '"\C-n": "\C-z\C-n\C-z"'

else
  # CTRL-N - use nvim to edit the selected file
  bind -m emacs-standard -x '"\C-n": fzf-nvim-widget'
  bind -m vi-command -x '"\C-n": fzf-nvim-widget'
  bind -m vi-insert -x '"\C-n": fzf-nvim-widget'
fi

__fzf_lvim__() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read -r item; do
    printf 'lvim %q ' "$item"
  done
  echo
}

fzf-lvim-widget() {
  local lvim_selected="$(__fzf_lvim__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$lvim_selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#lvim_selected} ))
}

if (( BASH_VERSINFO[0] < 4 )); then
  # C-l - use lvim to edit the selected file
  bind -m emacs-standard '"\C-l": " \C-b\C-k \C-u`__fzf_lvim__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
  bind -m vi-command '"\C-l": "\C-z\C-n\C-z"'
  bind -m vi-insert '"\C-l": "\C-z\C-n\C-z"'

else
  # C-l - use lvim to edit the selected file
  bind -m emacs-standard -x '"\C-l": fzf-lvim-widget'
  bind -m vi-command -x '"\C-l": fzf-lvim-widget'
  bind -m vi-insert -x '"\C-l": fzf-lvim-widget'
fi

# direnv hook
eval "$(direnv hook bash)"

# ghcup
# source /Users/yuxi/.ghcup/env

export PATH="${HOME}/.elan/bin:${HOME}/.cargo/bin:${HOME}/.npm-global/bin:${HOME}/.local/bin:${PATH}"
alias hledger-submit-posting='pushd ~/Documents/hledger && (git diff --quiet && git diff --staged --quiet || git commit -am posting) && git push && git push gitlab && popd'

