#!/bin/bash -eux

if [[ $PACKER_RUN_TESTS == 'true' ]]
then
    XCCDF_FILE=/usr/share/xml/scap/ssg/content/ssg-centos7-xccdf.xml

    echo "==> Running OpenSCAP tests against ${XCCDF_FILE}"

    oscap xccdf eval \
        --profile standard \
        --fetch-remote-resources \
        $XCCDF_FILE
fi
