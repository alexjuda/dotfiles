# Makefile for Ansible
# Created: 2025-05-01
# Purpose: Simplified ansible execution for localhost management
#
# Usage:
#   make localhost         # Run on localhost (as root via sudo, triggers fingerprint once)
#   make localhost -e "KEY=VALUE"  # Pass extra variables
#
# Note: Uses `sudo` to run ansible as root, which avoids become prompts entirely.

.PHONY: nop
nop:
	@echo Hello, world!

# Optional
EXTRA =
PLAYBOOK = playbooks/main.yml

ANSIBLE := ansible-playbook

.PHONY: localhost
localhost:
	sudo $(shell which $(ANSIBLE)) -i localhost, -c local $(PLAYBOOK) --extra-vars @vars.yml $(EXTRA)

# For remote hosts
HOST =

.PHONY: run
run:
	$(ANSIBLE) -i "$(HOST)," $(PLAYBOOK) --extra-vars @vars.yml -K $(EXTRA)
