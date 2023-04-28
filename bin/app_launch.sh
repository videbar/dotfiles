#!/bin/bash
## app_launch 
## Launch an AppImage with a variable name
## Copyleft 06/10/2019 - Joseph J Pollock - JPmicrosystems
## Usage: app_launch <unique-name-substring>
## FIXME: arg may not have embedded blanks

##source $HOME/bin/bash_trace
cd "$HOME/.appimages"  ## Where all my AppImages live
##find . -iname \*$1\*.AppImage  ## debug
real_name="$(find . -iname \*$1\*.AppImage)"
##echo "real_name = [$real_name]"

count="$(echo "$real_name" | wc -l)"
if (( count > 1 ))
then
  echo "Found more than one possible AppImage"
  exit 1
fi

if [[ ! -x "$real_name" ]]
then
  echo "Can't find an executable AppImage for [$1]"
  exit 1
fi

./"$real_name"
