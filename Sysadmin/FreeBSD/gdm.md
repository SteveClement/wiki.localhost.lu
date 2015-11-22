# GDM on FreeBSD

## How do I add new GDM sessions?

The process for adding new GDM sessions has changed substantially between GNOME 2.2 and 2.30. In order to add new sessions now, you must create a .desktop file containing the session configuration information. Session files live in /usr/local/etc/dm/Sessions. For example, to add a KDE session, create a file in /usr/local/etc/dm/Sessions called kde.desktop. That file should contain the following:

```
[Desktop Entry]
Encoding=UTF-8
Name=KDE
Comment=This session logs you into KDE
Exec=/usr/local/bin/startkde
TryExec=/usr/local/bin/startkde
Icon=
Type=Application
```

This file must have execute permissions. For example:

```
# chmod 0555 kde.desktop
```

After creating this file, restart GDM, and there will be a KDE link under the Sessions menu.