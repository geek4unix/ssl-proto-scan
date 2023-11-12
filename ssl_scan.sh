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

Or with debug:

Enter a host and port number and timeout as arguments e.g. $GREEN $0 $(hostname -f) 443 5$RESET DEBUG

Current PROTOS: $PROTOS

Edit the \$protos variable in $0:

$(grep -n "$PROTOS" $0)

and set them to any combination of:

$TLS_OPTIONS"

if [[ $4 == "DEBUG" ]]; then
  DEBUG=1
else
  DEBUG=0
fi

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
  OUTPUT=$(2>&1 timeout $3 2>&1 2>&1 openssl s_client -connect $1:$2 -$proto)
  RET=$?

  # must have cert data ! Make sure there is a Cipher
  CC=$(echo -n $OUTPUT|grep "Server certificate" | wc -l)
  PU=$(echo -n $OUTPUT|grep "Protocol.*:")
  PUL=$(echo -n $OUTPUT|grep "Protocol.*:"|wc -l)
  if [ $DEBUG -ne 0 ]; then
    echo "OUTPUT=$OUTPUT"
    echo "PROTO USED =$PU"
  fi
  if [ $PUL -gt 0 ]  ; then
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
