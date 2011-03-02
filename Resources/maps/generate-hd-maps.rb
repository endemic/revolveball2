#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

# Get all map files in current directory
maps = Dir.glob('*.tmx')

maps.each { |map|
  # Only process "sd" maps
  next if map[-6, 2] == 'hd'

  f = File.open(map)
  xml = Nokogiri::XML(f)
  f.close
  
  xml.map['tilewidth'] = String(Integer(xml.map['tilewidth']) * 2)
  xml.map['tileheight'] = String(xml.map['tileheight'].to_i * 2)
  
  xml.map.tileset['tilewidth'] = String(xml.map.tileset['tileheight'].to_i * 2)
  xml.map.tileset['tileheight'] = String(xml.map.tileset['tileheight'].to_i * 2)
  
  File.new(map + 'hd', 'w').write xml unless xml.validate
  
  # DEBUG - only do one file, for testing =]
  break
}