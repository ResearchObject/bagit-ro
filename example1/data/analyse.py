#!/usr/bin/env python
import csv
numbers = csv.reader(open("numbers.csv"))
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
