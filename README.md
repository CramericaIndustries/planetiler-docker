# planetiler-docker
Docker container to generate open-street-map vector mbtiles, using planetiler.  
  
Project repo: https://github.com/onthegomap/planetiler  
Blog post: https://medium.com/@onthegomap/helping-sustain-open-maps-on-the-web-dc419f3af75d  
Aditional scripts: https://github.com/ZeLonewolf/planetiler-scripts

# tldr; Quick Start
Render whole planet using 100GB of RAM...  

    git clone git@github.com:CramericaIndustries/planetiler-docker.git
    cd planetiler-docker
    docker-compose up -d gen-planet
    docker-compose logs -f gen-planet

After the container completed, the generated mbtile file will be in `./output`  
Downloaded files (like the .osm.pbf file) will end up in `./sources`


# Prerequisites

## Hardware
To render the whole planet you need at least 16 CPU cores, 128GB of RAM and 700GB SSD disk space

## Docker Engine
Docker Engine must be installed  
@see https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

## Docker-Compose
Docker-Compose must be installed  
@see https://docs.docker.com/compose/install/

### For lazy people (optional)
Add an alias for the `docker-compose` command...  

    vim ~/.bashrc
Add the following line to the bottom of the file:  

    alias dc='docker-compose'
Reload .bashrc:  

    source ~/.bashrc



# Installation
Clone this git repository  

    git clone git@github.com:CramericaIndustries/planetiler-docker.git
    cd planetiler-docker

Build the image  

    docker-compose build

# Rendering Tiles
For testing you can render tiles of...
### Monte-Carlo
    docker-compose up gen-monaco
### Sweden
    docker-compose up gen-sweden
### Switzerland
    docker-compose up gen-switzerland
### Massachusetts
    docker-compose up gen-massachusetts

Output files can then be found in the `./output` directory.


# Rendering Tiles of the whole Planet
This takes about 3-5h on a 16 Core, 128GB machine and uses 100GB of RAM.  

    docker-compose up -d gen-planet

To see the container output type:  

    docker-compose logs -f gen-planet
Output files can then be found in the `./output` directory.

If you have more RAM available you can add more RAM by editing the `docker-compose.yml` file. Edit the `RAM_GB` environment variable in the `gen-planet` section of the file. This example will use 200GB.

      gen-planet:
        image: planetiler:0.3.0
        environment:
          - AREANAME=planet
          - RAM_GB=200
          - BOUNDS="--bounds=world"
        volumes:
          - ./output:/output
          - ./sources:/tmp/data/sources

You will have to recreate the `gen-planet` container after editing the file.  

    docker-compose up -d --force-recreate gen-planet

# Rendering Tiles of other Countries
First you need to find the geofabrik name of the country/region you want to render. To find the name, go to: https://download.geofabrik.de/
The name then is the name of the `.osm.pbf` file without the `-latest.osm.pbf` file extension. For example the geofrabrik name of Faroe Islands would be: `"faroe-islands-latest.osm.pbf"` &rarr; `"faroe-islands"`.  

Here is an example which creates tiles for Finland using 4GB of RAM. Note: The container will automatically be removed after it completes or errors.  

    docker-compose run -d --rm -e AREANAME=finland -e RAM_GB=4 --name=planetiler planetiler
To see the container output type:  

    docker-compose logs -f planetiler
Output files can then be found in the `./output` directory.




# Test the generated mbtiles file
## Browser
Install and Run tileserver-gl (node.js/npm installed)  

    npm install -g tileserver-gl-light
    tileserver-gl-light --mbtiles <path>\finland.mbtiles

## Desktop App
Download and install MapTiler Desktop  
https://www.maptiler.com/download/  
Then double click on the `*.mbtiles` file.

# Cleaning Up
Stops and removes all containers and images  

    docker-compose down --rmi=all

Remove the downloaded temporary files  

    rm sources/*.pbf
    rm sources/*.zip
    rm sources/*.json

# Updating to a newer Planetiler version
Remove old images and containers...

    docker-compose down --rmi=all

Get the new download link from here...
https://github.com/onthegomap/planetiler/tags  
Then open the `Dockerfile` and edit the download url to point to the new version

    RUN wget https://github.com/onthegomap/planetiler/releases/download/v0.3.1/planetiler.jar

Then open the `docker-compose.yml` file and change the version number in the `image` section of each service. `image: planetiler:0.3.0` &rarr; `image: planetiler:0.3.1`.