#!/bin/python3
import sys
import re

SSN_RE=re.compile(r'^\d{3}-?\d{2}-?\d{4}$', re.I)

def valid_ssn(s):
    assert type(s) == str, "'s' must be a string."

    if SSN_RE.match(s):
        return True
    else:
        return False

if len(sys.argv) == 2:
    ssn = sys.argv[1]
else:
    ssn = '123-45-5678'

if valid_ssn(ssn):
    print ("%s is a valid SSN." % ssn)
else:
    print ("%s is not a valid SSN." % ssn)
