#!/usr/bin/env python
import csv,sys
numbers = csv.reader(open(sys.argv[1]))
drinkers = []
for row in numbers:
    if row[0] == "Name": continue # header row.. right?

    name = row[0]
    cups = sum(map(int, row[1:]))
    drinkers.append([cups, name])

drinkers.sort()
drinkers.reverse()
for (cups, name) in drinkers:
    print cups, name
