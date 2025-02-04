# .bashrc

# Tabcompletion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=3000
HISTFILESIZE=3000

# Disable software flow control (the terminal freezes when pressing ctrl-s).
[ -t 0 ] && stty -ixon

# Disable the option to close the shell with CTRL-d.
set -o ignoreeof

# .local_bashrc is used to define configuration options that I only need in a given
# machine and I don't want in the git repository.
if [ -e "$HOME/.local_bashrc" ]; then
    source "$HOME/.local_bashrc"
fi

# User specific aliases and functions
alias python='python3'
alias eng='LANG=en_US.UTF-8 bash'
alias f='find . -name'

# Create a backup of a file
function bk(){
    cp "$1" "$1.orig";
}
# Go up multiple directories. More convenient than cp ../../../
function up(){
    # It can take multiple dots up .. = cp .., up ... = cp../.. and so on.
    if [[ "$1" =~ ^\.{2,}$ ]]; then
        let PARENTS=${#1}-1

    # It also takes numbers.
    elif [[ "$1" =~ ^[0-9]+$ ]]; then
        PARENTS="$1"

    else
        echo "$0": invalid argument, use either an integer or a set of dots, e.g, ... >&2
        (exit 1)
    fi

    TARGET_PATH="$PWD"

    for (( i=1; i<=$PARENTS; i++ ))
    do
        TARGET_PATH="$TARGET_PATH/.."
    done

    cd $TARGET_PATH
}


# Exports
export VISUAL=nvim
export EDITOR="$VISUAL"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source $HOME/.local/bin/virtualenvwrapper.sh

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
export PATH="$HOME/.local/bin:$PATH"

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
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Tabcomplete for dotfiles
[ -f /usr/share/bash-completion/completions/git  ] && . /usr/share/bash-completion/completions/git
__git_complete dotfiles __git_main


if [ "$(command -v codium)" ]; then
    alias code=codium
fi

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
    alias ls='exa -G --color auto -s type'
    alias la='exa -a -G  --color auto -s type'
    alias ll='exa -l --color always -s type'
else
    alias la='ls -a --color=auto'
    alias ll='ls -l --color=auto'
    alias ls='ls --color=auto'
fi

# Use bat instead of cat
if [ "$(command -v bat)" ]; then
    alias cat='bat --theme="custom_catppuccin"'
# Sometimes the executable is installed as batcat.
elif [ "$(command -v batcat)" ]; then
    alias cat='batcat --theme="custom_catppuccin"'
fi

# Use z for navigation
if [ "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
fi

# Use rmtrash instead of rm and rmdirtrash instead of rmdir. Source:
# https://github.com/PhrozenByte/rmtrash
if [ "$(command -v rmtrash)"  ] && [ "$(command -v trash)"  ]; then
    alias true-rm='\rm'
    alias rm='rmtrash --forbid-root'
    alias sudo='sudo '
fi

if [ "$(command -v rmdirtrash)"  ] && [ "$(command -v trash)"  ]; then
    alias true-rmdir='\rmdir'
    alias rmdir='rmdirtrash --forbid-root'
    alias sudo='sudo '
fi

# Enable fzf keybdingings and theme
if [ "$(command -v fzf)"  ]; then
    # Choose the color theme.
    source $HOME/.config/fzf/themes/custom_catppuccin.sh
    # Source the fzf keybindings. The exact location depends on the distribution.
    POTENTIAL_LOCATIONS=(
        "/usr/share/doc/fzf/examples/key-bindings.bash"
        "/usr/share/fzf/shell/key-bindings.bash"
        ".local/share/fzf/key-bindings.bash"
    )

    for i in "${POTENTIAL_LOCATIONS[@]}"
    do
        if [ -e "$i" ]; then
            source "$i"
            break
        fi
    done

    # Some alias
    alias fv='fzf --bind "enter:become(nvim {})"'
    # Use vscodium if it's installed, and, if not, fallback to vscode.
    if [ "$(command -v codium)" ]; then
        alias fcode='fzf --bind "enter:become(codium {})"'
    else
        alias fcode='fzf --bind "enter:become(code {})"'
    fi
fi
