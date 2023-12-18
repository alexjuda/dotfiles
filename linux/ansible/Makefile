VERBOSE = "-vv"

.PHONY: all
all:
	$(MAKE) rootless-only
	$(MAKE) root-only


INVENTORY = "inventory.yml"
EXTRA =


.PHONY: root-only
root-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --tags superuser -K $(VERBOSE) $(EXTRA)


.PHONY: rootless-only
rootless-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --skip-tags superuser $(VERBOSE) $(EXTRA)


.PHONY: from-wip
from-wip:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --start-at-task wip $(VERBOSE) $(EXTRA)


.PHONY: wip-only
wip-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --tags wip $(VERBOSE) $(EXTRA)
