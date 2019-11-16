#!/bin/bash
# copies modelica files into deploy folder
# must be run from within this folder

TARGET=../../modelica-deploy/InaMo
REF=../../modelica-deploy/InaMo-ref

if [ -d $TARGET ]; then
  echo "Removing $TARGET ..."
  rm -rf "$TARGET"
fi

echo "Copying all files from ../InaMo to $TARGET ..."
cp -r ../InaMo "$TARGET"

if [ ! -d $REF ]; then
  echo "Copying reference code to $REF ..."
  mkdir -p "$REF"
  cp -r ../references/2019-kupferschmitt-inada2009/modelica/* "$REF"
fi

echo "Done."
