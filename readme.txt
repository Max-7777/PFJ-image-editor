(This program uses the Processing java ide and .pde files to run. It's meant to be opened with Processing.)
https://processing.org/

This program is an image editor used to apply a number of different effects to images!

(Be sure to open the ImageEdit_2 file first, so Processing knows it's the main file, if not edit the file called sketch to be 'main=ImageEdit_2.pde')

Controls:
‣ left & right arrow keys: next/previous image
‣ r: reset effects
‣ shift + click pixel: select a pixel

Click the checkboxes on the right to enable effects.
Use the sliders to change the intensity of effects.

The color graph in the top right shows the distribution of intensities of the red, green, and blue channels of an image.
‣ The x-axis is the intensity of red, green, or blue ranging from 1 to 255.
‣ The y-axis is the number of pixels that have that given intensity.
‣ The range of the y-axis can be changed with the slider below the graph.
‣ When the color graph is gray, all channels are overlapping\equal at that point.

The color box in the top right shows the color of the pixel the mouse is currently hovering over.
‣ shift + click on a pixel to select the pixel and lock in the color box's value until another mouse click.

Presets can be loaded by clicking the buttons in the bottom right.
‣ These are configurations of effects I though looked cool so I saved them.

Add any additional images by adding an image file to data\\images folder, then typing its directory in data\\imgDirs.txt

https://github.com/Max-7777
