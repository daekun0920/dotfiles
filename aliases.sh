#-------------------------------------------------------------------------------
# CLI shortcut
#-------------------------------------------------------------------------------

# List current directory
alias ll="$(brew --prefix coreutils)/libexec/gnubin/ls -ahlF --color --group-directories-first"

#-------------------------------------------------------------------------------
# Homebrew
# e.g., $ service list
#-------------------------------------------------------------------------------

alias service="brew services"

#-------------------------------------------------------------------------------
# Some more alias to avoid making mistakes:
#-------------------------------------------------------------------------------

# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

#-------------------------------------------------------------------------------
# Docker
#-------------------------------------------------------------------------------

alias dc="docker-compose"

#-------------------------------------------------------------------------------
# Git
#-------------------------------------------------------------------------------

alias nah="git reset --hard HEAD"

alias k=kubectl
