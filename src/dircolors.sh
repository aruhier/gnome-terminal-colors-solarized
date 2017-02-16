#!/usr/bin/env bash

dircolors_checked=false
DIRCOLORS_DIR="$(echo ~/.dir_colors)"
DIRCOLORS_SOLARIZED="$(pwd)"
DIRCOLORS_REPO_ADRESS="https://github.com/seebi/dircolors-solarized"
DIRCOLORS_DL_ADRESS="https://raw.github.com/seebi/dircolors-solarized/master/"

dl_dircolors() {
  echo
  eval "wget -O "$DIRCOLORS_SOLARIZED/dircolors" \
      "$DIRCOLORS_DL_ADRESS/dircolors.ansi-$scheme""
  valid=$?
  if [ ! "$valid" == "0" -o ! -e "$DIRCOLORS_SOLARIZED/dircolors" ]
    then echo -e "Download failed, dircolors will not be copied but you "
    echo -en "can install it from the official repository : "
    echo "$DIRCOLORS_REPO_ADRESS"
    return 1
  fi
  return 0
}

copy_dircolors() {
  dircolors_dest_path="$DIRCOLORS_DIR/dircolors"
  eval dl_dircolors
  dl_ok=$?
  if [ $dl_ok ]
    # CentOS uses ~/.dir_colors as dir_colors file
    then if [ -f "$DIRCOLORS_DIR" ]
      then dircolors_dest_path="$DIRCOLORS_DIR"
    else
      mkdir -p "$DIRCOLORS_DIR"
    fi

    if [ -f "$dircolors_dest_path" ]
      then mv "$dircolors_dest_path" "$dircolors_dest_path.old"
      echo -n "$dircolors_dest_path already exists, renaming it to "
      echo    "$dircolors_dest_path.old"
    fi
  fi
  cp "$DIRCOLORS_SOLARIZED/dircolors" "$dircolors_dest_path"

  echo
  echo "The new dircolors have been installed as $dircolors_dest_path."
  echo
  echo -n "Add \"eval \`dircolors /path/to/dircolorsdb\`\" in your shell "
  echo    "configuration file (.bashrc, .zshrc, etc...) to use new dircolors."
  echo    "For Fish, add the following to config.fish instead:"
  echo -e "\teval (dircolors /path/to/dircolorsdb | head -n 1 | sed 's/^LS_COLORS=/set -x LS_COLORS /;s/;$//')"
  echo
  echo -en "Do not forget to remove old dircolors from your shell "
  echo -en "configuration file if they were named differently than "
  echo -en "the one newly installed.\n"
  echo
}

msg_create_dircolors() {
  echo -en "A dircolors adapted to solarized can be automatically "
  echo -en "downloaded.\n"
  echo
  echo -en "1) Download seebi' dircolors-solarized: "
  echo -en "https://github.com/seebi/dircolors-solarized\n"
  echo
  echo -en "2) [DEFAULT] I don't need any dircolors.\n"
}

msg_already_existing_dircolors() {
  echo -en "A dircolors already exists in $DIRCOLORS_DIR, but can be "
  echo -en "incompatible with the solarized color scheme causing some colors "
  echo -en "problems when doing a \"ls\".\n"
  echo
  echo -en "1) Replace the actual dircolors by seebi' "
  echo -en "dircolors-solarized: "
  echo -en "https://github.com/seebi/dircolors-solarized (the actual "
  echo -en "dircolors will be keeped as backup).\n"
  echo
  echo -en "2) [DEFAULT] I am awared about this potentiall problem and will "
  echo -en "check my dircolors (default path: ~/.dir_colors/dircolors) "
  echo -en "in case of conflict.\n"
}

interactive_dircolors() {
  already_existing_dircolors=$1
  noselect=true
  while $noselect
  do
    echo

    if $already_existing_dircolors
      then msg_already_existing_dircolors
    else
      msg_create_dircolors
    fi

    echo
    read -p "Enter your choice : [2] " selection
    selection=${selection:-2}

    if [[ "$selection" -gt 2 || "$selection" -lt 1 ]]
      then echo "$selection is not a valid entry. Please Restart"
      echo
      noselect=true
    else
      noselect=false
    fi
  done

  if [ "$selection" == 1 ]
    then copy_dircolors
  fi
}

check_dircolors() {
  nonempty=false
  if [ -d "$DIRCOLORS_DIR" ]
    then  [ "$(ls -A $DIRCOLORS_DIR)" ] && nonempty=true || nonempty=false
  fi
  interactive_dircolors $nonempty
  return $(! $nonempty)
}

warning_message_dircolors() {
  echo -en "If there is any problem with the colors when doing a \"ls\", "
  echo -en "please check your dircolors.\n"
}

