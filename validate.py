#!/usr/bin/env python3
import bagit
bag = bagit.Bag("example1/")
print("BagIt valid?", bag.validate())

