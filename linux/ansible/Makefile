.PHONY: nop
nop:
	@echo Hello, world!

# Required
# Example: HOST="localhost"
HOST =

# Optional
EXTRA =
PLAYBOOK = playbooks/main.yml
VERBOSE = "-vv"
ANSIBLE := uvx --from ansible-core --with ansible ansible-playbook

.PHONY: framework
framework:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only -K $(VERBOSE) $(EXTRA)

.PHONY: macbook
macbook:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: snow
snow:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --skip-tags macbook-only,framework-only -K $(VERBOSE) $(EXTRA)

.PHONY: wip-only
wip-only:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml --tags wip $(VERBOSE) $(EXTRA)

macos: PLAYBOOK = playbooks/homebrew.yml

.PHONY: macos
macos:
	$(ANSIBLE) $(PLAYBOOK) $(VERBOSE) $(EXTRA)
