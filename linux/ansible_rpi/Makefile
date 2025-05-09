.PHONY: nop
nop:
	@echo Hello, world!

# Required
# Example: HOST="sumac0.local"
HOST =

# Optional
EXTRA =
PLAYBOOK = playbooks/main.yml
VERBOSE = "-vv"
ANSIBLE := uvx --from ansible-core --with ansible ansible-playbook

.PHONY: rpi
rpi:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml $(VERBOSE) $(EXTRA)
