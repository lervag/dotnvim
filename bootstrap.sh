#!/usr/bin/env bash

target="$HOME/.local/plugged/vim-plug"
rtp=$(dirname "$0")
destination="${rtp}/autoload/plug.vim"


# echo -n "Fetching vim-plug ... "
# if [ -d "$target" ]; then
#   echo "already fetched."
# else
#   echo "done!"
#   mkdir -p "$(dirname "$target")"
#   git clone --depth 1 https://github.com/junegunn/vim-plug.git "$target"
# fi

# echo -n "Installing vim-plug ... "
# if [ -e "$destination" ]; then
#   echo "already installed."
# else
#   echo "done!"
#   mkdir -p "$(dirname "$destination")"
#   ln -s "$target/plug.vim" "$destination"
# fi

spelldir="$HOME/documents/aux/vim/spell"
echo -n "Preparing shared spell files ... "
if [ -e "$spelldir" ]; then
  ln -s "$spelldir" "$rtp/spell"
  echo "done!"
else
  echo "spelldir is not available!"
fi
