#!/bin/sh

#-------------------------------------------------------------------------------
# Thanks Maxime Fabre! https://speakerdeck.com/anahkiasen/a-storm-homebrewin
# Thanks Mathias Bynens! https://mths.be/osx
#-------------------------------------------------------------------------------

export DOTFILES=$HOME/dotfiles
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
#-------------------------------------------------------------------------------
# Update dotfiles itself
#-------------------------------------------------------------------------------

if [ -d "$DOTFILES/.git" ]; then
  git --work-tree="$DOTFILES" --git-dir="$DOTFILES/.git" pull origin master
fi

#-------------------------------------------------------------------------------
# Check for Homebrew and install if we don't have it
#-------------------------------------------------------------------------------

if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

#-------------------------------------------------------------------------------
# Install executables and libraries
#-------------------------------------------------------------------------------

brew install bash
brew install zsh
brew install zsh-completions
brew install coreutils
brew install findutils
brew install gnu-sed
brew install awscli
brew install git
brew install htop
brew install httpie
brew install jq
brew install kubectl
brew install k9s
brew install openssl
brew install tcpdump
brew install tree
brew install watch
brew install wget
brew install yarn
brew install openapi-generator
brew install aws-iam-authenticator
brew install telnet
brew install git-crypt
brew install gnupg
brew install graphviz

brew install gradle
brew install maven
brew install jenv

brew install adoptopenjdk/openjdk/adoptopenjdk8 --cask
brew install adoptopenjdk11 --cask
brew install docker --cask
brew install firefox --cask
brew install google-chrome --cask
brew install intellij-idea --cask
brew install iterm2 --cask
brew install postman --cask
brew install slack --cask
brew install sublime-text --cask
brew install tableplus --cask
brew install dbeaver-community --cask

#-------------------------------------------------------------------------------
# Install global Git configuration
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.gitconfig $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/.gitignore_global
git config --global user.name "daekun0920"
git config --global user.email "daekun.han@meshkorea.net"

#-------------------------------------------------------------------------------
# Make ZSH the default shell environment
#-------------------------------------------------------------------------------

chsh -s $(which zsh)

#-------------------------------------------------------------------------------
# Install Oh-my-zsh
#-------------------------------------------------------------------------------

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#-------------------------------------------------------------------------------
# Install global JavaScript tools
#-------------------------------------------------------------------------------

npm config set prefix $HOME/npm
yarn global add redoc


#-------------------------------------------------------------------------------
# Install jshell
#-------------------------------------------------------------------------------

git clone git@github.com:appkr/jsh.git $HOME/jsh

#-------------------------------------------------------------------------------
# Source profile
#-------------------------------------------------------------------------------

ln -nfs $DOTFILES/.zshrc $HOME/.zshrc
source $HOME/.zshrc

#-------------------------------------------------------------------------------
# Enable jenv and rbenv
#-------------------------------------------------------------------------------

jenv add $(javahome 1.8)
jenv add $(javahome 11)

#-------------------------------------------------------------------------------
# Set OS X preferences
# We will run this last because this will reload the shell
# Fix backtick(`) issue @see https://ani2life.com/wp/?p=1753
#-------------------------------------------------------------------------------

if [[ ! -d $HOME/Library/KeyBindings ]]; then
    mkdir -p $HOME/Library/KeyBindings
fi

