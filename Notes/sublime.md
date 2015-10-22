# Sublime 2/3

## ~Library/Application Support/Sublime\ Text\ 3/Packages/User
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
    "theme": "predawn.sublime-theme",
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

### Package\Control.sublime-settings

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

### WordCount.sublime-settings

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