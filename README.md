# Packer template for CentOS 7

![Build Status](https://gitlab.com/le-garff-yoann/packer-centos7/badges/master/build.svg)

Heavily inspired by [boxcutter/centos](https://github.com/boxcutter/centos). Just a much lighter version.

Released on [Vagrant Cloud](https://app.vagrantup.com/le-garff-yoann/boxes/centos7).

## Usage

```bash
VAGRANT_CLOUD_TOKEN=my-very-long-token \
    packer build -var-file=vars.json build-n-release.json
```
