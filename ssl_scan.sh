#!/bin/bash
OPENSSL=$(which openssl)
PROTOS="tls1 tls1_1 tls1_2 tls1_3 no_ssl3"

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
SERVICE=$(grep " $2\/" /etc/services | tr -s ' '|awk {'print $1'}|tail -1)

for proto in $PROTOS
do
  if [[ $SERVICE == "submission" ]]; then 
    STARTTLS=" -starttls smtp"
  elif [[ $SERVICE == "urd" ]] ; then
    STARTTLS=" -starttls smtp"
  else
    STARTTLS=""; 
  fi
  OUTPUT=$(2>&1 echo "Hello World" | timeout $3 2>&1 2>&1 openssl s_client $STARTTLS -connect $1:$2 -$proto)
  RET=$?
  RET_COLOUR=""
  if [[ $RET -eq 0 ]]; then
    RET_COLOUR=$GREEN
  elif [[ $RET -eq 1 ]]; then
    RET_COLOUR=$RED
  else
    RET_COLOUR=$YELLOW
  fi

  # must have cert data or a non NONE Cipher
  CC=$(echo -n $OUTPUT|grep "Server certificate" | wc -l)
  WV=$(echo -n $OUTPUT|grep "SSL.*wrong version number" | wc -l)
  SS=$(echo -n $OUTPUT|egrep -iB2 "SSL-Session.*:|self signed certificate|self-signed certificate"|tr -s " "|tr -d ':'|egrep -v "New, (NONE), Cipher is (NONE)"|grep -v "Cipher.*0000"|wc -l)
  PU=$(echo -n $OUTPUT|egrep "Protocol.*:|Cipher.*"|grep -v New.*NONE)
  PUL=$(echo -n $OUTPUT|egrep "Protocol.*:|Cipher.*"|grep -v New.*NONE|wc -l)
  if [ $DEBUG -ne 0 ]; then
    echo "Certificate Found =$CC"
    echo "Wrong Version count =$WV"
    echo "SSL Session =$SS"
    echo "PROTO USED =$PU"
    echo "-----
OUTPUT=$OUTPUT
-----"
  fi

  MSG_COMMON="on port $YELLOW$2$RESET using $YELLOW$proto$RESET, service: $YELLOW$SERVICE$RESET - return code: $RET_COLOUR$RET$RESET"
  if ([[ $CC -gt 0 ]] || [[ $SS -gt 0 ]]) && ( [[ $WV -lt 1 ]] ) ; then
    let sc=$sc+1
    echo $GREEN"Successfully$RESET connected to $1 $MSG_COMMON"
  else
    let fc=$fc+1
    echo $RED"Failed$RESET to connect $1 $MSG_COMMON"
  fi
  sleep 1
done
echo "$RED$fc$RESET failed connections"
echo "$GREEN$sc$RESET successful connections"
