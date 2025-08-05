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



config.set('url.start_pages', ['https://www.google.com']) # startup page
config.set('url.default_page', 'https://www.google.com') # new tab page
config.set('url.searchengines',{
    'DEFAULT': 'https://www.google.com/search?q={}',
    'y': 'https://www.youtube.com/results?search_query={}',
    'gs': 'https://scholar.google.com/scholar?q={}',
    'gh': 'https://github.com/search?q={}',
    'n': 'https://search.naver.com/search.naver?query={}',
    'nd': 'https://dict.naver.com/dict.search?dicQuery=%s&query={}',
    'nm': 'https://namu.wiki/Go?q={}',
})

# fonts - tab / completion menus
config.set('fonts.default_family', ['FiraCode Nerd Font Mono', '맑은 고딕'])
config.set('fonts.default_size', '11pt') # for notebook


# open new instance of cmd, and open nvim with command(-c) to go to {line} and first column
# it will affect to <Ctrl-e> in insert mode
c.editor.command = ["cmd", "/c", "start", "/wait", "nvim", "{file}", "-c", "normal {line}G{column0}l"]

# colors
config.set('colors.tabs.selected.even.bg', '#FF8D00')
config.set('colors.tabs.selected.even.fg', '#000000')
config.set('colors.tabs.selected.odd.bg', '#FF8D00')
config.set('colors.tabs.selected.odd.fg', '#000000')

# BUG: `c.colors~ = True` format has some bug which is not applied perfectly for all url like naver.com
config.set('colors.webpage.preferred_color_scheme', 'dark') # if the webpage supports dark mode, it apply
config.set('colors.webpage.darkmode.enabled', True)
config.set('colors.webpage.darkmode.policy.images', 'smart-simple')

# session
config.set('auto_save.session', False)

# cookies
config.set('content.cookies.accept', 'no-3rdparty')

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


# downloads
download_dir = '~/Desktop'
config.set('downloads.location.directory', download_dir)
config.set('downloads.location.prompt', False) # don't ask to confirm
config.set('downloads.location.suggestion', 'both') # path + filename
config.set('downloads.remove_finished', 3) # wait time to remove download finished alarm
config.set('downloads.position', 'bottom') # show download progress bar on bottom


# file select
config.set('fileselect.handler', 'external') # set yazi as fileselect handler along to below setting
config.set('fileselect.folder.command', ['cmd', '/c', 'yazi', '--cwd-file={}'])
config.set('fileselect.multiple_files.command', ['cmd', '/c', 'yazi', '--chooser-file={}'])
config.set('fileselect.single_file.command', ['cmd', '/c', 'yazi', '--chooser-file={}'])


# input mode
config.set('input.insert_mode.auto_load', True) # Automatically enter insert mode if an editable element is focused after loading the page.

# messages
config.set('messages.timeout', 1000) # duration [ms] to show messages

# search
config.set('search.wrap', False)
config.set('search.incremental', False) # search after Enter

# tabs
config.set('tabs.close_mouse_button', 'right') # right button is close tab
config.set('tabs.last_close', 'close') # close window when last tab is close
config.set('tabs.select_on_remove', 'last-used') # focus last-used tab after current tab is closed

























######## key binding #########
# [!] mark means important key
# -- scrolling
config.bind('j', 'scroll up', mode='normal' )
config.bind('k', 'scroll down', mode='normal' )
# gu : navigate up

# -- tab management
config.bind('q', 'tab-close', mode='normal' ) # tab close and go to left tab
config.bind('J', 'tab-prev', mode='normal' )
config.bind('K', 'tab-next', mode='normal' )
# Ctrl+Tab : go to last focused tab
# [!] Alt+num : move focus to tab (num)
config.bind('<Ctrl-Shift-k>', 'tab-move +', mode='normal' ) # move tab right
config.bind('<Ctrl-Shift-j>', 'tab-move -', mode='normal' ) # move tab left
config.unbind('gm') # move tab to first column
# [!] gC : tab-clone
# [!] gD : detach current tab to new window
# [!] go : edit current url and open in current tab
# [!] gO : edit current url and open in new tab
# [!] wo : input new url and open in new window
# [!] wO : edit url and open in new window
config.bind('ww', 'tab-only', mode='normal') # close other tabs
config.bind('wq', 'tab-only --next', mode='normal') # close tabs on left
config.bind('we', 'tab-only --prev', mode='normal') # close tabs on right
# [!] T : show tab select window (go to with number)
# gt : show tab select window (go to with number/string)
config.unbind('d')  # remove tab
config.unbind('co') # tab-only
config.unbind('xo') # input new url and open with unfocused tab
config.unbind('xO') # edit url and open with unfocused tab
config.unbind('<Ctrl-p>') # tab pin





