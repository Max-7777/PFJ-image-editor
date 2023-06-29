import java.util.*;
import java.io.*;

float NANO_TO_MILLI = 0.000001;
PImage currentImage, originalImage;
PVector offset, scale, dscale, mousePos, pmousePos;
PVector defSize, windowScale;
color currentColor, bg;
boolean pmousePressed;
int textSize = 22;
UIGrid grid;
boolean drawWireFrames = false;
Slider graphSlider;
//invert, blur, flip x axis, flip y axis
List<Boolean> filtersOn;
List<String> filters;
List<Integer> mults, offs;
List<Boolean> hasSlider;
List<Float> defSliderVal;
PImage s;
boolean pixelSelected;
int selectedIndex;
List<PImage> images;
int imgIndex = 0;
boolean shft = false;
ColorGraph cg = new ColorGraph(new PVector(256 * 1.2, 100 * 1.2));

UIGrid buttonGrid;

void setup() {
  //-- settings
  windowScale = new PVector(1, 1);
  defSize = new PVector(1920, 1080);
  size(1920,1080);
  pixelDensity(1);
  noSmooth();
  frameRate(90);
  surface.setResizable(true);
  surface.setIcon(loadImage("data\\images\\i2.png"));
  surface.setTitle("Image Editor");
  textFont(createFont("Ebrima", textSize));
  
  //-- vars
  loadImages();
  offset = new PVector();
  scale = new PVector(1, 1);
  dscale = new PVector(1, 1);
  mousePos = new PVector(mouseX, mouseY);
  pmousePos = new PVector(mouseX, mouseY);
  bg = color(220, 220, 220);
  
  //default values to start on program start up
  offset = new PVector(100, 100);
  scale = new PVector(2, 2);
  dscale = new PVector(2.5, 2.5);
  
  graphSlider = new Slider(new PVector(cg.pos.x, cg.pos.y + cg.size.y + 4), new PVector(cg.size.x,20), new PVector(10, 20000));
  graphSlider.set(9500);
  
  filters = new ArrayList<>();
  offs = new ArrayList<>();
  mults = new ArrayList<>();
  hasSlider = new ArrayList<>();
  defSliderVal = new ArrayList<>();
  List<String> data = readFile("data\\filters.txt");
    
  for (String s : data) {
    String[] a = s.split(",");
    filters.add(a[0]);
    offs.add(Integer.parseInt(a[1]));
    mults.add(Integer.parseInt(a[2]));
    hasSlider.add(Boolean.parseBoolean(a[3]));
    //println(hasSlider.get(hasSlider.size() - 1));
    defSliderVal.add((Boolean.parseBoolean(a[3])) ? Float.parseFloat(a[4]) : -1);
  }
   
  filtersOn = new ArrayList<>();
  
  for (int i = 0; i < filters.size(); i++) {
    filtersOn.add(false);
  }
  
  //set buffer
  setBuffer(images.get(0));

  //-- ui
  //checkboxes & slider
  grid = new UIGrid(new PVector(1570, 390), new PVector(420, 530), 16, 2);
  PVector cbSize = new PVector(130, 17);
  for (int i = 0; i < filters.size(); i++) {
    Checkbox cb = new Checkbox(cbSize, filters.get(i));
    grid.add(cb, i, 0, true);
  }
  
  //sliders
  PVector sliderSize = new PVector(100, 24);
  PVector sliderRange = new PVector(0, 1);
  for (int i = 0; i < filters.size(); i++) {
    if (!hasSlider.get(i)) continue;
    grid.add(new Slider(grid.posAt(i,1), sliderSize, sliderRange), i, 1, true);
    ((Slider) grid.getElement(i, 1)).set(defSliderVal.get(i));
  }
  
  //button grid
  buttonGrid = new UIGrid(new PVector(1570, 915), new PVector(320, 130), 3, 3);
  
  PVector buttonSize = new PVector(102, 40);
  color buttonColor = brighten(bg, 12);
  int c = 0;
  for (int i = 0; i < buttonGrid.rows; i++) {
    for (int j = 0; j < buttonGrid.cols; j++) {
      c++;
      buttonGrid.add(new Button(buttonGrid.posAt(i, j), buttonSize, buttonColor, "Preset " + c), i, j, false);
    }
  }
}

void loadImages() {
  List<String> imageDirs = new ArrayList<>();
  try {
    imageDirs = readFile("data\\imgDirs.txt");  
  } catch (Exception ignored) {
    println("Error loading images");
  }
  
  images = new ArrayList<>();
  
  for (String dir : imageDirs) {
    images.add(loadImage(dir));
  }
  
  int imageSize = 450;
  
  for (int i = 0; i < images.size(); i++) {
    images.get(i).resize(Math.min(imageSize, images.get(i).width), 0);
  }
  
  originalImage = images.get(imgIndex);
  currentImage = originalImage.copy();
}

