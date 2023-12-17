.PHONY: all
all:
	$(MAKE) rootless-only
	$(MAKE) root-only

.PHONY: root-only
root-only:
	ansible-playbook -i inventory.yml playbook.yml --extra-vars @vars.yml --tags superuser -K

.PHONY: rootless-only
rootless-only:
	ansible-playbook -i inventory.yml playbook.yml --extra-vars @vars.yml --skip-tags superuser
