####  misc

# 0) execute :adblock-update command periodically to prevent adblock
# 1) `config` object use function / `c` object use string,array
#   but these are same
# 2) all keymaps recognize english, not korean. you must change to english key
# 3) hint has bug that doesn't show 2nd focused hint. if there are sub-layout
#   vimium-c can do. but mutiple layout in naver.com has bugs both firefox / qutebrowser
#   it seems vim-like behavior optimized by google.com
# 4) in gemini, it cannot focus automatically to reply contents as like vimium-c



# explicit how to read autoconfig.yml
# if qutebrowser is opened with --baredir flag, it must be needed
config.load_autoconfig()

# for google login
# The issue of 'Signing in' displaying forever when login in to Google in Qutebrowser
# is not a problem with Qutebrowser itself. When Google blocks logins from some browsers or
# "unsafe or unsupported" apps for security reasons.
# This can be caused by the QtWebEngine used by Qutebrowser being detected by Google as an
# "embedded browser framework".
# TODO: change user agent (string to detect browser) to avoid prevent this browser in google
# TODO: change user agent as firefox / chrome. it will apply in google.com only
config.set('content.headers.user_agent', 'Mozilla/5.0 (Windows NT 10.0; rv135.0) Gecko/20100101 Firefox/135', 'https://accounts.google.com/*')

# for ignoring unnecessary error like
# only one userscript type is allowed, if you add some pattern, just add pattern only
# 1) 'TrustedHTML' message when caret mode in google
# 2) 'TypeError' message in gemini when I input 'gi' to find input box
c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"],
                                             "userscript:_qute_js": ["*TrustedHTML*", "*TypeError*"],
                                             }

c.url.start_pages = ['https://www.google.com'] # startup page
c.url.default_page = 'https://www.google.com' # new tab page
c.url.searchengines = {
        'DEFAULT': 'https://www.google.com/search?q={}',
        'y': 'https://www.youtube.com/results?search_query={}',
        'gs': 'https://scholar.google.com/scholar?q={}',
        'gh': 'https://github.com/search?q={}',
        'n': 'https://search.naver.com/search.naver?query={}',
        'nd': 'https://dict.naver.com/dict.search?dicQuery=%s&query={}',
        'nm': 'https://namu.wiki/Go?q={}',
}
c.downloads.location.directory = '~\Desktop'
c.fonts.default_family = ['FiraCode Nerd Font Mono', '맑은고딕']


# open new instance of cmd, and open nvim with command(-c) to go to {line} and first column
# it will affect to <Ctrl-e> in insert mode
c.editor.command = ["cmd", "/c", "start", "/wait", "nvim", "{file}", "-c", "normal {line}G{column0}l"]

# colors
c.colors.tabs.selected.even.bg = '#FF8D00'
c.colors.tabs.selected.even.fg = '#000000'
c.colors.tabs.selected.odd.bg = '#FF8D00'
c.colors.tabs.selected.odd.fg = '#000000'

c.colors.webpage.preferred_color_scheme = 'auto'

# session
c.auto_save.session = False




######## key binding #########
# -- scrolling
config.bind('j', 'scroll up', mode='normal' )
config.bind('k', 'scroll down', mode='normal' )
# gu : navigate up

# -- tab management
config.bind('q', 'tab-close -o', mode='normal' ) # tab close and go to left tab
config.bind('J', 'tab-prev', mode='normal' )
config.bind('K', 'tab-next', mode='normal' )
# Alt+num : move focus to tab (num)
config.bind('gK', 'tab-move +', mode='normal' ) # move tab right
config.bind('gJ', 'tab-move -', mode='normal' ) # move tab left
config.unbind('gm') # move tab to first column
config.unbind('gC') # tab-clone
# gD : detach current tab to new window
# go : edit current url and open in current tab
# gO : edit current url and open in new tab
# wo : input new url and open in new window
# wO : edit url and open in new window
config.bind('ww', 'tab-only', mode='normal') # close other tabs
# close right/left tab is not implemented (needs to implements manually)
# T : show tab select window (go to with number)
# gt : show tab select window (go to with number/string)
config.unbind('d')  # remove tab
config.unbind('co') # tab-only
config.unbind('xo') # input new url and open with unfocused tab
config.unbind('xO') # edit url and open with unfocused tab
config.unbind('<Ctrl-p>') # tab pin
# config.bind('<Ctrl-q>', 'undo', mode='normal' )
# Ctrl+Tab : go to last focused tab





# -- window management
# <C-n> : open new window
# <C-S-n> : open new private window
# <C-S-w> : close window (all tabs)


