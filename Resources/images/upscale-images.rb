#!/usr/bin/env ruby

# Get all images in current directory + subdirectories
maps = Dir['**/*.png']

maps.each { |filename|
  # Only process "sd" images
  next if filename.index('-hd')

  # Determine base filename/extension
  filename_base, filename_extension = filename.split('.')
  
  # Run ImageMagick shell command to increase size 2x w/ nearest neighbor filter, then re-save w/ -hd suffix
  `convert #{filename} -scale 200% #{filename_base}-hd.#{filename_extension}`
}