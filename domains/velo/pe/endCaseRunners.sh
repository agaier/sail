#!/bin/bash

# Start caserunners in each directory
for d in ./case*/ ; do (cd "$d" && touch done.signal &); done