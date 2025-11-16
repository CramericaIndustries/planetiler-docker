#!/bin/bash
# @see https://github.com/onthegomap/planetiler
# AREANAME environment variable must be set via docker-compose (example value: "finland", without quotes, renders finland )
# RAM_GB environment variable must be set via docker-compose (natural number, defining how many GB of RAM the process is allowed to consume. Value of 4 means that it will use 4GB of ram)
# BOUNDS, optional environment variable which must be set via docker-compose (example value "--bounds=world")
# @see avilable-options.txt, for all possible planetiler.jar parameters

echo "!!! generating vector tiles of area '${AREANAME}', using ${RAM_GB}GB of RAM and ${CPU_COUNT:-all} CPUs"
start_time=$(date +%s)

java 	-Xmx${RAM_GB}g \
		-Xms1g \
		-XX:OnOutOfMemoryError="kill -9 %p" \
		-XX:ActiveProcessorCount=${CPU_COUNT:-0} \
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
			--output=/output/${AREANAME}.${FORMAT:-mbtiles}\
			--force \
			${BOUNDS} \
			--area=${AREANAME}

end_time=$(date +%s)
elapsed=$(( end_time - start_time ))

days=$(( elapsed / 86400 ))
hours=$(( (elapsed % 86400) / 3600 ))
minutes=$(( (elapsed % 3600) / 60 ))
seconds=$(( elapsed % 60 ))

echo "!!! Finished Generating vector tiles of area '${AREANAME}', using ${RAM_GB}GB of RAM and ${CPU_COUNT:-all} CPUs in ${days}d ${hours}h ${minutes}min ${seconds}s"
