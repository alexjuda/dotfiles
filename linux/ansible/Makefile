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

.PHONY: install
install:
	uv tool install ansible-core
	ansible-galaxy collection install community.general -p ./.collections

ANSIBLE := ansible-playbook

.PHONY: run
run:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml -K $(VERBOSE) $(EXTRA)


.PHONY: localhost
localhost:
	$(ANSIBLE) -i localhost, -c local $(PLAYBOOK) --extra-vars @vars.yml -K
