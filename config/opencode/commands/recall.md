---
description: Show what the agent remembers from previous sessions
---

Read and summarize the agent's long-term memory.

Steps:

1. Read `~/.config/opencode/memory/MEMORY.md`. If missing, say so and suggest `/remember`.
1. If $ARGUMENTS is provided, show only entries related to that topic.
1. Otherwise, present a brief summary organized by category.

If a topic was specified, search for: $ARGUMENTS
