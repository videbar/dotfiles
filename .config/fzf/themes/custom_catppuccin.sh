#!/bin/bash
export FZF_DEFAULT_OPTS=" \
--color=bg+:#1a1a1a,bg:#1a1a1a,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi \
--border rounded \
--prompt '∷ ' \
--pointer '>' \
$FZF_DEFAULT_OPTS
"
