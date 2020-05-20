#!/bin/python3
import sys

def string_reverse(s):
    assert type(s) == str, "'s' must be a string."

    return ''.join(reversed(list(s)))

if len(sys.argv) == 2:
    s = sys.argv[1]
else:
    s = 'abcdef'

print (string_reverse(s))
