# csdt-django

[![Build Status](https://travis-ci.org/RPI-HASS/ansible-role-csdt-django.svg?branch=master)](https://travis-ci.org/RPI-HASS/ansible-role-csdt-django)

Installs [rpi_csdt_community](https://github.com/RPI-HASS/rpi_csdt_community) on a linux server.

## Requirements
- none

## Install

#### Install from GitHub
`ansible-galaxy install git+https://github.com/RPI-HASS/ansible-role-csdt-django.git`

#### Install from GitHub with requirements.yml  

- Configure requirements.yml  
  ```
  ## requirements.yml

  # from GitHub, overriding the name and specifying a specific tag
  - src: https://github.com/RPI-HASS/ansible-role-csdt-django
    version: master
    name: webhook-listener
  ```
  ```
  ansible-galaxy install -r requirements.yml
  ```


## Supported Operating Systems
| OS            |               |
| :------------ | :-----------: |
| Ubuntu 16.04  | ✓             |

## Role Variables

The following variable defaults are defined in `defaults/main.yml`

`csdt_django_app_name`  
Application name


## Testing
This role includes a Vagrantfile used with a Docker-based test harness that approximates the Travis CI setup for integration testing. Using Vagrant allows all contributors to test on the same platform and avoid false test failures due to untested or incompatible docker versions.

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
2. Run `vagrant up` from the same directory as the Vagrantfile in this repository.
3. SSH into the VM with: `vagrant ssh`
4. Run tests with `make`.

```
make -C /vagrant xenial64 test
```
See `make help` for more information including a full list of available targets.

## Example Playbook

```

```

## License