# -- history
config.unbind('th') # go to prev page with new tab
config.unbind('wh') # go to prev page with new window
config.unbind('<Ctrl-h>') # go to homepage
config.bind('gh', 'home', mode='normal') # go to homepage
# Sh : history

# -- hint
config.bind('f', 'hint', mode='normal' ) # show hint and open in current tab
config.bind('F', 'hint all tab-fg', mode='normal' ) # show hint and open in new tab and focus
config.unbind('wf') # hint all window
config.unbind(';b') # show hint and open unfocused new tab
config.unbind(';f') # it replaced with F
config.unbind(';h')
config.unbind(';i')
config.unbind(';I')
config.unbind(';o')
config.unbind(';O')
# ;y : hint for yank links
# ;Y : hint for yank links to primary clipboard (linux only)
# ;r : show hint and continuous open in new tab unfocused
config.unbind(';R') # ;r for new window, but cannot continuous
# ;t : show hint only input (For text)


# -- visual
# v : into visual / into caret toggle
config.bind('k', 'move-to-next-line', mode='caret')
config.bind('j', 'move-to-prev-line', mode='caret')
# w, b, e : move cursor along to word
# o : reverse direction when visual mode
config.bind('K', 'scroll down', mode='caret')
config.bind('J', 'scroll up', mode='caret')


# -- yank
# yy : copy current url
# yd : copy url domain (standard url without parameter)
# yp : copy url with pretty (decode %20 or other parameter)
# ym : copy url with markdown format
config.bind('p', 'open -- {cliboard}') # open url from yy
config.bind('P', 'open -t -- {cliboard}') # open url from yy with new tab
config.bind('wP', 'open -w -- {cliboard}') # open url from yy with new window
config.unbind('pp')
config.unbind('pP')
config.unbind('PP')
config.unbind('Pp')
config.unbind('wp')


# -- mark
config.unbind('m')
config.unbind('M')
config.unbind('b')
config.unbind('B')
config.unbind('wb')
config.unbind('gb')
config.unbind('gB')
config.unbind('wB')
config.bind('mj', 'mode-enter set_mark') # mark for scroll
# ' : jumpt to scroll mark
config.bind('mq', 'quickmark-save') # mark for page using a character (useful more than bookmark)
config.bind('qo', 'cmd-set-text -s :quickmark-load') # mark for page using a character (useful more than bookmark)
config.bind('qO', 'cmd-set-text -s :quickmark-load -t') # mark for page using a character (useful more than bookmark)
config.bind('mb', 'bookmark-add') # add bookmark
config.bind('bo', 'cmd-set-text -s :bookmark-load') # mark for page using a character (useful more than bookmark)
config.bind('bO', 'cmd-set-text -s :bookmark-load -t') # mark for page using a character (useful more than bookmark)
config.bind('ms', 'session-save default') # mark for page using a character (useful more than bookmark)
config.bind('so', 'session-load default') # mark for page using a character (useful more than bookmark)


# -- devtools
config.unbind('wi')
config.unbind('wIh')
config.unbind('wIj')
config.unbind('wIk')
config.unbind('wIl')
config.unbind('wIw')
config.unbind('wIf')
config.unbind('gf') # view-source


# -- config-cycle
# tsh ~ tCh : quick change config with cycle
# `config-cycle <config_name> <value1> <value2> <value3>` : change value 1~3



# -- command mode / completion mode
config.bind('<Ctrl-k>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl-j>', 'completion-item-focus --history prev', mode='command')
# <ctrl+tab> : next completion category
# <ctrl+shift+tab> : prev completion category
# <Ctrl+d> : completion item delete
# <Ctrl+c> : completion item yank
# <Ctrl+Enter> : open/execute the item without closing menu
config.bind('<Ctrl-h>', 'rl-backward-char', mode='command')
config.bind('<Ctrl-l>', 'rl-forward-char', mode='command')
config.bind('<Ctrl-f>', 'rl-forward-word', mode='command')
config.bind('<Ctrl-b>', 'rl-backward-word', mode='command')
config.bind('<Ctrl-d>', 'rl-delete-char', mode='command')
# <Alt-backspace> : remove wordwise



# -- insert mode
# <Ctrl-e> : open external editor
#            if cursor in text box to insert any text, it can be written using external editor like neovim
#            After I edit the content in neovim and :wq, the final contents are inputted in web text box.


# -- passthrough mode
# it is the same with `resident mode` in win-vind

# -- misc
config.unbind('<Ctrl-v>') # view-source
# <Ctrl-Alt-p> : print page

######## commands #########
# :version = show info of qutebrowser
# :config-edit = edit current config file
# :config-source = source current config file
# :bind = show current key binding

