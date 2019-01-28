#!/bin/bash
cd "$(dirname "$0")"

# Sources
SOURCES="../sources";

# Make sure there's an output place
BUILD="../build";
mkdir -p $BUILD;

# Output for thumbnails
OUTPUT_IMAGES="../../assets/images/biomes";
mkdir -p $OUTPUT_IMAGES;

# Common
COLORS="./tiff-colors.txt";

# Convert original tif file to mbtiles
function to_mbtiles {
  original=$1;
  output=$2;

  # Convert bits
  gdal_translate -ot Byte -of GTiff $original $BUILD/bits-$output.tiff;
  # Reproject
  gdalwarp -t_srs "EPSG:3857" $BUILD/bits-$output.tiff $BUILD/bits-$output.tiff;
  # Colorize
  gdaldem color-relief $BUILD/bits-$output.tiff $COLORS $BUILD/colors-$output.tiff;
  # To MB tiles
  gdal_translate $BUILD/colors-$output.tiff $BUILD/$output.mbtiles -of MBTILES;
  # Creates overview (unsure if needed)
  gdaladdo $BUILD/$output.mbtiles 2 4 8;

  # Cleanup
  rm $BUILD/bits-$output.tiff;

  # Need for gifs ?
  #rm $BUILD/colors-$output.tiff;
}

# Convert all
to_mbtiles "$SOURCES/biome_bcc.csm1.1_rcp26_2061.2080_.tif" "201901-biomes_BCC-CSM1-1_RCP26";
to_mbtiles "$SOURCES/biome_bcc.csm1.1_rcp45_2061.2080_.tif" "201901-biomes_BCC-CSM1-1_RCP45";
to_mbtiles "$SOURCES/biome_bcc.csm1.1_rcp85_2061.2080_.tif" "201901-biomes_BCC-CSM1-1_RCP85";

to_mbtiles "$SOURCES/biome_CCSM4_rcp26_2061.2080_.tif" "201901-biomes_CCSM4_RCP26";
to_mbtiles "$SOURCES/biome_CCSM4_rcp45_2061.2080_.tif" "201901-biomes_CCSM4_RCP45";
to_mbtiles "$SOURCES/biome_CCSM4_rcp85_2061.2080_.tif" "201901-biomes_CCSM4_RCP85";

to_mbtiles "$SOURCES/biome_MIROC.ESM_rcp26_2061.2080_.tif" "201901-biomes_MIROC-ESM_RCP26";
to_mbtiles "$SOURCES/biome_MIROC.ESM_rcp45_2061.2080_.tif" "201901-biomes_MIROC-ESM_RCP45";
to_mbtiles "$SOURCES/biome_MIROC.ESM_rcp85_2061.2080_.tif" "201901-biomes_MIROC-ESM_RCP85";

to_mbtiles "$SOURCES/biome_raster_1979-2013_albers.tif" "201901-biomes_current";


# Make gifs
convert -delay 200 -loop 1 $BUILD/colors-201901-biomes_current.tiff $BUILD/colors-201901-biomes_BCC-CSM1-1*.tiff $BUILD/201901-biomes_BCC-CSM1-1.gif;
convert -delay 200 -loop 1 $BUILD/colors-201901-biomes_current.tiff $BUILD/colors-201901-biomes_CCSM4*.tiff $BUILD/201901-biomes_CCSM4.gif;
convert -delay 200 -loop 1 $BUILD/colors-201901-biomes_current.tiff $BUILD/colors-201901-biomes_MIROC-ESM*.tiff $BUILD/201901-biomes_MIROC-ESM.gif;


# Make thumbnails
convert $BUILD/colors-201901-biomes_current.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_current-rect.png;
convert $BUILD/colors-201901-biomes_current.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_current-square.png;

convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP26.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP26-rect.png;
convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP26.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP26-square.png;
convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP45.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP45-rect.png;
convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP45.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP45-square.png;
convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP85.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP85-rect.png;
convert $BUILD/colors-201901-biomes_BCC-CSM1-1_RCP85.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_BCC-CSM1-1_RCP85-square.png;

convert $BUILD/colors-201901-biomes_CCSM4_RCP26.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP26-rect.png;
convert $BUILD/colors-201901-biomes_CCSM4_RCP26.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP26-square.png;
convert $BUILD/colors-201901-biomes_CCSM4_RCP45.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP45-rect.png;
convert $BUILD/colors-201901-biomes_CCSM4_RCP45.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP45-square.png;
convert $BUILD/colors-201901-biomes_CCSM4_RCP85.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP85-rect.png;
convert $BUILD/colors-201901-biomes_CCSM4_RCP85.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_CCSM4_RCP85-square.png;

convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP26.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP26-rect.png;
convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP26.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP26-square.png;
convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP45.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP45-rect.png;
convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP45.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP45-square.png;
convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP85.tiff -resize 200x200 $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP85-rect.png;
convert $BUILD/colors-201901-biomes_MIROC-ESM_RCP85.tiff -gravity west -resize 200x200^ -crop 200x200+0+0 +repage $OUTPUT_IMAGES/201901-biomes_MIROC-ESM_RCP85-square.png;


# Upload to mapbox
mapbox upload shadowflare.201901-biomes_current $BUILD/201901-biomes_current.mbtiles;

mapbox upload shadowflare.201901-biomes_BCC-CSM1-1_RCP26 $BUILD/201901-biomes_BCC-CSM1-1_RCP26.mbtiles;
mapbox upload shadowflare.201901-biomes_BCC-CSM1-1_RCP45 $BUILD/201901-biomes_BCC-CSM1-1_RCP45.mbtiles;
mapbox upload shadowflare.201901-biomes_BCC-CSM1-1_RCP85 $BUILD/201901-biomes_BCC-CSM1-1_RCP85.mbtiles;

mapbox upload shadowflare.201901-biomes_CCSM4_RCP26 $BUILD/201901-biomes_CCSM4_RCP26.mbtiles;
mapbox upload shadowflare.201901-biomes_CCSM4_RCP45 $BUILD/201901-biomes_CCSM4_RCP45.mbtiles;
mapbox upload shadowflare.201901-biomes_CCSM4_RCP85 $BUILD/201901-biomes_CCSM4_RCP85.mbtiles;

mapbox upload shadowflare.201901-biomes_MIROC-ESM_RCP26 $BUILD/201901-biomes_MIROC-ESM_RCP26.mbtiles;
mapbox upload shadowflare.201901-biomes_MIROC-ESM_RCP45 $BUILD/201901-biomes_MIROC-ESM_RCP45.mbtiles;
mapbox upload shadowflare.201901-biomes_MIROC-ESM_RCP85 $BUILD/201901-biomes_MIROC-ESM_RCP85.mbtiles;
