Annoyingly Pi doesn't follow XDG so configs are interleaved with generated files.

* `ln -s $PWD/config/pi/settings.json ~/.pi/agent/settings.json`.
* `ln -s $PWD/config/pi/auth.json ~/.pi/agent/auth.json`. It says "auth" but I never keep credentials in plain text files so it's safe to commit.
