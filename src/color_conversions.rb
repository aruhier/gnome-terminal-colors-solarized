# input: a string like "rgb(68,68,68)"
# output: the hex code like #444444444444
def rgb_to_48bit_hex(rgb_color)
  colors = rgb_color.gsub("rgb\(", "").gsub("\)", "").split(",")
  hex_color = "#"
  colors.each do |color|
    hex_color += sprintf("%02x%02x", color.to_i, color.to_i)
  end
  return hex_color
end

# input: an array of colors in rgb format, like: [ 'rgb(68,68,68)', 'rgb(255,0,85)', ... ]
# output: a dconf-compatible 48 bit color palette, like: '#444444444444', '#ffff00005555', ...
def rgb_palette_to_dconf(rgb_palette)
  hex_palette = rgb_palette_to_hex(rgb_palette)
  hex_palette.map { |hex_color| "'#{hex_color}'" }.join(", ")
end

# input: an array of colors in rgb format, like: [ 'rgb(68,68,68)', 'rgb(255,0,85)', ... ]
# output: a gconf-compatible 48 bit color palette, like: #444444444444:#ffff00005555:...
def rgb_palette_to_gconf(rgb_palette)
  hex_palette = rgb_palette_to_hex(rgb_palette)
  hex_palette.join(":")
end

def rgb_palette_to_hex(rgb_palette)
  hex_colors = []
  rgb_palette.each do |rgb_color|
    hex_colors << rgb_to_48bit_hex(rgb_color)
  end
  hex_colors
end

# Example script:

#    rgb_palette = ['rgb(68,68,68)','rgb(255,0,85)','rgb(177,214,49)','rgb(174,155,114)','rgb(104,190,228)','rgb(181,119,188)','rgb(87,154,159)','rgb(238,238,238)','rgb(119,119,119)','rgb(214,94,118)','rgb(187,255,170)','rgb(236,255,200)','rgb(159,211,230)','rgb(229,195,229)','rgb(182,224,230)','rgb(255,255,255)']
#    background_color = 'rgb(0,0,0)'
#    foreground_color = 'rgb(238,238,238)'
#    bold_color       = 'rgb(255,255,255)'


#    puts " --- Gconf:"
#    puts rgb_palette_to_gconf rgb_palette
#    puts " --- Dconf:"
#    puts rgb_palette_to_dconf rgb_palette
#    puts " --- Background:"
#    puts rgb_to_48bit_hex background_color
#    puts " --- Foreground:"
#    puts rgb_to_48bit_hex foreground_color
#    puts " --- Bold:"
#    puts rgb_to_48bit_hex bold_color
