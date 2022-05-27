Needs revision

After installing Python 2.6.5 on Max OS X 10.6.3 some problems occured with the paths.

```
export PYTHONPATH="/System/Library/Frameworks/Python.framework/Versions/2.6/Extras/lib/python/"
```

To selecto a differnt default Python do this:

```
$ sudo port install python_select
$ python_select -s
python26-apple
$ python_select -l
Available versions:
current none python26 python26-apple python27
$ sudo python_select python26
```

This will select the port installed Python 2.6 Version
