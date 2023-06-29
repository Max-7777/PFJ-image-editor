class Button extends UIElement {
  color bgColor;
  boolean hover, clicked;
  String text;
  
  public Button(PVector pos, PVector size, color bgColor, String text) {
    super(pos, size, loadImage("data\\ui\\cb_2.png"));
    this.bgColor = bgColor;
    this.text = text;
  }
  
  @Override
  public void update() {
    hover = pointInsideRect(mousePos, pos, size);
    clicked = hover && mousePressed && !pmousePressed;
  }
  
  @Override
  public void draw() {
    fill((mousePressed && hover) ? darken(bgColor) : bgColor);
    strokeWeight(1);
    stroke(150);
    rect(pos.x, pos.y, size.x, size.y);
    textAlign(CENTER, CENTER);
    noStroke();
    fill(100);
    textSize(size.y / 2);
    text(text, pos.x + size.x * 0.5, pos.y + size.y * 0.45);
    textAlign(LEFT, BOTTOM);
  }
}
