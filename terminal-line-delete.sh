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

clear_input() {
    tput el
}

get_cursor_position() {
  old_settings=$(stty -g) || exit
  stty -icanon -echo min 0 time 3 || exit
  printf '\033[6n'
  pos=$(dd count=1 2> /dev/null)
  pos=${pos%R*}
  pos=${pos##*\[}
  x=${pos##*;} y=${pos%%;*}
  stty "$old_settings"
}

get_cursor_position
startLine=$y
init_tty
tmuxBuffer=$(mktemp tmux.XXXX)
tmux capture-pane -pe > $tmuxBuffer

isVisualMode=0
while true ; do
    char=$(getchar)
    if [ $isVisualMode -eq 0 ]; then
      get_cursor_position
    fi

    case "${char}" in
        j)
          down_cursor
          line=$(expr $line + 1)
          bufff=$(sed -n ${line}p $tmuxBuffer | tr -d "\n")
          printf "\e[3m${bufff}\e[33m"
          # tput setab 1 && printf "$bufff" 
            ;;
        k)
          up_cursor
          # clear_input
            ;;
        $'\x0d') # ENTER
            get_cursor_position
            tput cup 0 0
            printf "\e[0m\e[0m"

            sed -n 1,$(expr ${start} - 1)p $tmuxBuffer
            tput cup $(expr $start - 1) 0
            printf "\e[0m\e[0m"
            deleteCnt=$(expr $startLine - $y)
            for i in `seq 0 $deleteCnt`; do
              tput cup $(expr $start + $i) 0
              clear_input
            done
            tput cup $(expr $start - 1) 0
            sed -n $(expr ${y} + 1),${startLine}p $tmuxBuffer
            #
            printf "\e[0m\e[0m"
            # tail -n +$(expr ${y} + 1) $tmuxBuffer 
            break
            ;;
        V) 
          isVisualMode=1
          start=$y
          line=$y
          bufff=$(sed -n ${y}p $tmuxBuffer | tr -d "\n")
          printf "\e[3m${bufff}\e[3m"
          ;;
        *)
          # echo "other"
    esac
done

rm $tmuxBuffer
quit_tty
