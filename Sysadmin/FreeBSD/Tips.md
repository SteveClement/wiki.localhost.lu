# Disable system beep (bell)

To enable or disable bell use MIB hw.syscons.bell under FreeBSD operating systems.
Type the following command to disable for current session:

```
# sysctl hw.syscons.bell=0
```

Make sure settings remains same after you reboot the machine, enter:

```
# echo "hw.syscons.bell=0" >> /etc/sysctl.conf
```

# Install pip3

python3.5 -m ensurepip
pip3 install -U pip
