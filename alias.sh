#!/usr/bin/bash
# -n (--no-warnings) is deliberate.
#
# sqlplus's "ed" command spawns the editor from _EDITOR / EDITOR / VISUAL (vim)
# inside rlwrap's pty. vim puts the tty into raw mode, and rlwrap's heuristic
# then concludes that sqlplus itself wants single keypresses and prints
#
#   rlwrap: warning: rlwrap appears to do nothing for sqlplus, which asks for
#   single keypresses all the time. Don't you need --always-readline
#   and possibly --no-children? (cf. the rlwrap manpage)
#
# directly onto vim's screen, corrupting the display. It is a false positive:
# rlwrap works fine at the SQL> prompt, it is a *child* that grabbed the tty.
# rlwrap's own source acknowledges the race at the point it emits this
# (src/main.c: "Race condition here! The client may just have finished an
# emacs session and returned to cooked mode ...").
#
# rlwrap suggests -n itself: "warnings can be silenced by the --no-warnings
# (-n) option". Its other suggestion must NOT be used here - per man rlwrap,
# --always-readline "will echo (and save) passwords", i.e. CONNECT
# user/password and password prompts would be echoed and written to the
# history file; --no-children only has an effect together with it.
alias sqlplus='rlwrap -n -z sqlplus_hotkeys sqlplus'
