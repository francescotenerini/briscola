#!/bin/bash

gdlint *.gd tests/*.gd
gdformat -c --line-length 80 *.gd tests/*.gd
