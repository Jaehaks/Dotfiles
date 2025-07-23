## vimium

* pros
	- it supports more exact IME in search mode for korean.
	  but it cannot accept all characters in specific site.

* cons
	- it doesn't support keybinding in gemini web
	- it cannot focus to the new window when `moveTabToNewWindow`
	- it is reported that sometimes all keybindings are stopped


## vimium-c


* pros
	- it support keybinding in gemini web well. it focus the pane well.
	- it search from location where I searched before.
	  it doesn't the same with what I want so that it needs to find the word in current window
	- it show the searched word properly while n/N navigating (surfingkeys not)

* cons
	- it doesn't support exact IME in search mode for korean
		- it can be replaced combination with `<C-f>` the default firefox feature.
		- `<C-f>` does support korean well and it remember where it is at last time.
		- so enter '/' or 'v' after searching word with `<C-f>`
	- it cannot focus to the new window when moveTabToNewWindow

> [!NOTE] Note:
> actually, it seems good because it doesn't any bug except about IME



## tridactly


* pros
	- I can't find it....

* cons
	- it doesn't seem to follow philosophy of vim.
	- it use ctrl-F for scroll
	- '/' search word only once, n/N doesn't support continuous search
	- it show not only link tag but also blocks in f mode, it hides the word which is what I want to select
	- it doesn't work in gemini web
	- it has shit vomnibar when I use 'o' 'b', i cannot recognize what i choose one in current.

## surfingkeys


* pros
	- I can't find it....
	- it supports which-key default
	- it has less link tag when I put 'f' key. it doesn't annoying
	- it supports many tags to text anywhere when I insert visual mode.
	  it makes easy to find to copy word what i see.
	- it supports korean perfectly in search mode
	- it show all searched word at once
	- it supports pdf viewer in chrome

* cons
	- it show misaligned cursor in search mode (sometimes the word hides by other html element)
	- it supports j,k keybinding only chat list, not the content in gemini web.
	  it doesn't behavior what i expect in this site
	- very difficult to config
	- it searches the word at top page when I put '/'
	  but sometimes it cannot show properly what it detects

* soso
	- it supports vomnibar and it
