#!/bin/bash -eux

yum -y install openscap openscap-utils scap-security-guide

XCCDF_FILE=/usr/share/xml/scap/ssg/content/ssg-centos7-xccdf.xml

# Removes particular rules
for rule in file_permissions_unauthorized_sgid file_permissions_unauthorized_suid rpm_verify_hashes
do
    sed -i "/idref=\"${rule}\"/d" $XCCDF_FILE
done

# Run profile standard's checks then remediate errors
oscap xccdf eval \
    --remediate \
    --profile standard \
    --fetch-remote-resources \
    $XCCDF_FILE
