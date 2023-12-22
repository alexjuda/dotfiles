VERBOSE = "-vv"

.PHONY: nop
nop:
	@echo Hello, world!

HOST =
EXTRA =
PLAYBOOK = playbooks/main.yml

ifndef HOST
	$(error HOST=... is required)
endif


.PHONY: framework
framework:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only -K $(VERBOSE) $(EXTRA)

.PHONY: macbook
framework:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: snow
framework:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only,framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: wip-only
wip-only:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --tags wip $(VERBOSE) $(EXTRA)
