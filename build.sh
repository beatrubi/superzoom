#!/bin/bash

set -o pipefail -eu

rm -Rf Superzoom*
mkdir Superzoom

cp Credits.rtf Superzoom/

gcc  -O3 -prebind -mmacosx-version-min=11.0 \
  -o sleepwatcher sleepwatcher_2.2.1/sources/sleepwatcher.c \
  -framework IOKit -framework CoreFoundation

platypus \
  --name Superzoom \
  --interface-type 'None' \
  --app-icon Camera_31090.icns \
  --interpreter /usr/bin/perl \
  --app-version 1.0.0 \
  --author "Beat Rubischon" \
  --bundled-file Credits.rtf \
  --bundled-file Pictures \
  --bundled-file sleepwatcher \
  --quit-after-execution \
  --optimize-nib \
  --overwrite \
  superzoom.pl \
  Superzoom/Superzoom.app

hdiutil create -fs HFS+ -srcfolder Superzoom -volname Superzoom Superzoom-temp.dmg
hdiutil convert Superzoom-temp.dmg -format UDZO -o Superzoom.dmg
