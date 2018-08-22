#!/bin/bash -eux

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]
then
    yum -y update

    reboot
    sleep 60
fi
