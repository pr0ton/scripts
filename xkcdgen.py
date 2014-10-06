#!/usr/bin/env python

# https://xkcd.com/936/

import random

with open("/usr/share/dict/words") as f:
  words = [w.replace('\'', '') for w  in f.readlines()]
  print "_".join(i.strip() for i in random.sample(words, 4))