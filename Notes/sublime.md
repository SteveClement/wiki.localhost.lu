# Sublime 2/3

## subl

To use subl (the CLI for Sublime) make a symlink

```
mkdir ~/bin
ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```

## ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

### Linking from dotfiles

```
ln -s ~/dotfiles/sublime/Default.sublime-commands ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Default.sublime-commands
ln -s ~/dotfiles/sublime/Package\ Control.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Package\ Control.sublime-settings
ln -s ~/dotfiles/sublime/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
```

### Preferences.sublime-settings

```
{
    "caret_extra_width": 1,
    "caret_style": "phase",
    "close_windows_when_empty": true,
    "color_scheme": "Packages/Color Scheme - Default/Monokai.tmTheme",
    "copy_with_empty_selection": false,
    "dictionary": "Packages/Language - English/en_GB.dic",
    "drag_text": false,
    "draw_minimap_border": true,
    "draw_white_space": "all",
    "enable_count_chars": true,
    "enable_tab_scrolling": false,
    "font_face": "Source Code Pro",
    "font_options":
    [
        "no_round"
    ],
    "font_size": 17,
    "hide_minimap": true,
    "highlight_line": true,
    "highlight_modified_tabs": true,
    "hot_exit": false,
    "ignored_packages":
    [
        "Lua",
        "Markdown"
    ],
    "linenos": "inline",
    "match_brackets_contents": false,
    "match_selection": true,
    "match_tags": false,
    "open_files_in_new_window": false,
    "overlay_scroll_bars": "enabled",
    "preview_on_click": false,
    "remember_open_files": false,
    "rulers":
    [
        80,
        100,
        120
    ],
    "scroll_past_end": false,
    "scroll_speed": 5.0,
    "show_full_path": false,
    "sidebar_default": "medium",
    "spell_check": true,
    "tab_completion": false,
    "tab_size": 2,
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": true,
    "vintage_start_in_command_mode": true,
    "word_wrap": true
}
```

### Python3.sublime-settings

```
{
  "cmd": ["/usr/local/bin/python3", "$file"]
, "selector": "source.python"
, "file_regex": "file \"(...*?)\", line ([0-9]+)"
}
```

### Package Control

#### Installation

Click View -> Show Console

##### Sublime Text 3
```
import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

##### Sublime Text 2
```
import urllib2,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
```

#### Package\Control.sublime-settings

```
{
    "bootstrapped": true,
    "in_process_packages":
    [
    ],
    "installed_packages":
    [
        "Base16 Color Schemes",
        "BracketHighlighter",
        "GitGutter",
        "GMod Lua",
        "Language - French - Français",
        "LiveReload",
        "MarkdownEditing",
        "Package Control",
        "PackageResourceViewer",
        "Predawn",
        "rsub",
        "Solarized Color Scheme",
        "Swift for F*ing Sublime",
        "Syntax Highlighting for Sass",
        "Theme - Solarized Space",
        "WordCount",
        "x86 and x86_64 Assembly"
    ]
}
```

#### WordCount.sublime-settings

```
{
  "enable_live_count": true,

  "enable_readtime": false,
  "readtime_wpm": 200,
  "char_ignore_whitespace": true,

  "enable_line_word_count": false,
  "enable_line_char_count": false,

  "enable_count_chars": true,
  "enable_count_lines": false,

  "enable_count_pages": true,
  "words_per_page": 300,
  "page_count_mode_count_words": true,

  "whitelist_syntaxes": [],
  "blacklist_syntaxes": ["CSS", "SQL", "JavaScript", "Python", "PHP", "JSON"],

  "strip": {
    "php": [
      "<[^>]*>"
    ],
    "html": [
      "<[^>]*>"
    ]
  }
}
```
