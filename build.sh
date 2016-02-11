#!/bin/bash

set -eu

if [[ $# -lt 1 ]]; then
	echo "Usage: build.sh <entity>"
	exit 1
fi

ghdl -i --workdir=work `find . -name "*.vhdl"`
ghdl -m --workdir=work $1
ghdl -r --workdir=work $1 --vcd="$1".vcd
