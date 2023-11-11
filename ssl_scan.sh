#!/bin/bash
OPENSSL=$(which openssl)
DEBUG=0
PROTOS="tls1 tls1_1 tls1_2 tls1_3 dtls1 dtls1_2 no_ssl3"

# Set up colours
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput setaf 7 && tput setab 0)

TLS_OPTIONS=$(2>&1 openssl s_client --help | egrep -i 'tls[0-9]|ssl.*[0-9]'|sed 's/-//g')
USAGE="
Enter a host and port number and timeout as arguments e.g. $GREEN $0 $(hostname -f) 443 5$RESET

Currently PROTOS: $PROTOS


Edit the \$protos variable in $0, and set one of :

$TLS_OPTIONS"


if [ -z $OPENSSL ]; then
  echo "Make sure openssl is installed, or set the path to openssl version in your PATH"
  exit 1
fi

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]]; then
  echo "$USAGE"
  exit 1
fi

sc=0; fc=0

for proto in $PROTOS
do
  if [[ $DEBUG -eq 0 ]];then
    2>&1>/dev/null timeout $3 2>&1>/dev/null openssl s_client -connect $1:$2 -$proto
    RET=$?
  else
    timeout $3 openssl s_client -connect $1:$2 -$proto
    RET=$?
  fi

  if [ $RET -eq 0 ] || [ $RET -eq 124 ] ; then
    let sc=$sc+1
    echo $GREEN"Successfully$RESET connected to $1 on port $2 using $YELLOW$proto$RESET, return code: $RET"
  else
    let fc=$fc+1
    echo $RED"Failed$RESET to connect $1 on port $2 using $YELLOW$proto$RESET, return code: $RET"
  fi
  sleep 1
done

echo "$RED$fc$RESET failed connections"
echo "$GREEN$sc$RESET successful connections"
