#!/bin/sh

BACKGROUND_DIR=$HOME/.config/i3/backgrounds

shuf -e `echo $BACKGROUND_DIR`/* | head -n 1
