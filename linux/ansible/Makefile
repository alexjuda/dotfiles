VERBOSE = "-vv"

.PHONY: nop
nop:
	@echo Hello, world!


# To use a specific SSH host, set INVENTORY="<hostname>,"
INVENTORY = "inventory.yml"
EXTRA =


.PHONY: root-only
root-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --tags superuser -K $(VERBOSE) $(EXTRA)


.PHONY: rootless-only
rootless-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --skip-tags superuser $(VERBOSE) $(EXTRA)


.PHONY: no-mac
no-mac:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --skip-tags mac -K $(VERBOSE) $(EXTRA)


.PHONY: from-wip
from-wip:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --start-at-task wip $(VERBOSE) $(EXTRA)


.PHONY: wip-only
wip-only:
	ansible-playbook -i $(INVENTORY) playbook.yml --extra-vars @vars.yml --tags wip $(VERBOSE) $(EXTRA)
