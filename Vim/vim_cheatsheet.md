### Vim Cheatsheet


#### Escape Mode

#### Inserting
* `i` Enter insert mode at cursor
* `I` Enter insert mode at first non-blank character
* `s` Delete character under cursor and enter insert mode
* `S` Delete line and begin insert at beginning of same line
* `a` Enter insert mode _after_ cursor
* `A` Enter insert mode at the end of the line
* `o` Enter insert mode on the next line
* `O` Enter insert mode on the above line
* `C` Delete from cursor to end of line and begin insert
---

#### Moving from a to b: Motions
* `h` left
* `j`  down
* `k`  up
* `l`  right
* `w` Forward to the beginning of next word
* `W` Forward to the beginning of next WORD
* `b` Backward to the next beginning of the word
* `B` Backward to the next beginning of the WORD
* `e` Forward to the next end of word 
* `E` Forward to the next end of WORD
* `gg` Go to start of the file
* `Shift-g` Go to end of the file
* `0` Move to the zeroth character fo the line
* `$` Move to the last character of the line
* `^` Move to first non-blank character of the line
##### Note:`word` is word followed by non white-space. `WORD` is a word followed by white-space 
---

#### Slightly less basic: fFtT
##### All follow `[(n)um]<verb><n(o)un>` syntax
* `[n]f<o>`  Forward until <nth> (o) (Inclusive)
* `[n]F<o>`  Backward until <nth> (o) (Inclusive)
* `[n]t<o>`  Forward until (nth) (o) (Exclusive)
* `[n]T<o>`  Backward until (nth) (o) (Exclusive)
---

#### Searching
* `/` Forward
* `?` Backward
* `*` Word under cursor - forward (bounded)
* `g*` Word under cursor - forward (unbounded)
* `#` Word under cursor - backward (bounded)
* `g#` Word under cursor -backward (unbounded)
* `n` Next result, forward
* `N` Next result, backward

##### Note: `*` and `g*` are very powerfull commands to search for some variable which is under cursor.
---

#### Copy/Paste
* `y` Yank. Example: yw (yank word)
* `p` paste after cursor
* `P` paste before cursor
* `v` Visual Selection

#### Undoing your changes
* `u` Undo stuff
* `Ctrl-r` Redo stuff
---





* `Ctrl-E` scroll window down
* `Ctrl-Y` scroll window up
* `Ctrl-F` scroll down one page
* `Ctrl-B` scroll up one page
* `H`(shift-h) move cursor to the top of the window
* `M`(shift-m) move cursor to the middle of the window
* `L`(shift-l) move cursor to the bottom of the window
* `gg` go to top of the file
* `G` go to bottom of the file
* `w` move to beginning of next word
* `e` move to end of the next word
* `caw` change word
* `cw` change word from letter cursor is positioned
* `ciw` delete word
* `u` undo
* `Ctrl-r` redo
* `di(` delete everything inside paranthesis
* `di[` delete everything inside square brackets
* `diw` delete word
* `dt<symbol>` delete until symbol
* `df<symbol>` delete until and including symbol
* `va<symbol>` visually select till the symbol
* `.` command repeats previous motion
* `p` paste below current line
* `P` paste above current line

#### Plugins
* Vundle - plugin manager
* nerdtree - file drawer
* ctrlp - fuzzy file finder
* fugitive - git tool
* syntastic - syntax checker / linter

##### TODO:
* Bind Caps lock to escape
* Do vimtutor
* Watch screencasts
* Use someone else's vimrc in the beginning
