# csdt-django

[![Build Status](https://travis-ci.org/RPI-HASS/ansible-role-csdt-django.svg?branch=master)](https://travis-ci.org/RPI-HASS/ansible-role-csdt-django)

Installs [rpi_csdt_community](https://github.com/RPI-HASS/rpi_csdt_community) on a linux server.

## Requirements
- postgresql
- nodejs

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

`csdt_django_git_repository`  
(default: `https://github.com/RPI-HASS/rpi_csdt_community.git`)  
Git, SSH, or HTTP(S) protocol address of the git repository for the csdt_community app.  

`csdt_django_git_destination`  
(default: `/var/www/django`)  
Absolute path of where the repository should be checked out to.  

`csdt_django_git_clone`  
(default: `yes`)  
If `no`, do not clone the repository if it does not exist locally. You would typically set this to `no` if you are using some other role to maintain the git repository, for example: [ansible-role-webhook-listener](https://github.com/joshuacherry/ansible-role-webhook-listener).  

`csdt_django_git_update`  
(default: `yes`)  
If `no`, do not retrieve new revisions from the origin repository.  

`csdt_django_git_version`  
(default: `HEAD`)  
What version of the repository to check out. This can be the the literal string `HEAD`, a branch name, a tag name.  

`csdt_django_git_recursive`  
(default: `yes`)  
If `no`, repository will be cloned without the --recursive option, skipping sub-modules.  

`csdt_django_git_accept_hostkey`  
(default: `yes`)  
If yes, adds the hostkey for the repo url if not already added.  

`csdt_django_app_name`  
(default: `django`)  
Django app name.   

`csdt_django_app_location`  
(default: `{{ csdt_django_git_destination }}/{{ csdt_django_app_name }}`)  
Location of Django app.  

`csdt_django_app_conf`  
(default: `{{ csdt_django_app_location }}/local_settings.py`)  
Local settings file for Django app.

`csdt_django_superuser`  
(default: `admin`)  
Django superuser username.

`csdt_django_superpass`  
(default: `password`)  
Django superuser password.

`csdt_django_superemail`  
(default: `admin@example.com`)  
Django superuser email address.  

`csdt_django_secretkey`  
(default: `defaulttestsecretkey`)  
Django secret key.  


`csdt_django_settings_debug`  
(default: `True`)  
Set Django to debug mode.

`csdt_django_settings_allowed_hosts`   
default:
```
  - '127.0.0.1'
  - '0.0.0.0'
```
Allowed IP addresses for the django app to bind to.

`csdt_django_settings_csrf_trusted_origins`  
default:
```
  - 'your.fqdn.here'
```
Fully qualified domain name of your host for Cross Site Request Forgery protection.

`csdt_django_settings_google_analytics_id`  
(default: `AA-1234567-8`)  
Google analytics ID.

`csdt_django_settings_google_analytics_domain`  
(default: `your.fqdn.here`)  
Google analytics domain.


`csdt_django_gunicorn_command`  
(default: `/opt/{{ csdt_django_app_name }}/bin/gunicorn`)  
Location of gunicorn command, by default this uses a python virtualenv.

`csdt_django_gunicorn_bind`  
(default: `127.0.0.1:8001`)  
IP address and port to bind gunicorn to.

`csdt_django_gunicorn_workers`  
(default: `{{ ( 2 * ansible_processor_vcpus) +1 }}`)  
Number of gunicorn workers.

`csdt_django_gunicorn_user`  
(default: `www-data`)  
User to run gunicorn service.


## Testing
This role includes a Vagrantfile used with a Docker-based test harness that approximates the Travis CI setup for integration testing. Using Vagrant allows all contributors to test on the same platform and avoid false test failures due to untested or incompatible docker versions.

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
2. Run `vagrant up` from the same directory as the Vagrantfile in this repository.
3. SSH into the VM with: `vagrant ssh`
4. Run tests with `make`.

#### Testing with Docker and inspec
```
make -C /vagrant xenial64 test
```
See `make help` for more information including a full list of available targets.

#### Install in Vagrant VM for interactive testing
```
make -C /vagrant install
```
- On your local machine, navigate your web browser to `http://127.0.0.1:8002`

## Example Playbook

```
---
- name: Roles for csdt server
  hosts: all
  roles:
    - postgresql
    - role_under_test

  vars:

    # Postgres Configuration
    postgresql_databases:
      - name: "{{ csdt_django_secret_db }}"
    postgresql_users:
      - name: "{{ csdt_django_secret_user }}"
        password: "{{ csdt_django_secret_pass }}"
        priv: ALL
        db: "{{ csdt_django_secret_db }}"

    # django variables
    # django secrets
    csdt_django_secret_db: "csdt"
    csdt_django_secret_user: "csdt"
    csdt_django_secret_pass: "testpassword"

    csdt_django_superuser: "admin"
    csdt_django_superpass: "password"
    csdt_django_superemail: "admin@example.com"

    csdt_django_secretkey: "testsecretkey"

    csdt_django_settings_debug: True
    csdt_django_settings_allowed_hosts:
      - '127.0.0.1'
      - '0.0.0.0'
    csdt_django_settings_csrf_trusted_origins:
      - 'your.fqdn.here'
    csdt_django_settings_google_analytics_id: 'AA-1234567-8'
    csdt_django_settings_google_analytics_domain: 'your.fqdn.here'

    # CSDT django
    csdt_django_git_repository: "https://github.com/RPI-HASS/rpi_csdt_community.git"
    csdt_django_git_destination: "/var/www/csdt.rpi.edu"
    csdt_django_app_name: "rpi_csdt_community"
    csdt_django_git_clone: "yes"
    csdt_django_git_update: "no"
    csdt_django_conf_file_group: "www-data"

    csdt_django_gunicorn_command: "/opt/{{ csdt_django_app_name }}/bin/gunicorn"
    csdt_django_gunicorn_bind: "0.0.0.0:8002"
    csdt_django_gunicorn_workers: "{{ ( 2 * ansible_processor_vcpus) +1 }}"
```

## License
