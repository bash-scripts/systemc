#!/bin/bash
###
# "SystemC Runner" v.1.2.1
# USAGE: type the name of directory with SystemC code; take on input only one argument.
###
name=$1
if [[ $# < 1 ]]
  then echo -e "\e[0;41m! Directory not entered !\e[0m"
  exit
fi
if [[ $# = 1 ]]
  then echo -e -e "\e[0;37mAnalysing input...\e[0m"
  if [[ ! -d "$name" ]]
    then echo -e "\e[0;41m! Incorrect directory  name !\e[0m"
    exit
    else
      echo -e "\e[0;37mEntering the directory...\e[0m"
      cd $name
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
names=''
for x in ${!cpps[*]}
  do
  names=$names${cpps[$x]}' '
  echo -e "\e[0;34m ${cpps[$x]}\e[0m"
done
for x in ${!hs[*]}
  do
  names=$names${hs[$x]}' '
  echo -e "\e[0;31m ${hs[$x]}\e[0m"
done
echo -e "\n\e[1;34mContinue building? \e[0;34m[\e[1;32;40mY\e[0;34m/\e[1;31;40mN\e[0;34m]\e[0m"
while true
  do
    read ans
    case $ans in
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
g++ -Wall -Wextra -I. -I$SYSTEMC_HOME/include -L. -L$SYSTEMC_HOME/lib-linux64 -Wl,-rpath=$SYSTEMC_HOME/lib-linux64 -o out $names -lsystemc -lm
if [[ ! -f "out" ]]
  then echo -e "\e[1;4;31m=====BUILDING FAIL=====\e[0m"
  exit
  else
  echo -e "\e[1;4;32m=====BUILDING SUCCESS=====\e[0m"
  mv out ../scout\($name\)\#$(date +%d).$(date +%m).$(date +%y)_$(date +%H).$(date +%M).$(date +%S)
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
