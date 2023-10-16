### sqlplus_fzf
Some enhancements to sqlplus UI based on rlwrap and fzf

### Introduction
There are couple of fuzzy search tools available, to mention a few -
- [skim](https://github.com/lotabout/skim) (written in rust)
- [peco](https://github.com/peco/peco) (written in go)
- [fzf](https://github.com/junegunn/fzf) (written in go)
They have very similar functionality as well - user interface, however, [fzf](https://github.com/junegunn/fzf) is probably most popular (at least - according to the github stars) and it was the first one i stumbled upon among similar utilities, so in this setup i'll focus only on [fzf](https://github.com/junegunn/fzf), though - it can be done with each other fuzzy search tool from mentioned above in the exact the same or similar way. 
[Fzf](https://github.com/junegunn/fzf) provides very impressive out of the box features, which increase enormously speed of working in the linux terminal (though - it is available for all major platforms - also, mac and windows either)
To mention a few:
- reverse history search (bound by default to `Ctrl-R`)
- file search, optionally with preview (bound by default to `Ctrl-T`)
 
The goal of this setup is to have the same user experience which [fzf](https://github.com/junegunn/fzf) provides to shell - in another cli applications, for instance in sqlplus.
One of possible solutons is to use [rlwrap](https://github.com/hanslub42/rlwrap) (readline wrapper) as the intermediate layer between cli and [fzf](https://github.com/junegunn/fzf). Using an alias like `alias sqlplus="rlwrap sqlplus"` is a well known approach to bring readline editing capabilities to sqlplus, however, till recently i was not aware, that [rlwrap](https://github.com/hanslub42/rlwrap) (at least recent versions) brings very powerful capability of using filters and provides even set of predefined filters - one of them is called hande_hotkeys and there is even defined hotkey mapping for [fzf](https://github.com/junegunn/fzf), so very little things are remaining to do.

https://github.com/Maxim4711/sqlplus_fzf/assets/3840386/b25739ce-059e-4882-b8bc-def6017d02b0

### Implementation

- add hotkey handler for finding sql scripts - for example - all sql scripts from the home directory, or the set of directories defined in `ORACLE_PATH` or `SQLPATH`
- add a preview option with a pager with syntax highlighting capabilities
- add the chosen hotkeys to local .inputrc

### Keybindings 
- `Ctrl-R` is bound to history search
- `Ctrl-T` - to search sql script with preview, in fzf window Enter brings the selection (with `@` sign prepended) back to sqlplus `ESC` or `Ctrl-C` exits the [fzf](https://github.com/junegunn/fzf) window and goes back to sqlpus without selection
- `Alt-down` bound to scroll down preview 
- `Alt-up` to scroll up preview, the mouse is activated (to disable - call [fzf](https://github.com/junegunn/fzf) with `--no-mouse` option) and preview can be scrolled with the mouse wheel either 
- `Shift-left-mouse` does linewise selection  
- `Alt-left-mouse` does the blockwise selection - as can be seen in the screencast, If using in a putty session - selection is automatically copied to the clipboard, but many other terminals (e.g. - kitty, iterm2, wezterm, etc) can be configured in similar way. Keybindings for linewise/blockwise selection are dependent on the terminal used - the mentioned above are for putty, in kde konsole the modifiers are different - for example, blockwise selection is done with `Ctrl-alt-left-mouse`
 
### Prerequisites: 
- [fzf](https://github.com/junegunn/fzf) installation is pretty simple - i prefer to just clone the github repository
- [rlwrap](https://github.com/hanslub42/rlwrap) - in OEL 8 is provided via ol8_developer_EPEL repository and can be installed with dnf, i prefer however the local installation (compile from source) - because often user who
uses sqlplus (typically - oracle) doesn't have root rights, it makes as well easier placement of rlwrap filter, though - if directory of rlwrap filter is not accessible, custom filter can be placed in any directory if this directory is configured as `RLWRAP_FILTERDIR` env variable, additionally RlwrapFilter.pm has to be copied or symlinked there.
- pager with syntax highlighting - i have found not too many alternatives, the simplest one is [bat](https://github.com/sharkdp/bat), another one - less with [gnu source-highlight](https://github.com/scopatz/src-highlite), [moar](https://github.com/walles/moar) with [chroma](https://github.com/alecthomas/chroma) and finally vim/neovim. If syntax hihlighting is not required - then cat, less, more, most can be used. Anyway, this setup uses [bat](https://github.com/sharkdp/bat) which can be downloaded as [prebuilt binary](https://github.com/sharkdp/bat/releases) into a directory on the path, or just `cargo install bat` if rust toolchain is installed.

setup_oel8.sh shell script tries to perform automated installation of whole toolchain from scratch, however, it is very difficult to test all possible configurations, therefore - intention is rather not to execute this script as is, but copy/paste single statements and modify them accordingly to local configuratin if required. Assumption is - the oracle client setup is already available and the set of sql scripts either, if not - one of popular public sql script repositories can be cloned - for example from [Tanel Poder](https://github.com/tanelpoder/tpt-oracle), [Sayan Malakshinov](https://github.com/xtender/xt_scripts) or [Carlos Sieerra](https://github.com/carlos-sierra/cscripts)
