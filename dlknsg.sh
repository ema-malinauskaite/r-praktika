#!/bin/bash

cd $(dirname $0)

find ./lizocimai/ -type f -name '*.contacts' | while read FNAME
do
	cat "$FNAME" \
	| ../voronota_1.19.2352/voronota query-contacts \
	| ../voronota_1.19.2352/voronota expand-descriptors \
	| column -t \
	> "${FNAME}.interatom.table"
done


