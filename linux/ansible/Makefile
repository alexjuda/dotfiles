.PHONY: nop
nop:
	@echo Hello, world!

# Required
HOST =

# Optional
EXTRA =
PLAYBOOK = playbooks/main.yml
VERBOSE = "-vv"

.PHONY: framework
framework:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only -K $(VERBOSE) $(EXTRA)

.PHONY: macbook
macbook:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: snow
snow:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only,framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: wip-only
wip-only:
	ansible-playbook -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --tags wip $(VERBOSE) $(EXTRA)


