#!/bin/bash

# This script and its buddy telnet-expect.exp will verify an email address
# Usage: verify-email.sh fromaddress@ucdavis.edu toaddress@ucdavis.edu
# You can lock the from address if by setting the FROM_EMAIL variable below

# Script dependencies:
# bash expect nslookup grep awk telnet

FROM_EMAIL=$1
TO_EMAIL=$2
USER=$(echo $TO_EMAIL | awk -F @ '{print $1}')

# Gets the domain of the email address
DOMAIN=$(echo $TO_EMAIL | awk -F @ '{print $2}')

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

MX=`nslookup -q=mx $DOMAIN | grep --color=never -m1 "mail exchanger =" | awk -F  "mail exchanger =" '{print $2}' | awk '{print $2}' `
expect ./telnet-expect.exp "$FROM_EMAIL" "$MX" "$TO_EMAIL" | grep "THIS IS A VALID MAIL SERVER"  > /dev/null
RESULT=$?
if [ "$RESULT" -eq "0" ]
then
  printf "${GREEN}Mail server for $DOMAIN is valid!\n${NC}"
else
  printf "${RED}Mail server for $DOMAIN is not valid!\n${NC}"
fi

GMAIL_MX_VERIFY=`nslookup -q=mx gmail.com | grep --color=never -m1 "mail exchanger =" | awk -F  "mail exchanger =" '{print $2}' | awk '{print $2}' `
echo $MX
expect ./telnet-expect.exp "$FROM_EMAIL" "$MX" "$TO_EMAIL" | grep "THIS IS A VALID EMAIL ADDRESS"  > /dev/null
RESULT=$?
if [ "$RESULT" -eq "0" ]
then
  printf "${GREEN}Email $TO_EMAIL is valid!\n${NC}"
else
  printf "${RED}Email $TO_EMAIL is invalid!\n${NC}"
fi