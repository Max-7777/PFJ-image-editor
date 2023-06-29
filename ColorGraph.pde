class ColorGraph {
  int[] reds, greens, blues;
  int max = 0;
  PVector pos, size;
  
  ColorGraph(PVector size) {
    this.size = size;
    this.pos = new PVector(1200,40);
    
    reds = new int[256];
    greens = new int[256];
    blues = new int[256];
  }
  
  void update(PImage buffer) {
    reds = new int[256];
    greens = new int[256];
    blues = new int[256];
    
    for (int i = 0; i < buffer.pixels.length; i++) {
      color c = buffer.pixels[i];
      reds[(int) red(c)]++;
      greens[(int) green(c)]++;
      blues[(int) blue(c)]++;
    }
    
    //this.max = 0;
    //int maxIndex = -1;
    //String maxColor = "z";  
    //for (int i = 0; i < 256; i++) {
    //  if (blues[i] > this.max) {
    //    this.max = blues[i];
    //    maxIndex = i;
    //    maxColor = "blue"; 
    //  }
    //  if (reds[i] > this.max) {
    //    this.max = reds[i];
    //    maxIndex = i;     
    //    maxColor = "red";
    //  }
    //  if (greens[i] > this.max) {
    //    this.max = greens[i];
    //    maxIndex = i;
    //    maxColor = "green";
    //  }
    //}
    
    this.max = (int) graphSlider.currVal;
    
    //max = 0;
    //for (int i = 0; i < 256; i++) {
    //  if (reds[i] > max) max = reds[i];
    //}
    //for (int i = 0; i < 256; i++) {
    //  if (greens[i] > max) max = greens[i];
    //}
    //for (int i = 0; i < 256; i++) {
    //  if (blues[i] > max) max = blues[i];
    //}

    //println("max index: " + maxColor + ": " + maxIndex);
    //println("r:   " + reds[20]);
    
    
  }

  void draw() {
    //bg
    fill(bg);
    noStroke();
    stroke(40);
    int padding = 40;
    rect(this.pos.x - padding / 2, this.pos.y - padding, this.size.x + padding, this.size.y + 1.7*padding);

    
    //grid
    int rows = 6;
    int cols = 8;
    float rowSize = this.size.y / rows;
    float colSize = this.size.x / cols;
    fill(80);
    stroke(150);
    
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    for (int i = 0; i <= rows; i++) {
      for (int j = 0; j <= cols; j++) {
        line(j * colSize, i * rowSize, j * colSize, this.size.y);
        line(j * colSize, i * rowSize, this.size.x, i * rowSize);
      }
    }
    popMatrix();
    
    //color dots
    pushMatrix();
    translate(this.pos.x, this.pos.y + this.size.y);
    scale(1,-1);
    PVector sc = new PVector( size.x / 256, size.y / this.max);
    ellipseMode(CENTER);
    noStroke();
    int sz = 3;
    for (int i = 0; i < 256; i++) {
      noStroke();
      fill(255, 0, 0);
      ellipse(i * sc.x, reds[i] * sc.y, sz, sz);
      fill(0, 255, 0);
      ellipse(i * sc.x, greens[i] * sc.y, sz, sz);
      fill(0, 0, 255);
      ellipse(i * sc.x, blues[i] * sc.y, sz, sz);
      
      //if dots overlapping, draw gray
      if (reds[i] == greens[i] && greens[i] == blues[i]) {
        noStroke();
        fill(80, 80, 80);
        ellipse(i * sc.x, reds[i] * sc.y, sz, sz);
      }
      
      if (i == 255) continue;
      //lines connecting dots
      strokeWeight(2);
      stroke(255, 0, 0);
      line(i * sc.x, reds[i] * sc.y, (i+1) * sc.x, reds[i+1] * sc.y);
      stroke(0, 255, 0);
      line(i * sc.x, greens[i] * sc.y, (i+1) * sc.x, greens[i+1] * sc.y);
      stroke(0, 0, 255);
      line(i * sc.x, blues[i] * sc.y, (i+1) * sc.x, blues[i+1] * sc.y);
      
      //if lines overlapping draw gray
      if ((reds[i] == greens[i] && greens[i] == blues[i]) || (reds[i] > graphSlider.rangeVal.y && greens[i] > graphSlider.rangeVal.y && blues[i] > graphSlider.rangeVal.y)) {
        stroke(80, 80, 80);
        line(i * sc.x, reds[i] * sc.y, (i+1) * sc.x, reds[i+1] * sc.y);
      }
    }
    
    noStroke();
    
    popMatrix();
    
    //label 'Color Graph'
    fill(90);
    textAlign(CENTER);
    textSize(textSize / 1.1);
    text("Color Graph", (this.pos.x + this.pos.x + this.size.x) / 2, this.pos.y - 12);
    textSize(textSize);
    textAlign(LEFT);
  }
}
