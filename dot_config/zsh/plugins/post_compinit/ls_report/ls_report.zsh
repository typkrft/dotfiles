function _ls_report() {
  DIRS=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)
  # HIDDEN_DIRS=$(find . -iname ".*" -mindepth 1 -maxdepth 1 -type d | wc -l)
  # TOTAL_DIRS=$(( $DIRS + $HIDDEN_DIRS ))
  
  FILES=$(find . -mindepth 1 -maxdepth 1 -type f | wc -l)
  # HIDDEN_FILES=$(find . -iname ".*" -mindepth 1 -maxdepth 1 -type f| wc -l)
  # TOTAL_FILES=$(( $FILES + $HIDDEN_FILES ))
  
  DIR_SIZE=$(timeout 0.5s du -sbh  . 2>/dev/null | awk '{print $1}')
  if [[ $? -ne 0 ]]; then 
      DIR_SIZE=""
  fi
  
  KEY_COLOR=$(tput bold; tput setaf 6)
  VALUE_COLOR=$(tput sitm; tput setaf 2)
  RESET_TEXT=$(tput sgr0)

  eza --icons -a --group-directories-first --git -F
  printf "\n"
  printf "${KEY_COLOR}Path:${RESET_TEXT}        ${VALUE_COLOR}$(pwd)${RESET_TEXT}\n"
  printf "${KEY_COLOR}Folders:${RESET_TEXT}     ${VALUE_COLOR}${DIRS}${RESET_TEXT}\n"
  printf "${KEY_COLOR}Files:${RESET_TEXT}       ${VALUE_COLOR}${FILES}${RESET_TEXT}\n"
  if [[ $DIR_SIZE != "" ]]; then 
      printf "${KEY_COLOR}Size:${RESET_TEXT}        ${VALUE_COLOR}${DIR_SIZE}${RESET_TEXT}\n"
  fi
}