class Slider extends UIElement {
  PVector rangeScreen, rangeVal, currPos;
  float pVal, currVal;
  boolean dragging, hovering;
  
  public Slider(PVector pos, PVector size, PVector range) {
    super(pos, size, loadImage("data\\ui\\slider_1_1.png"), loadImage("data\\ui\\slider_1_2.png"));
    sprites.get(1).resize((int) size.x, sprites.get(1).height);
    sprites.get(0).resize(0, (int) size.y);

    this.rangeScreen = new PVector(pos.x, pos.x + size.x);
    this.rangeVal = range;
    this.currPos = pos.copy();
  }
  
  void update() {
    //drag
    if (!pmousePressed && mousePressed && pointInsideRect(mousePos, pos, size)) {
      dragging = true;
    }
    if (!mousePressed) dragging = false;
    if (dragging) {
      currPos.set(mousePos.x, currPos.y);
    }
    
    updated = false;
    if (pVal != currVal) updated = true;
    
    if (currPos.x < rangeScreen.x) currPos.set(rangeScreen.x, currPos.y);
    if (currPos.x > rangeScreen.y) currPos.set(rangeScreen.y, currPos.y);
    if (currPos.y != pos.y) currPos.set(currPos.x, pos.y);
    
    //value
    pVal = currVal;
    currVal = ((currPos.x - rangeScreen.x) / (rangeScreen.y - rangeScreen.x)) * (rangeVal.y - rangeVal.x) + rangeVal.x;
  }
  
  void draw() {
    super.draw();

    image(sprites.get(1), pos.x, pos.y + (size.y / 2) - (sprites.get(1).height / 2));
    imageMode(CENTER);
    image(sprites.get(0), currPos.x, currPos.y + (sprites.get(0).height / 2));
    
    //image(sprites.get(0), 0, 0);
    imageMode(CORNER);  
  }
  
  void set(float val) {
    currPos = new PVector((val - rangeVal.x) / (rangeVal.y - rangeVal.x) * (rangeScreen.y - rangeScreen.x) + pos.x, currPos.y);
  }
  
  //gets proportion
  float getProp() {
    return (currPos.x - rangeScreen.x) / (rangeScreen.y - rangeScreen.x);
  }
}
