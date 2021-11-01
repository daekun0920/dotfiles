#-------------------------------------------------------------------------------
# Shell function chestsheet
#-------------------------------------------------------------------------------
# $* : all args
# $# : number of args
# shift <n> : shift n args to the left. given 6 args, "shift 2" makes 4 args
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Create a new directory and enter it
#-------------------------------------------------------------------------------

function mkd() {
  mkdir -p "$@" && cd "$_";
}

#-------------------------------------------------------------------------------
# Open man page as PDF
#-------------------------------------------------------------------------------

function manpdf() {
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

#-------------------------------------------------------------------------------
# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
#-------------------------------------------------------------------------------

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

#-------------------------------------------------------------------------------
# Determine size of a file or total size of a directory
#-------------------------------------------------------------------------------

function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi

  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

#-------------------------------------------------------------------------------
# Create a data URL from a file
#-------------------------------------------------------------------------------

function dataurl() {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi

  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

#-------------------------------------------------------------------------------
# Start a PHP local server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
#-------------------------------------------------------------------------------

function phpserver() {
  echo -e "\033[32mSwitching PHP runtime version\033[0m"
  echo ""
  echo "Usage:"
  echo "  phpserver <port>"
  echo ""

  local port="${1:-8000}";
  local ip=$(ipconfig getifaddr en0);
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}";
}

#-------------------------------------------------------------------------------
# Convert EUC-KR to UTF-8
#-------------------------------------------------------------------------------

function enc() {
  iconv -c -f EUC-KR -t UTF-8 $1 > utf8_"$1"
}

#-------------------------------------------------------------------------------
# UTF-8-encode a string of Unicode symbols
#-------------------------------------------------------------------------------

function escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# Decode \x{ABCD}-style Unicode escape sequences
#-------------------------------------------------------------------------------

function unidecode() {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# Get a character’s Unicode code point
#-------------------------------------------------------------------------------

function codepoint() {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
  # print a newline unless we’re piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

#-------------------------------------------------------------------------------
# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
#-------------------------------------------------------------------------------

function s() {
  if [ $# -eq 0 ]; then
    subl .;
  else
    subl "$@";
  fi;
}

#-------------------------------------------------------------------------------
# `o` with no arguments opens the current directory, otherwise opens the given
# location
#-------------------------------------------------------------------------------

function o() {
  if [ $# -eq 0 ]; then
    open .;
  else
    open "$@";
  fi;
}

#-------------------------------------------------------------------------------
# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
#-------------------------------------------------------------------------------

function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

#-------------------------------------------------------------------------------
# Highlight
#-------------------------------------------------------------------------------

#function hl() {
#  if [[ "$1" && "$2" ]]
#    then
#      if [[ -z "$3" ]] then; FONTSIZE=24; else; FONTSIZE=$3; fi;
#      highlight -O rtf $1 --syntax $2 --font D2Coding --style solarized-dark \
#          --font-size $FONTSIZE | pbcopy
#    else
#      echo "\033[31mError: missing required arguments.\033[0m"
#      echo "Usage: "
#      echo "  hl filename syntax [fontsize]"
#    fi
#}

#-------------------------------------------------------------------------------
# Docker
#-------------------------------------------------------------------------------

function dip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}

dsm() {
	docker stop $1 && docker rm $1
}

drm() {
	#docker rm $(docker ps -a -q)
	docker ps -a -q | xargs docker rm
}

drmi() {
	docker images | grep '<none>' | \
	awk '{ print $3 }' | \
	xargs docker rmi
}

drun() {
	docker run --rm -t -i $@
}

drund() {
	docker run -d --name $@ $@
}

dbash() {
	if [ $# -lt 1 ] ; then
	  echo "Please provide a container id or name. Usage: dbash <containerIdOrName>"
	else
		docker exec -it $1 bash
	fi;
}

dps() {
	docker exec $1 ps -f
}

dlogs() {
  docker logs -f $1
}

#-------------------------------------------------------------------------------
# IP check
#-------------------------------------------------------------------------------

function myip() {
  curl -s "ifconfig.me"
}

#-------------------------------------------------------------------------------
# Release Versions
#-------------------------------------------------------------------------------

function version() {
  local BRANCH=`git rev-parse --abbrev-ref HEAD`
  local HASH=`git show --pretty='format:%h' | head -1`
  echo $BRANCH~$HASH
}

#-------------------------------------------------------------------------------
# Log Tailing
#-------------------------------------------------------------------------------

function ct() {
  echo -e "\033[32mTailing log after truncating content\033[0m"
  if [ "$1" = "" ]; then
    echo ""
    echo "Usage:"
    echo "  ct <path_to_log>"
    return 0;
  fi;

  local LOG_FILE="$1"
  cat /dev/null > $LOG_FILE
  tail -f $LOG_FILE
}

#-------------------------------------------------------------------------------
# Echo with yellow color
#-------------------------------------------------------------------------------

function e() {
  if [ "$1" = "" ]; then
    echo "Print text in \033[0;33mYellow\033[0m color"
    echo ""
    echo "Usage:"
    echo '  e "<text>"'
    return 0;
  fi;

  local TEXT="$1"
  echo -e "\033[0;33m${TEXT}\033[0m"
}

#-------------------------------------------------------------------------------
# Kill Port
#-------------------------------------------------------------------------------

function killport() {
  if [ "$1" = "" ]; then
    echo "Print text in \033[0;33mYellow\033[0m color"
    echo ""
    echo "Usage:"
    echo '  killport "<port>"'
    return 0;
  fi;

  local PORT="$1"
  kill $(lsof -t -i :$PORT)
  echo -e "\033[0;33m${PORT} port has been closed\033[0m"
}

#-------------------------------------------------------------------------------
# yaml to json
#-------------------------------------------------------------------------------

function yq() {
    ruby -r yaml -r json -e 'puts YAML.load($stdin.read).to_json' | jq
}

function merge_yaml() {
    ruby -r 'yaml' -e "c = YAML.load(File.open('${1}')); d = YAML.load(File.open('${2}')); c.merge!(d); p c.to_yaml(:indentation => 2);"
}

#-------------------------------------------------------------------------------
# Reload zsh
#-------------------------------------------------------------------------------

function rr() {
  source $HOME/.zshrc
}

#-------------------------------------------------------------------------------
# Refresh DNS Cache
#-------------------------------------------------------------------------------

function reloaddns() {
  echo -e "\033[32mRefresh DNS Cache\033[0m"
  dscacheutil -flushcache && sudo killall -HUP mDNSResponder
}

#-------------------------------------------------------------------------------
# Recursively remove .DS_Store files
#-------------------------------------------------------------------------------

function cds() {
  echo -e "\033[32mRecursively remove .DS_Store files\033[0m"
  find . -type f -name '*.DS_Store' -ls -delete
}

#-------------------------------------------------------------------------------
# Stop apache
#-------------------------------------------------------------------------------

function stopapache() {
  echo -e "\033[32mStop apache\033[0m"
  sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
}

#-------------------------------------------------------------------------------
# Java shell
#-------------------------------------------------------------------------------

function jsh() {
  cd $HOME/jsh && mvn jshell:run -Djshell.scripts="startup.jsh"
  cd -
}

function javahome() {
  if [ "$1" = "" ]; then
    echo "Find java home"
    echo ""
    echo "Usage:"
    echo '  javahome <version>'
    echo "  e.g. javahome 1.8"
    return 0;
  fi;

  /usr/libexec/java_home -v $1
}

#-------------------------------------------------------------------------------
# git move tag and push
#-------------------------------------------------------------------------------

function mt() {
  if [ "$1" = "" ]; then
    echo "git re-tag and push"
    echo ""
    echo "Usage:"
    echo '  retag <tag_name>'
    echo "  e.g. retag jenkins"
    return 0;
  fi;

  local found=$(git tag | grep "$1")
  if [ "found" = "" ]; then
    echo "tag \"$1\" does not exist!"
    return 0;
  else
    git tag -d $1
    git tag $1
    git push origin :$1
    git push origin $1
  fi;
}
