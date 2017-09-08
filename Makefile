BOXES := $(notdir $(wildcard docker/*))

PLAYBOOK        ?= csdt

define USAGE
targets:

  all     build all Docker images (default)
  install install locally
  clean   remove all Docker images
  help    show this screen
	debug   Run inspec tests then login to container

machine targets:

  <machine>        build <machine> image
  <machine> clean  remove <machine> image
  <machine> test   provision and test <machine>
	<machine> debug  provision and test <machine> then login to container

machines:

  $(BOXES)

variables:

  PLAYBOOK          Choose Playbook to test. Default: 'csdt'.
endef

is_machine_target = $(if $(findstring $(firstword $(MAKECMDGOALS)),$(BOXES)),true,false)

all:
	docker-compose build

clean:
ifeq (true,$(call is_machine_target))
	docker rmi -f ansiblecsdt_$(firstword $(MAKECMDGOALS))
else
	-docker images -q ansiblecsdt* | xargs docker rmi -f
endif

help:
	@echo $(info $(USAGE))

install:
	sudo mkdir -p /tmp/tests-workspace
	sudo cp -R /vagrant/* /tmp/tests-workspace/
	sudo mkdir -p /tmp/tests-workspace/tests/roles
	sudo ln -sf /tmp/tests-workspace/ /tmp/tests-workspace/tests/roles/role_under_test
ifeq ("$(wildcard $(/tmp/tests-workspace/tests/requirements.yml))","")
	sudo ansible-galaxy install --roles-path "/tmp/tests-workspace/tests/roles/" -r "/tmp/tests-workspace/tests/requirements.yml"
endif
	sudo ansible-playbook -i "/tmp/tests-workspace/tests/inventory" -c local -v "/tmp/tests-workspace/tests/csdt.yml"

test:
ifeq (true,$(call is_machine_target))
	./scripts/ci.sh $(firstword $(MAKECMDGOALS)) $(PLAYBOOK)
else
	$(error `test` requires a machine name, see `make help`)
endif

debug:
ifeq (true,$(call is_machine_target))
	./scripts/ci.sh $(firstword $(MAKECMDGOALS)) $(PLAYBOOK) debug
else
	$(error `test` requires a machine name, see `make help`)
endif

$(BOXES):
# Don't build an image just to delete it.
ifeq (,$(findstring clean,$(lastword $(MAKECMDGOALS))))
	{ docker images ansiblecsdt_$@ | grep $@; } && exit || docker-compose build $@
endif

.PHONY: all \
        clean \
        help \
        test \
				debug
