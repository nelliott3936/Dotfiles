import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import os

def choose_color():
    color_selection = Gtk.ColorChooserDialog(title="Select Waybar Color")
    if color_selection.run() == Gtk.ResponseType.OK:
        # Get the RGBA color and convert to Hex
        rgba = color_selection.get_rgba()
        hex_color = '#{:02x}{:02x}{:02x}'.format(
            int(rgba.red * 255), 
            int(rgba.green * 255), 
            int(rgba.blue * 255)
        )
        
        # Save to a variable file for CSS to import
        with open(os.path.expanduser("~/.config/waybar/colors.css"), "w") as f:
            f.write(f"@define-color bar-bg {hex_color};")
        
        # Force Waybar to reload styles
        os.system("pkill -USR2 waybar")
    
    color_selection.destroy()

choose_color()