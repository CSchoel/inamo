#!/bin/bash

TARGET=../../modelica-deploy/InaMo

if [ -d $TARGET ]; then
  rm -rvf $TARGET
fi

cp -rv ../InaMo $TARGET
