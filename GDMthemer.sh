#!/bin/bash
# See https://wiki.archlinux.org/index.php/GDM#Log-in_screen_background_image
# Change themedir to folder containing gnome-shell.cs, noise-texture.png, etc.
# Change gst if file location changed in an update

themedir=/usr/share/gnome-shell/theme/Yaru/*
gst=/usr/share/gnome-shell/gnome-shell-theme.gresource
gstbak=/usr/share/gnome-shell/gnome-shell-theme.gresource
out=gnome-shell-theme.gresource.xml

# Create a XML of all the files
echo '<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">' > $out

for file in $themedir
do
    f=$(basename $file)
    echo "    <file>$f</file>" >> $out
done

echo '  </gresource>
</gresources>' >> $out

# Create the gresource, replace
glib-compile-resources gnome-shell-theme.gresource.xml
sudo mv $gst $gstbak
sudo mv ./gnome-shell-theme.gresource $gst
