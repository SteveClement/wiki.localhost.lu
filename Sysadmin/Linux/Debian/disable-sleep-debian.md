# Disable Sleep / Suspend on a Debian Desktop Laptop

This guide covers all the common layers where sleep/suspend can be triggered on a stock Debian desktop install (GNOME, KDE, XFCE, etc.) and how to disable each one.

---

## 1. Systemd (logind) — Lid Close & Idle Suspend

Edit the logind configuration:

```bash
sudo nano /etc/systemd/logind.conf
```

Find and set the following options (uncomment if needed):

```ini
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
```

Apply the changes:

```bash
sudo systemctl restart systemd-logind
```

> **Note:** Restarting `systemd-logind` will briefly disconnect your session. On a headless or remote system, prefer rebooting instead.

---

## 2. Systemd — Mask Suspend & Sleep Targets

Prevent the system from suspending or sleeping at the kernel/systemd level entirely:

```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

To re-enable later:

```bash
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

---

## 3. GNOME — Power Settings (if using GNOME Shell)

Via the GUI:

- Open **Settings → Power**
- Set **Screen Blank** to `Never`
- Set **Automatic Suspend** to `Off`

Via the command line (as your user, not root):

```bash
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing'
gsettings set org.gnome.desktop.session idle-delay 0
```

---

## 4. XFCE — Power Manager (if using XFCE)

Via the GUI:

- Open **Applications → Settings → Power Manager**
- Under the **System** tab: set **System sleep mode** to `Never`
- Under the **Display** tab: disable screen blanking and DPMS

Via the command line:

```bash
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-battery -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-ac -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-battery -s 0
```

---

## 5. Screen Blanking / DPMS (X11)

Disable screen blanking and DPMS (Display Power Management Signaling) for the current session:

```bash
xset s off
xset -dpms
xset s noblank
```

To make this persistent, add the above lines to your `~/.xprofile` or create an X11 config file:

```bash
sudo nano /etc/X11/xorg.conf.d/10-nodpms.conf
```

```
Section "ServerFlags"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime"     "0"
    Option "BlankTime"   "0"
EndSection

Section "Monitor"
    Identifier "Monitor0"
    Option "DPMS" "false"
EndSection
```

---

## 6. Verify Everything Is Disabled

Check that suspend targets are masked:

```bash
systemctl status sleep.target suspend.target
```

Check logind configuration is active:

```bash
loginctl show-session $(loginctl | awk '/tty/ {print $1}' | head -1) | grep -i idle
```

Check current DPMS status:

```bash
xset q | grep -A3 "DPMS"
```

---

## Summary Table

| Layer | Method | Scope |
|---|---|---|
| `systemd-logind` | `/etc/systemd/logind.conf` | System-wide |
| Systemd targets | `systemctl mask` | System-wide |
| GNOME power | `gsettings` / GUI | Per-user |
| XFCE power | `xfconf-query` / GUI | Per-user |
| X11 DPMS | `xset` / xorg.conf | Session / System |

For a laptop that should **never** sleep under any circumstances (e.g. a server or kiosk), applying **steps 1, 2, and 5** is the most robust combination.
