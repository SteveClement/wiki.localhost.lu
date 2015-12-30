# Python Notes

:warning: Needs to be completed

# pip upgrade all

```
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
```

# Permutations 

```python
#!/usr/bin/env python
import itertools
from string import ascii_lowercase
import twitter

count = 0

api = twitter.Api()

# We now have a string of the alphabet in ascii_lowercase
complete_charset = ascii_lowercase + '_0123456789'

product=itertools.product(list(complete_charset), repeat=3)

for s in product:
  user = ''.join(s)
  try:
    api.GetUser(user)
  except ValueError:
    print user + "is still available"
  count += 1
  print count + "of 50653"
```

# References

[itertools](http://docs.python.org/library/itertools.html)

# Python on OSX

```
brew update
brew install pyenv pyenv-virtualenv
brew install python3
easy_install-3.5 pip
```

## Installing cocos2d in a pyenv

- mkdir ~/.venv
- pyvenv ~/.venv/sandbox
- pip install cocos2d

### In Shell start-up profile

```
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### Some commands

```
pyenv versions
pyenv install 3.4.2
pyenv versions
pyenv shell 3.4.2
python -V
cd .pyenv/
ls -1
ls -1 versions/
pyenv virtualenv 3.4.2 myvenv
pyenv virtualenvs
pyenv versions
pyenv shell myvenv
pip freeze
pip install django
which django-admin
pip freeze
```

# Pygame

Screen is the main window in pyGame
pygame has a lot of rectangular surface functions (you glue, ‘blit’ these pieces onto the screen, like you would in a flipBook)

# import pickle to store game data

## Use the pickle module to store game data

```python
import pickle
game_data = { ‘player_pos’ : ’N23 E45’, ‘pockets’: [‘keys’,’stone’, ‘pocket knife’], ‘money’ : 42.23 }
save_file = open(‘save.dat’, ‘wb’)
pickle.dump(game_data, save_file)
save_file.close()

load_file = open(‘save.dat’, ‘rb’)
loaded_game_data = pickle.load(load_file)
load_file.close()
```

# functions (and their return values)

## Interactive console

```python
>>> def sum(a,b):
...     result = a + b
...     return result
...
>>> sum(42,4.2)
46.2
>>> _ + 1
47.2
```

## sum.py

```python
def sum(firstValue, secondValue):
    result = firstValua + secondValue
    return result

sum(4,9)
```

## fib.py

```python
def fib(n):
    a,b = 0,1
    while b < n:
        print(b)    # try this print instead: print(b, end=',')
        a,b = b, a+b

fib(2000)
```

loops: else

floor division: 5 // 3
divmod(5,3) # Returns 2
5 % 3

Ranges in Python are not inclusive (-1)
Slices are ranges.

list[23:42:3]
slice: start,stop,step

list []
tuples () == immutable, speed, error prevention
dict {}

num = 10
foo = range(25)
num in foo

del
.insert
.extend
.remove

## variables (and types)

http://docs.python.org/3/library/stdtypes.html

### Numbers

#### int, float, bool

```
foo = 42
bar = 4.2

result = foo + bar

print(result)

type(foo)
type(bar)
type(result)
help(foo)

askMeAnything = input("Tell me anything: “)

type(askMeAnything)
```

more predictive typing:

```
askMeAnything = eval(input("Tell me anything: “)) # 42 || 4.2

type(askMeAnything)
```

You could use int() , float() but eval() is more flexible.
What about catching errors and making sure the range is respected when inputting numerals?

```python
def myFunction:
  while True:
      myInput = input("Gimme some data between 0 and 42: ")
      try:
         myInput = int(myInput)
         print("Good you managed to input something working :)")
      except ValueError:
         print("Valid number, please")
         continue
      if 0 <= myInput <= 42:
         break
      else:
         print("Valid range, please: 0-42")
``` 

Keywords: True, False

Try to assign True or False to a variable (pay attention to caps) and type() it.

**strings (are immutable)**

```
myString = ‘some random text’
myOtherString = ‘and don\’t forget to append ME!’
myHugeText = (‘If your text will be tooooooooo big you can always’
                           ‘go to a new line if you take care to put () and \’ :)’)

len(myString)

print(3*myString)
print(3*myString+myOtherString)
print(myHugeString[0])
print(myHugeString[5])
print(myHugeString[:5])
print(myHugeString[5:])
print(myHugeString[-1])
print(myHugeString[1:3] + myHugeString[7:9])
```

**lists (are mutable)**

```
squares = [ 1,2,4,9,16,25 ]
print(squares)
type(squares)

print(squares[0])  # -1 or 2:3 (return type?)

squares.append(6 ** 2)
```

**dictionaries**

```
notes = {‘do’: 293.66, ‘re’: 329.63}
notes[‘do’]
```

## BUTTONS with tkInter

http://effbot.org/tkinterbook/button.htm

```python
from tkinter import *

master = Tk()

def callback():
    print("click!")

b = Button(master, text="OK", command=callback).pack()

mainloop()
```

Task one:

Write a number guessing game-show that asks the Show host:

- The guessing range: e.g. 23-42
- The number of tries the player is allowed

Code challenge: x-player mode how to implement

thought challenge: timer

Task two:

Give audible feed-back depending on how far the player is away. Chose you own scheme, like the closer you are the higher pitched the sound or the closer the the shorter the sound

Task three:

Instead of using the keyboard use a set of buttons as the user interface.

(keep it simple in the beginning)

conditional values:

```python
a= 1
b= 2
s = “true” if a < b else “false”

def foo(param=23):
     print(“The default is: “ + str(param))
```

foo = ‘’’\
f
gfh
ghf

‘’'

fooTwo = “”"\
Multi-line foo
but what does the \\ do?
“”"

print(“So many beautiful ways to include {} :D”.format(foo))

print(“So many beautiful ways to include {0} or {1} or perhaps {2} and again {0} :D”.format(foo,bar,qux))

print(“So many beautiful ways to include {foo} or {bar} or perhaps {qux} and again {0} :D”.format(foo = 23,bar = 42,qux = 31337))

Or in adictionary:

dArgs = dict ( foo = 23, bar = 42, qux= 31337)
print(“So many beautiful ways to include {foo} or {bar} or perhaps {qux} and again {0} :D”.format(**dArgs))

words  = s.split()

s = ‘I:am:a:little:confused'
‘, ‘.join(s)

id()

foo = “42”
fooTwo = 42

foo is fooTwo

case/switch

choicesAlternate = { one:’first'     }

choices = dict(
one = ‘first’,
two = ‘second’,
three =  ‘third’,
four = ‘fourth’,
five = ‘fifth’,
six =  ‘sixth’,
seven =  ‘seventh'
)

selector = 'second'
print(choice[selector])
print(choices.get(selector, ‘other’))

regex:

```python
match = re.search(‘(G|M)ore’, inputLine) # Searches and returns Bool

print(match.group()) #

re.sub('(M|G)ore', 'foo')

pattern = re.compile('(M|G)ore', re.IGNORECASE)
```

```python
try:
     for line in readfile(‘foo.txt’): print(line.strip())
except IOError as e:
     print('Cannot read file:', e)
execept ValueError as e:
     print('Bad filename', e)

def readfile(filename):
     if filename.endswitch('.txt'):
          fh = open(filename)
          return fh.readlines()
     else: raise ValueError('Filename must end in .txt')

def main():
     foo()

def foo(bar=42, baz=None):
     print(‘foo’)
     if baz is None:
          baz= 23

def qux():
     pass

if __name__ == “__main__”: main()

def quux(uno, duo, *args):
     print(uno, duo, args)

# args is a tuple

foobar(5,6,7,8, one=1, two=42)

def foobar(uno, due, *args, **kwargs):
     print('kwargs are a dictionary: ' kwargs['one', kwargs['two']])
```

unbuffered:

```python
fh = open('foo.txt', 'w')
print("foo into file", file = fh)
```

buffered IO Mode:

```python
bufferSize = 5000
inFile = open ('bigfoo.txt', 'r')
outFile = open('foo.txt', 'w')
buffer = infile.read(buffersize)
while (len):
     outFile.write(buffer)
     buffer = inFile.read(bufferSize)
```

SQlite3:

```python
import sqlite3
db.row_factory = sqlite3.Row # returns row objects that can be used like a dictionary
db = sqlite3.connect('newDB.db')
db.execute('drop table if exists test')
db.execute('create table test (t1 text, i1 int)')
db.execute('insert into test (t1, i1) values (?, ?), ('one', 1)')
db.commit()
cursor = db.execute('select * from test order by t1')
for row in cursor:
     print(row)
```

# Classes

Classes are how you create your own objects.
A class is the blueprint of the object.
An object is an instance of a class.

## Creating objects

```python
class Egg:
     def __init__(self, kind = “fried”):
          self.kind = kind

     def whatKind(self):
          return self.kind

# object fried of Egg
fried =  Egg()
scrambled = Egg(‘scrambled’)
print(scrambled.whatkind())
print(fried.whatkind())

print("unRaw text is \n not really raw!")
print(r"Raw text is \n really raw!")
```


The duck class :)

```python
#!/usr/bin/env python3

class Duck:
     def __init__(self):
          print("Just loaded the Duck class")

     def quak(self):
          print ("Quaaaack!")
     def walk(self):
          print("Duck Walk")

def main():
     donald = Duck()
     donald.quack()
     donald.walk()

if __name__ == "__main__": main()
```

methods are function (self) is a reference to the class

encapsulation via __init__

loosely typed: duck typing, if it walks like at duck it looks like a duck

## External classes

Integrating external classes in Python is fairly simple. But the plethora of different terms can be daunting.

To import an external class you need to use the *import* statement.

Your class can reside in a self-contained file with the extension *.py* and is defacto treated as any other module.

:warning: If you import a module named **turtle** for example and your file is called **turtle.py** this will \#fail. Make sure to have unique names that do not clash with any classes that are built-in Python modules.

Another way of importing external classes is to create a *package*.

Packages are directories with an *__init__.py* file and other python files needed for your package.

As long as this directory is in your current path it can be imported as any other module.

To get the current path in your Python project you can use the following simple code.

```python
import sys
print(sys.path)
```

## More on modules

There are many ways to import a module…

### import X

imports module X into your current name-space. Meaning you need to specify **X.foo** every time you access your module.

### from X import *

imports everything from X into the current name-space. Letting you omit X altogether and allowing you to call **foo** directly.
The common example is *tkinter*. Simply using **from tkinter import \*** allows for more readable code.

### from X import foo, bar, quux

This creates references to *foo*, *bar* and *quux* in the current name-space.

### X = __import__('X')

Same as *import X* but you pass the module name as a *string* and you explicitly assign it to a variable in your current name-space.

### Tweaks

Invoking Python with -O or -OO reduces the size of a compiled module. *-O* removes assert statements and *-OO* removes assert statements and *__doc__* strings.

### .pyc

These files do not run faster, but only load faster.

### compileall

This module can create *.pyc* files for all modules in a directory.

### dir()

This built-in can be used to find out which names a module defines.

dir() does not list the names of built-ins. To achieve this **import builtins** then **dir(builtins)**

### reload

Imported modules are only imported once (efficiency)
To reload a module, **import imp** then **imp.reload(modulename)**

### PYTHONPATH

A variable much like PATH but for other Python Modules.

### from my.large.module import stuff

Will import the module stuff from a directory structure *my/large/module*
To use the **\*** the file *__init__.py* must be present in the directory.