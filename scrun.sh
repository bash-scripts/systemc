#!/bin/bash
###
# "SystemC Runner" v.1.3
# USAGE: type the name of directory with SystemC code; take on input only one argument.
###
user_input=$1
if [[ $# < 1 ]]
  then echo -e "\e[0;41m! Directory not entered !\e[0m"
  exit
fi
if [[ $# = 1 ]]
  then echo -e -e "\e[0;37mAnalysing input...\e[0m"
  if [[ ! -d "$user_input" ]]
    then echo -e "\e[0;41m! Incorrect directory  name !\e[0m"
    exit
    else
      echo -e "\e[0;37mEntering the directory...\e[0m"
      cd $user_input
      short_dir_name=`pwd | grep -Eo "[^/][a-zA-Z0-9\s]*$"`
      if [[ $user_input != $short_dir_name ]]
        then echo -e "\e[0;37mShortening path to the directory...\e[0m"
        dir_name=$short_dir_name
        else
          dir_name=$user_input
      fi
  fi
fi
if [[ $# > 1 ]]
  then echo -e "\e[0;41m! Unnecessary arguments !\e[0m"
  exit
fi
echo -e "\n\e[0;37mSearch for \e[1;34msource\e[0;37m file(s)...\e[0m"
countcpp=0
cpps=()
while read
  do
  cpps+=("$REPLY")
  (( countcpp++ ))
done < <(find . -name "*.cpp")
echo -e "\e[0;37m Find \e[1;34m$countcpp source\e[0;37m file(s)!\e[0m"
echo -e "\n\e[0;37mSearch for \e[1;31mheaders\e[0;37m file(s)...\e[0m"
counth=0
hs=()
while read
  do
  hs+=("$REPLY")
  (( counth++ ))
done < <(find . -name "*.h")
echo -e "\e[0;37m Find \e[1;31m$counth headers\e[0;37m file(s)!\e[0m"
total=$(($countcpp + $counth))
if [[ $total = 0 ]]
  then echo -e "!\e[0;41m! No matching file(s) !\e[0m"
  exit
fi
echo -e "\n\e[0;37mTotal found \e[1;32m$total\e[0;37m file(s):\e[0m"
files=''
for x in ${!cpps[*]}
  do
  files=$files${cpps[$x]}' '
  echo -e "\e[0;34m ${cpps[$x]}\e[0m"
done
for x in ${!hs[*]}
  do
  files=$files${hs[$x]}' '
  echo -e "\e[0;31m ${hs[$x]}\e[0m"
done
echo -e "\n\e[1;34mContinue building? \e[0;34m[\e[1;32;40mY\e[0;34m/\e[1;31;40mN\e[0;34m]\e[0m"
while true
  do
    read user_answer
    case $user_answer in
      y|Y)
        echo -e "\e[0;32mContinuation building...\e[0m"
        break;;
      n|N)
        echo -e "\e[0;31mCancellation building...\e[0m"
        exit;;
      *)
        echo -e "\e[0;41m! Wrong answer (\"y\" or \"n\") !\e[0m"
    esac
done
g++ -Wall -Wextra -I. -I$SYSTEMC_HOME/include -L. -L$SYSTEMC_HOME/lib-linux64 -Wl,-rpath=$SYSTEMC_HOME/lib-linux64 -o out $files -lsystemc -lm
if [[ ! -f "out" ]]
  then echo -e "\e[1;4;31m=====BUILDING FAIL=====\e[0m"
  exit
  else
  echo -e "\e[1;4;32m=====BUILDING SUCCESS=====\e[0m"
  mv out ../scout\($dir_name\)\#$(date +%d).$(date +%m).$(date +%y)_$(date +%H).$(date +%M).$(date +%S)
  echo -e "\n\e[1;34m   SystemC output file is nearby!\e[0m"
  cd ..
  echo -e -n "\e[1;34m   ==> \e[0;32m"
  ls -t | grep "scout*" | head -n1
  echo -e "\e[0m"
fi
#################################################################################
#__     _______ _     ___  ____ ___ ____  _____ ____                        _   #
#\ \   / / ____| |   / _ \/ ___|_ _|  _ \| ____|  _ \   _ __  _ __ ___   __| |  #
# \ \ / /|  _| | |  | | | \___ \| || |_) |  _| | | | | | '_ \| '__/ _ \ / _` |  #
#  \ V / | |___| |__| |_| |___) | ||  __/| |___| |_| | | |_) | | | (_) | (_| |_ #
#   \_/  |_____|_____\___/|____/___|_|   |_____|____/  | .__/|_|  \___/ \__,_(_)#
#                                                      |_|                      #
#################################################################################
