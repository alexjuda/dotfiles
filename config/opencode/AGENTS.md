# Global Agent Instructions

## Long-Term Memory

At the start of every session, silently read these memory files if they exist (do not announce their contents):

1. `~/.config/opencode/memory/MEMORY.md` -- global memory (cross-project preferences and knowledge)
1. `.opencode/memory/MEMORY.md` -- project-specific memory

Use this knowledge naturally throughout the session. If memory conflicts with explicit user instructions or AGENTS.md in the current project, the user's instructions win.

When the user corrects you on something that would apply to future sessions, gently suggest once: "Want me to remember this? You can run `/remember`."