void draw() {
  pre();
  mouseMovement();
  updateScale();
  
  //update
  graphSlider.update();
  buttonGrid.update();
  grid.update();
  updateEditor();
  
  //update presets of buttonGrid
  for (int i = 1; i <= buttonGrid.elements.size(); i++) {
    Button button = (Button) buttonGrid.elements.get(i - 1);
    if (button.clicked) {
      load("data\\presets\\preset" + i + ".txt");
    }
  }
  
  //scale based on window size
  windowScale =  new PVector(width / defSize.x, height / defSize.y);
  scale(windowScale.x, windowScale.y);
  
  //draw bg
  background(230);
  
  //draw image number label in top left
  textSize(26);
  fill(140);
  noStroke();
  textAlign(LEFT, TOP);
  text("<- Image " + " " + (imgIndex + 1) + " ->", 5, 5);
  textAlign(LEFT, BOTTOM);

  //draw edited image
  pushMatrix();
  scale(scale.x, scale.y);
  translate(offset.x, offset.y);
  image(buffer, 0, 0);
  popMatrix();
  
  PVector m = mousePos.copy().mult(1 / scale.x).sub(offset);
  currentColor = getPixel(m);
  


    //debug
  //fill(255);
  //text(red(currentColor) + "," + green(currentColor) + "," + blue(currentColor), 0, 20);
  //text(m.toString(), 0, 40);
  //text(frameRate, 0, 60);
  //text("mp: " + mousePos.toString(), 0, 80);
  //text("jobs: " + jobs.toString(), 0, 100);
  //text("current index: " + currentIndex + "/" + (buffer.width * buffer.height), 0, 120);
  //fill(currentColor);
  //strokeWeight(2);
  //stroke(255);
  //rect(10, 50, 10, 10);
  //text(width + ", " + height, 0, 80);
  
  //apply filters
  updateFilters();

  //draw side panel
  fill(bg);
  strokeWeight(1);
  stroke(40);
  rect(defSize.x * 0.8, 0, defSize.x * 0.2, defSize.y);
  //color square
  strokeWeight(1);
  stroke(80);
  fill(currentColor);
  rectMode(CENTER);
  rect(defSize.x * 0.9, 170, 240, 240);
  rectMode(CORNER);
  noStroke();
  //rgb of color
  textAlign(CENTER);
  textSize(40);
  //textStroke("[" + red(currentColor) + "," + green(currentColor) + "," + blue(currentColor) + "]", defSize.x * 0.9, 360, 1);
  text("[" + red(currentColor) + "," + green(currentColor) + "," + blue(currentColor) + "]", defSize.x * 0.9, 350);
  textSize(textSize);
  
  //draw ui
  buttonGrid.draw();
  grid.draw();
  highlightCurrentPixel();
  
  //color graph
  cg.update(buffer);
  cg.draw();
  
  //graph slider
  graphSlider.draw();
  
  post();
}

void pre() {
  mousePos = new PVector(mouseX / windowScale.x, mouseY / windowScale.y);
  pmousePos = new PVector(pmouseX / windowScale.x, pmouseY / windowScale.y);
}

void updateFilters() {
  List<UIElement> updates = new ArrayList<>();
  
  for (int i = 0; i < grid.elements.size(); i++) {
    UIElement e = grid.elements.get(i);
    if (e.updated) updates.add(e);
  }
  
  if (updates.size() == 0) {
    return;
  } else {
    for (UIElement e : updates) {
      try {
        Checkbox c = (Checkbox) e;
        if (c.checked) filtersOn.set(filters.indexOf(c.text), true);
        if (!c.checked) filtersOn.set(filters.indexOf(c.text), false);
      } catch (Exception ignored) {
        continue;
      }
    }
  }
  
  applyFilters();
}

void applyFilters() {
  //reset current image then re-add new, updated filters
  currentImage = originalImage.copy();
  setBuffer(originalImage);
  jobs = new ArrayList<>();
  params = new ArrayList<>();
  currentIndex = 0;
  
  for (int i = 0; i < filtersOn.size(); i++) {
    if (!filtersOn.get(i)) continue;
    if (hasSlider.get(i)) {
      request(filters.get(i), offs.get(i) + (mults.get(i) * ((Slider) grid.getElement(i, 1)).currVal));
    } else {
      request(filters.get(i));
    }
  }
}

void post() {
  pmousePressed = mousePressed;
}

