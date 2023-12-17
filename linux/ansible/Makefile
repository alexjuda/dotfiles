VERBOSE = "-vv"

.PHONY: all
all:
	$(MAKE) rootless-only
	$(MAKE) root-only

.PHONY: root-only
root-only:
	ansible-playbook -i inventory.yml playbook.yml --extra-vars @vars.yml --tags superuser -K $(VERBOSE)

.PHONY: rootless-only
rootless-only:
	ansible-playbook -i inventory.yml playbook.yml --extra-vars @vars.yml --skip-tags superuser $(VERBOSE)


.PHONY: from-wip
from-wip:
	ansible-playbook -i inventory.yml playbook.yml --extra-vars @vars.yml --start-at-task wip $(VERBOSE)
