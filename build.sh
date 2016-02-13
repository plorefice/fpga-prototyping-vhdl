#!/bin/bash

set -eu

DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
ENTS=()

USAGE="$(basename "$0") [-h] [-c] [entities...] -- build and run the specified entities

where
	-h,--help	show this help text
	-c,--clean	clean the object files"

while [[ "$#" > 0 ]]; do
key="$1"

case $key in
	-h|--help)
	echo "$USAGE"
	exit
	;;
	-c|--clean)
	ghdl --clean --workdir=work
	rm -f `find . -name "*.o"`
	exit
	;;
	*)
	ENTS+=($key)
	;;
esac
shift
done

ghdl -i --workdir=work `find . -name "*.vhdl"`

for ent in "${ENTS[@]}"; do
	ghdl -m --workdir=work "$ent"
	ghdl -r --workdir=work "$ent" --vcd="$ent".vcd
done
