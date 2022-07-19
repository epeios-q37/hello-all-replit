#!/bin/bash

LANGS=(Java Node.js Perl Python Ruby)
FLAVORS=(java node perl python ruby)

LANGS_AMOUNT=${#LANGS[@]}

CONT=true

while [ "$CONT" == "true" ]
do

  echo -e "\nAVAILABLE LANGUAGES:\n"
  
  for i in "${!LANGS[@]}"
  do
    printf "%s: %s\n" "$((1 + $i ))" "${LANGS[$i]}"  
  done
  
  echo -n -e "\nChoose a language ('1'…'$LANGS_AMOUNT'): "
  
  read CHOICE
  
  FLAVOR=${FLAVORS[$(($CHOICE - 1))]}
  LANGUAGE=${LANGS[$(($CHOICE - 1))]}
  
  REPO=atlas-$FLAVOR
  REPO_URL="https://github.com/epeios-q37/$REPO"
  
  export GIT_TERMINAL_PROMPT=0

  [ -d $REPO ] || echo -e "\nRetrieving 'atlas-$FLAVOR' repository…\n"

  [ -d $REPO ] || ( git ls-remote -h $REPO_URL HEAD &> /dev/null && git clone $REPO_URL )

  case $FLAVOR in
    java)
      echo -e '\nPlease wait: compilation in progress...'\
        && javac -cp atlas-java/atlastk.jar Hello.java\
        && ATK=none java -cp .:atlas-java/atlastk.jar Hello
      ;;
    node)
      npm list atlastk &>/dev/null || npm install atlastk;\
        ATK=none node Hello.js
      ;;
    perl)
      ATK=none perl -I atlas-perl/atlastk Hello.pl
      ;;
    python)
      PYTHONPATH=$PYTHONPATH:atlas-python/atlastk ATK=none python3 Hello.py
      ;;
    ruby)
      ATK=none ruby -Iatlas-ruby/atlastk Hello.rb
      ;;
    *)
      echo -n "Not a known language."
      ;;
  esac
done
