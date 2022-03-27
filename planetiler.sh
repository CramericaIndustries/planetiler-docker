#!/bin/bash
# @see https://github.com/onthegomap/planetiler
# AREANAME environment variable must be set via docker-compose (example value: "finland", without quotes, renders finland )
# RAM_GB environment variable must be set via docker-compose (natural number, defining how many GB of RAM the process is allowed to consume. Value of 4 means that it will use 4GB of ram)
# BOUNDS, optional environment variable which must be set via docker-compose (example value "--bounds=world")
# @see avilable-options.txt, for all possible planetiler.jar parameters

echo "!!! generating vector tiles of area '${AREANAME}', using ${RAM_GB}GB of RAM"

java 	-Xmx${RAM_GB}g \
		-Xms${RAM_GB}g \
		-XX:OnOutOfMemoryError="kill -9 %p" \
		-jar /tmp/planetiler.jar \
			--download \
			--fetch-wikidata \
			--use-wikidata \
			--boundary-country-names \
			--building-merge-z13 \
			--mbtiles-name="${AREANAME}" \
			--mbtiles_description="${AREANAME}" \
			--mbtiles-attribution="<a href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\">&copy; OpenStreetMap contributors</a>" \
			--download-threads=10 \
			--download-chunk-size-mb=1000 \
			--nodemap-type=sparsearray \
			--nodemap-storage=ram \
			${BOUNDS} \
			--area=${AREANAME}

echo "!!! generated vector tiles of area '${AREANAME}', using ${RAM_GB}GB of RAM"

mv -f "/tmp/data/output.mbtiles" "/output/${AREANAME}.mbtiles"