# -- window management
# [!] <C-n> : open new window
# [!] <C-S-n> : open new private window
# <C-S-w> : close window (all tabs)


# -- history
config.bind('gh', 'home', mode='normal') # go to homepage
# [!] Sh : big search in history
config.unbind('th') # go to prev page with new tab
config.unbind('wh') # go to prev page with new window
config.unbind('<Ctrl-h>') # go to homepage

# -- hint
config.unbind('wf') # hint all window
config.unbind(';b') # show hint and open unfocused new tab
config.unbind(';f') # it replaced with F
config.unbind(';h')
config.unbind(';i')
config.unbind(';I')
config.unbind(';o')
config.unbind(';O')
config.unbind(';R') # ;r for new window, but cannot continuous
config.unbind(';t') # hint input
config.bind('f', 'hint', mode='normal' ) # show hint and open in current tab
config.bind('F', 'hint all tab-fg', mode='normal' ) # show hint and open in new tab and focus
config.bind(';i', 'hint inputs', mode='normal' ) # show hint on input only
# ;y : hint for yank links
# ;Y : hint for yank links to primary clipboard (linux only)
# ;r : show hint and continuous open in new tab unfocused

# streaming using mpv is too slow, yt-dlp is the best.
userscript_dir = '~/.config/Dotfiles/qutebrowser/config/userscripts/'
config.bind(';m', f'hint links spawn cmd /c start yt-dlp -P "{download_dir}" {{hint-url}}', mode='normal') # download video using yt-dlp
# download file and open automatically (spawn --userscript doesn't recognize userscript file)
config.bind(';d', 'hint links userscript download_and_open.cmd', mode='normal')



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
config.bind('p', 'open -- {clipboard}') # open url from yy
config.bind('P', 'open -t -- {clipboard}') # open url from yy with new tab
config.bind('wP', 'open -w -- {clipboard}') # open url from yy with new window
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
# ' : jump to scroll mark
config.bind('mq', 'quickmark-save') # mark for page using a character (useful more than bookmark)
config.bind('bo', 'cmd-set-text -s :quickmark-load') # mark for page using a character (useful more than bookmark)
config.bind('bO', 'cmd-set-text -s :quickmark-load -t') # mark for page using a character (useful more than bookmark)
config.bind('mb', 'bookmark-add') # add bookmark
config.bind('Bo', 'cmd-set-text -s :bookmark-load') # mark for page using a character (useful more than bookmark)
config.bind('BO', 'cmd-set-text -s :bookmark-load -t') # mark for page using a character (useful more than bookmark)
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






# -- command mode / completion mode
config.bind('<Ctrl-k>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-j>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl-c>', 'completion-item-del', mode='command') # remove items from completion menu
# <ctrl+tab> : next completion category
# <ctrl+shift+tab> : prev completion category
# <Ctrl+Enter> : open/execute the item without closing menu
config.bind('<Ctrl-h>', 'rl-backward-char', mode='command')
config.bind('<Ctrl-l>', 'rl-forward-char', mode='command')
config.bind('<Alt-h>', 'rl-backward-word', mode='command')
config.bind('<Alt-l>', 'rl-forward-word', mode='command')
config.bind('<Ctrl-d>', 'rl-delete-char', mode='command')
config.bind('<Ctrl-Alt-l>', 'rl-kill-word', mode='command') # remove word wise
config.bind('<Ctrl-Alt-h>', 'rl-backward-kill-word', mode='command') # remove word wise



# -- insert mode
# <Ctrl-e> : open external editor
#            if cursor in text box to insert any text, it can be written using external editor like neovim
#            After I edit the content in neovim and :wq, the final contents are inputted in web text box.

# escape from insert mode and change ime to english
config.bind('<Escape>', 'mode-leave ;; spawn --userscript ime_change.cmd', mode='insert')



# -- passthrough mode
# it is the same with `resident mode` in win-vind




# -- misc
config.unbind('<Ctrl-v>') # view-source
# <Ctrl-Alt-p> : print page




# -- config-cycle
# tsh ~ tCh : quick change config with cycle
# `config-cycle <config_name> <value1> <value2> <value3>` : change value 1~3
# -p : print what setting is applied
# -u : url pattern (config-change is applied to current url page only)
# -t : temp value
config.bind('tda', 'config-cycle -p -u {url} colors.webpage.darkmode.enabled False True ;; reload', mode='normal')













######## commands #########
# :version = show info of qutebrowser
# :config-edit = edit current config file
# :config-source = source current config file
# :bind = show current key binding
# :histroy = show history list and go to with f
# :histroy-clear -f = clear history


