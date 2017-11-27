#!/usr/bin/env bash

gnomeVersion=($(
    version_string=$(LANGUAGE=en_US.UTF-8 gnome-terminal --version)
    [[ $version_string =~ ([0-9]+((\.[0-9]+)*)) ]] && version=${BASH_REMATCH[1]}
    echo ${version//./ }
))

# newGnome=1 if the gnome-terminal version >= 3.8
if [[ 
    ( ${gnomeVersion[0]} -eq 3 && ${gnomeVersion[1]} -ge 8 )
    || ${gnomeVersion[0]} -ge 4
]]; then
  newGnome="1"
  dconfdir=/org/gnome/terminal/legacy/profiles:
else
  newGnome=0
  gconfdir=/apps/gnome-terminal/profiles
fi

die() {
  echo $1
  exit ${2:-1}
}

in_array() {
  local e
  for e in "${@:2}"; do [[ $e == $1 ]] && return 0; done
  return 1
}

to_gconf() {
    tr '\n' \: | sed 's#:$#\n#'
}

to_dconf() {
    tr '\n' '~' | sed -e "s#~\$#']\n#" -e "s#~#', '#g" -e "s#^#['#"
}
