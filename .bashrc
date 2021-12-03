# .bashrc

# Tabcompletion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
HISTFILESIZE=3000

# User specific aliases and functions
alias python='python3'
alias eng='LANG=en_US.UTF-8 bash'
alias la='ls -a'
alias h='history | grep'
alias f='find . -name'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source ~/.local/bin/virtualenvwrapper.sh

# Custom function to get virtualenv information for the command prompt
function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "$venv "
}

# Poetry:
export PATH="/home/videbar/.local/bin:$PATH"

# Enable pip autocompletion
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
}
complete -o default -F _pip_completion pip


. "$HOME/.cargo/env"

# Dotfiles configuration
alias dotfiles='/usr/bin/git --git-dir=/home/videbar/.dotfiles/ --work-tree=/home/videbar'

# Starship
if [ "$(command -v starship)" ]; then
    eval "$(starship init bash)"
else
    # Disable the default virtualenv prompt change
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    
    # Call my custom function
    VENV="\$(virtualenv_info)"
    
    PS1=" \W\n${VENV}> "
fi

# Use exa instead of ls
if [ "$(command -v exa)" ]; then
    unalias 'll'
    unalias 'la'
    unalias 'ls'
    alias ls='exa -G  --color auto -s type'
    alias la='exa -a -G  --color auto -s type'
    alias ll='exa -l --color always -s type'
fi

# Use bat instead of cat
if [ "$(command -v bat)" ]; then
    alias cat='bat -pp --theme="Nord"'
fi

# Use z for navigation
if [ "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
fi
