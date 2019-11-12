#!/bin/bash

TARGET=../../modelica-deploy/InaMo

if [ -d $TARGET ]; then
  echo "Removing $TARGET ..."
  rm -rf $TARGET
fi

echo "Copying all files from ../InaMo to $TARGET ..."
cp -r ../InaMo $TARGET

echo "Done."
