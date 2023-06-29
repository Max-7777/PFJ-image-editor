class Checkbox extends UIElement {
  String text;
  boolean checked, centered;
  PImage currSprite;
  
  public Checkbox(PVector size, String text) {
    super(new PVector(), size, loadImage("data\\ui\\cb_2.png"), loadImage("data\\ui\\cb_1.png"), loadImage("data\\ui\\cb_3.png"), loadImage("data\\ui\\cb_4.png"));
    
    for (PImage i : sprites) {
      i.resize(0, (int) size.y);
    }
    
    this.centered = false;
    this.text = text;
  }
  
  @Override
  public void update() {
    if (updated) updated = false;
    if (pointInsideRect(mousePos, pos, size)) {
      if (!pmousePressed && mousePressed) {
        checked = !checked;
        updated = true;
      }
      currSprite = sprites.get(2);
      if (checked) currSprite = sprites.get(3);
    } else {
      currSprite = sprites.get(1);
      if (checked) currSprite = sprites.get(0);
    }
  }
  
  @Override
  public void draw() {
    super.draw();
    
    image(currSprite, pos.x, pos.y);
    fill(80);
    textAlign(LEFT, CENTER);
    textSize(size.y * 1.2);
    text(text, pos.x + size.y + (textSize / 2), pos.y + (size.y / 4));
    textAlign(BASELINE);  
  }
}
