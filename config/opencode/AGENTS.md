# Global Agent Instructions

## Long-Term Memory

At the start of every session, silently read `~/.config/opencode/memory/MEMORY.md` if it exists (do not announce its contents).

Use this knowledge naturally throughout the session. If memory conflicts with explicit user instructions or AGENTS.md in the current project, the user's instructions win.

When the user corrects you on something that would apply to future sessions, gently suggest once: "Want me to remember this? You can run `/remember`."
