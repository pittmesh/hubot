#!/bin/bash
IFS=$'\n'; for entries in $(cat ./env.txt | grep -v '^#'); do export $entries;  done; 
bin/hubot \
  --name metamesh \
  -a irc
