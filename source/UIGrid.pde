import java.util.*;

class UIGrid {
  PVector pos, size;
  int rows, cols;
  List<UIElement> elements;
  //(row, column)
  List<PVector> positions;
  List<Boolean> centered;
  
  public UIGrid(PVector pos, PVector size, int rows, int cols) {
    this.pos = pos;
    this.size = size;
    this.elements = new ArrayList<>();
    this.positions = new ArrayList<>();
    this.centered = new ArrayList<>();
    this.rows = rows;
    this.cols = cols;
  }
  
  public void add(UIElement element, int row, int col, boolean centered_) {
    if (!centered_) {
      element.pos = new PVector(pos.x + (col * (size.x / cols)), pos.y + (row * (size.y / rows)));
    } else {
      element.pos = new PVector(pos.x + (col * (size.x / cols)), pos.y + (row * (size.y / rows)) + ((size.y / rows) / 2) - (element.size.y / 2));
    }
    
    elements.add(element);
    positions.add(new PVector(row, col));
    centered.add(centered_);
  }
  
  public void remove(int row, int column) {
    int index = toIndex(row, column);
    
    positions.remove(index);
    elements.remove(index);
    centered.remove(index);
  }
  
  public int toIndex(int row, int column) {
    return (int) (row * cols) + column;
  }
  
  public void update() {
    for (UIElement e : elements) {
      e.update();
    }
  }
  
  public void draw() {
    if (drawWireFrames) {
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          strokeWeight(2);
          stroke(250, 50, 50);
          noFill();
          rect(pos.x + (j * (size.x / cols)), pos.y + (i * (size.y / rows)), size.x / cols, size.y / rows);
        }
      }
    }
    
    for (UIElement e : elements) {
      e.draw();
    }
  }
  
  public PVector posAt(int row, int col) {
    return new PVector(pos.x + (col * (size.x / cols)), pos.y + (row * (size.y / rows)));
  }
  
  public UIElement getElement(int row, int col) {
    for (int i = 0; i < elements.size(); i++) {
      if (positions.get(i).x == row && positions.get(i).y == col) {
        return elements.get(i);
      }
    }
    
    return new UIElement(new PVector(), new PVector());
  }
}
