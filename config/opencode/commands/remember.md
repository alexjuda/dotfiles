---
description: Save learnings from this session to long-term memory
---

Use the `agent-memory` skill to manage memory. Load it now.

Review the current session and identify information worth persisting across sessions. If $ARGUMENTS is provided, specifically save that information. Otherwise, analyze the full conversation for corrections, preferences, debugging insights, architecture knowledge, and other reusable facts.

Steps:

1. Load the `agent-memory` skill for formatting and location rules.
1. Read `~/.config/opencode/memory/MEMORY.md` (global memory).
1. Read `.opencode/memory/MEMORY.md` (project memory, if it exists).
1. Identify what's worth saving from this session. Classify each item as global or project-specific.
1. Update the appropriate memory file(s). Create the project memory directory and file if needed.
1. Report what you saved and where.

If $ARGUMENTS is provided, save this specific information: $ARGUMENTS
