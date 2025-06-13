if status is-interactive

    set fish_greeting
    bind \cw forward-word
    bind \cf forward-char
    bind \ch complete

    # Disable Ctrl-d, otherwise it closes the shell.
    bind \cd ""

    function dotfiles --wraps git --description "Manage my configuration files"
        git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
    end

    # Set the terminal language to English, useful to post error messages online.
    function eng
        set LANG en_US.UTF-8
    end

    set VISUAL nvim
    set EDITOR $VISUAL
    fish_add_path ~/.local/bin
    fish_add_path ~/.appimages

    abbr --add mcli matlab -nodesktop

    # Cargo
    source "$HOME/.cargo/env.fish"

    fish_add_path (python3 -c "import site; print(site.USER_BASE)")/bin

    # Starship
    if command -q starship
        starship init fish | source
    else
        set missing $missing starship
    end

    # Zoxide
    if command -q zoxide
        zoxide init fish | source
    else
        set missing $missing zoxide
    end

    # Fzf
    if command -q fzf
        fzf --fish | source
        source $HOME/.config/fzf/config.sh
    else
        set missing $missing fzf
    end

    # Bat
    if command -q bat
        function  cat --wraps cat
            bat --theme="custom_catppuccin" $argv
        end
    # Sometimes the executable is installed as batcat.
    else if command -q batcat
        function  cat --wraps cat
            batcat --theme="custom_catppuccin" $argv
        end
    else
        set missing $missing bat
    end

    # Eza
    if command -q exa
        function ls --wraps ls
            exa --color auto -s type $argv
        end
    else
        function ls --wraps ls
            ls ls --color=auto $argv
        end
        set missing $missing eza
    end
    abbr --add la ls -a
    abbr --add ll ls -l

    if not command -q delta
        set missing $missing delta
    end

    alias rm 'echo "If you want to use the real \"rm\", call \"command rm\", otherwise try \"gm\""'
    if command -q gtrash
        abbr --add gm gtrash put
    else
        set missing $missing gtrash
    end

    function missing_software
        if set -q missing
            echo "Some stuff is missing:"
            for m in $missing
              echo "  - $m"
            end
        else
            echo "All set!"
        end

    end
end
