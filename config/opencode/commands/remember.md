---
description: Save learnings from this session to long-term memory
---

Use the `agent-memory` skill to manage memory. Load it now.

Review the current session and identify information worth persisting across sessions. If $ARGUMENTS is provided, specifically save that information. Otherwise, analyze the full conversation for corrections, preferences, debugging insights, architecture knowledge, and other reusable facts.

Steps:

1. Load the `agent-memory` skill for formatting and location rules.
1. Read `~/.config/opencode/memory/MEMORY.md` (create if missing).
1. Identify what's worth saving from this session.
1. Update the memory file. Merge with existing content, don't duplicate.
1. Report what you saved.

If $ARGUMENTS is provided, save this specific information: $ARGUMENTS
