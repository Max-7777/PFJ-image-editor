import java.util.*;

public class UIElement {
  PVector pos, size;
  List<PImage> sprites;
  boolean updated;
  
  public UIElement(PVector pos, PVector size, PImage... sprites) {
    this.pos = pos;
    this.size = size;
    this.sprites = Arrays.asList(sprites);
  }
  
  public void update() {}
  public void draw() {
    if (drawWireFrames) {
      noFill();
      strokeWeight(2);
      stroke(50, 50, 250);
      rect(pos.x, pos.y, size.x, size.y);
    }
  }
}
