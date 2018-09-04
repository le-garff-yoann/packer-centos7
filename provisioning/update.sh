#!/bin/bash -eux

if [[ $UPDATE == 'true' ]]
then
    yum -y update

    reboot
    sleep 60
fi
