#!/bin/bash

gdlint *.gd
gdformat -c --line-length 80 *.gd
