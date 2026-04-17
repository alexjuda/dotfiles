---
description: Show what the agent remembers from previous sessions
---

Read and summarize the agent's long-term memory.

Steps:

1. Read `~/.config/opencode/memory/MEMORY.md` (global memory) if it exists.
1. Read `.opencode/memory/MEMORY.md` (project memory) if it exists.
1. If $ARGUMENTS is provided, search for entries related to that topic and show only relevant items.
1. Otherwise, present a brief summary of both memory files, organized by category.
1. If neither file exists, say so and suggest running `/remember` to start building memory.

If a topic was specified, search for: $ARGUMENTS
