#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ 'virtualbox' ]]
then
  # Add 'single-request-reopen' so it is included when /etc/resolv.conf is generated
      # https://access.redhat.com/site/solutions/58625 (subscription required)
      # http://www.linuxquestions.org/questions/showthread.php?p=4399340#post4399340
  echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network

  service network restart
fi