void updateScale() {
  PVector pm = screenToWorld(mousePos, offset, scale);
  scale = new PVector(scale.x + ((dscale.x - scale.x) * 0.3), scale.y + ((dscale.y - scale.y) * 0.3));
  PVector nm = screenToWorld(mousePos, offset, scale);
  offset.add(nm.sub(pm));
}

void mouseWheel(MouseEvent e) {
  if (e.getCount() < 0) dscale.mult(1.15);
  if (e.getCount() > 0) dscale.mult(0.85);
}

void mouseMovement() {
  if (mousePressed) {
    if (shft) {
      pixelSelected = true;
      selectedIndex = getPixelIndex(mousePos.copy().mult(1 / scale.x).sub(offset));   
    }
    if (!shft && mouseX < width * 0.8 && !graphSlider.dragging) {
      pixelSelected = false;
      PVector delta = new PVector(mousePos.x - pmousePos.x, mousePos.y - pmousePos.y);
      offset.add(delta.mult(1 / scale.x));
    }
  }
}

void keyPressed() {
  if (keyCode == SHIFT) shft = true;
  if (key == 'r') {
    //offset = new PVector();
    //dscale = new PVector(1, 1);
    //scale = new PVector(1, 1);
    
    for (int i = 0; i < grid.elements.size(); i++) {
      try {
        Checkbox c = (Checkbox) grid.elements.get(i);   
        c.checked = false;
        c.updated = true;
      } catch (Exception ignored) {}
      try {
        Slider s = (Slider) grid.elements.get(i);   
        s.currPos = s.pos.copy();
      } catch (Exception ignored) {}
    }
    currentImage = originalImage;
    updateFilters();
  }
    
  if (keyCode == RIGHT) {
    imgIndex = (imgIndex + 1) % images.size();
    originalImage = images.get(imgIndex);
    currentImage = originalImage.copy();
    applyFilters();
  }
  
  if (keyCode == LEFT) {
    imgIndex = (imgIndex - 1) % images.size();
    if (imgIndex < 0) imgIndex = images.size() - 1;
    originalImage = images.get(imgIndex);
    currentImage = originalImage.copy();
    applyFilters();
  }
  
  //-- for saving ui values for the presets lol
 
  //for (int i = 1; i < 10; i++) {
  //  String s = String.valueOf(i);
  //  char ch = s.charAt(0);
  //  if (key == ch) {
  //    println('k');
  //    try {
  //      BufferedWriter bw = new BufferedWriter(new FileWriter("presets\\preset" + i + ".txt"));
        
  //      for (UIElement e : grid.elements) {
  //        try {
  //          Slider slider = (Slider) e;
  //          bw.write(String.valueOf(slider.getProp()));
  //          bw.newLine();
  //        } catch (Exception ignored) {}
  //        try {
  //          Checkbox checkbox = (Checkbox) e;
  //          bw.write(String.valueOf(checkbox.checked));
  //          bw.newLine();
  //        } catch (Exception ignored) {}
  //      }
        
  //      bw.close();
  //    } catch(Exception e) {
  //      e.printStackTrace();
  //    }    
  //  } else {
  //    println(key + "   " + String.valueOf(i) + "     " + ch);
  //  }
  //}
}

void keyReleased() {
  if (keyCode == SHIFT) shft = false;
}

void highlightCurrentPixel() {
   //rect((int) ((mousePos.x + ((offset.x % 1) * scale.x)) / scale.x) * scale.x, (int) (mousePos.y / scale.y) * scale.y + ((offset.y % 1) * scale.y), scale.x, scale.y);
   //println(offset.x % 1);
}

color getPixel(PVector pos) {
  color c;
  int index = 0;
  currentImage.loadPixels();
  try {
    index = (int) (((int) (pos.y) * buffer.width) + (int) (pos.x));
    c = buffer.pixels[index];
  } catch (Exception ignored) {
    return buffer.pixels[0];
  }
  
  if (pixelSelected) {
    c = buffer.pixels[selectedIndex];
  }
  
  return c;
}

int getPixelIndex(PVector pos) {
  int index = 0;
  try {
    index = (int) (((int) (pos.y) * buffer.width) + (int) (pos.x));
  } catch (Exception ignored) {}
  
  return index;
}

public void load(String dir) {
  List<String> fileList = readFile(dir);
  for (int i = 0; i < fileList.size(); i++) {
    try {
      Checkbox checkbox = (Checkbox) grid.elements.get(i);
      checkbox.checked = Boolean.parseBoolean(fileList.get(i));
      checkbox.updated = true;
    } catch (Exception ignored) {}
    try {
      Slider slider = (Slider) grid.elements.get(i);
      slider.set(Float.parseFloat(fileList.get(i)));
    } catch (Exception ignored) {}
  }
}
