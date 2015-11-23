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
