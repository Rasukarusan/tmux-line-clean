#!/usr/bin/env bash

init_tty() {
  stty -icanon min 1 -echo -ixon -icrnl 
}

quit_tty() {
  stty icanon echo eof '^d' ixon icrnl
}

getchar() {
  dd bs=1 count=1 2> /dev/null
}

up_cursor() {
  tput cuu1
}

down_cursor() {
  tput cud1
}

clear_line() {
  tput el
}

undo_line() {
  sed -n ${y}p $tmuxBuffer | tr -d '\n'
}

set_cursor_position() {
  old_settings=$(stty -g) || exit
  stty -icanon -echo min 0 time 3 || exit
  printf '\033[6n'
  pos=$(dd count=1 2> /dev/null)
  pos=${pos%R*}
  pos=${pos##*\[}
  x=${pos##*;} y=${pos%%;*}
  stty "$old_settings"
}

restore() {
  tput cup 0 0
  sed -n 1,${restoreLine}p $tmuxBuffer
  remove_tmux_buffer
}

ready_for_restore() {
  trap "restore && exit" 2
  set_cursor_position
  restoreLine=$y
}

create_tmux_buffer() {
  tmuxBuffer=$(mktemp)
  tmux capture-pane -pe > $tmuxBuffer
}

remove_tmux_buffer() {
  rm $tmuxBuffer
}

main() {
  ready_for_restore
  init_tty
  create_tmux_buffer
  while true ; do
    set_cursor_position
    local char=$(getchar)
    case "${char}" in
      j)
        undo_line
        down_cursor
        ;;
      k)
        up_cursor
        clear_line
        ;;
      $'\x0d') # ENTER
        break
        ;;
      *)
        ;;
    esac
  done
  remove_tmux_buffer
  quit_tty
}
main
