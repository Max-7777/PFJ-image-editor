PImage buffer = createImage(10, 10, RGB);
PImage readBuffer = buffer.copy();
PImage paddedBuffer;
int currentIndex = 0;
boolean working = false;
List<String> jobs = new ArrayList<>();
List<float[]> params = new ArrayList<>();
//milli
float timeLimit = 50;
float pt = System.nanoTime() * NANO_TO_MILLI;

void request(String filter, float... params_) {
  filter = filter.toLowerCase();
  //add or update current jobs
  if (jobs.contains(filter)) {
    //if its current filter, reset index and do again
    if (jobs.indexOf(filter) == 0) {
      currentIndex = 0;  
    }
    jobs.set(jobs.indexOf(filter), filter);
    params.set(jobs.indexOf(filter), params_);
  } else {
    jobs.add(filter);
    params.add(params_);
  }
}

void setBuffer(PImage readImage) {
  buffer = readImage.copy();
  readBuffer = buffer.copy();
}

void updateEditor() {
  if (jobs.size() <= 0) {
    working = false;
    return;
  }
  
  working = true;
  
  switch (jobs.get(0)) {
    case "brighten":
      buffer = brighten(params.get(0)[0]);
      break;
    case "blur":
      buffer = blur(params.get(0)[0]);
      break;
    case "threshold":
      buffer = threshold(params.get(0)[0]);
      break;
    case "bloom":
      buffer = bloom(params.get(0)[0]);
      break;
    case "invert":
      buffer = invert();
      break;
    case "mirror x-axis":
      buffer = mirrorX();
      break;
    case "mirror y-axis":
      buffer = mirrorY();
      break;
    case "threshold color":
      buffer = thresholdColor(params.get(0)[0]);
      break;
    case "padding":
      buffer = padding(round(params.get(0)[0]));
      break;
    case "grayscale":
      buffer = grayscale();
      break;
    case "remove red":
      buffer = removeColor("red");
      break;
    case "remove green":
      buffer = removeColor("green");
      break;
    case "remove blue":
      buffer = removeColor("blue");
      break;
    case "saturate":
      buffer = saturate(params.get(0)[0]);
      break;
    case "contrast":
      buffer = contrast(params.get(0)[0]);
  }
  
  //finish job
  if (currentIndex >= buffer.pixels.length - 1) {
    finishJob();
    updateEditor();
  }
}

void finishJob() {
  currentIndex = 0;
  jobs.remove(0);
  params.remove(0);
  readBuffer = buffer.copy();
}

PImage mirrorY() {
  PImage writeImage = createImage(buffer.width, buffer.height, RGB);
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    int r = i / writeImage.width;
    int col = i % writeImage.width;
    col = -abs(col - (readBuffer.width / 2)) + (readBuffer.width / 2);
    int index = (r * readBuffer.width) + col;
    color c = readBuffer.pixels[index];
    writeImage.pixels[i] = c;
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}


PImage testzzz(PImage readImage) {
  if (currentIndex == 0) {
    //currentFilter = "test";
    buffer = readImage.copy();
  }
  working = true;
  PImage writeImage = readImage.copy();
  currentIndex++;
  writeImage.pixels[currentIndex] = color(0, 0, 0);
  if (currentIndex == writeImage.pixels.length - 1) {
    working  = false;
    currentIndex = 0;
  }
  return writeImage;
}

PImage mirrorX() {
  PImage writeImage = createImage(buffer.width, buffer.height, RGB);
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    int r = i / writeImage.width;
    int col = i % writeImage.width;
    r = -abs(r - (readBuffer.height / 2)) + (readBuffer.height / 2);
    int index = (r * readBuffer.width) + col;
    color c = readBuffer.pixels[index];
    writeImage.pixels[i] = c;
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage invert() {
  PImage writeImage = createImage(buffer.width, buffer.height, RGB);
  
  pt = System.nanoTime() * NANO_TO_MILLI;

  for (; currentIndex < writeImage.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    c = color(255 - red(c), 255 - green(c), 255 - blue(c));
    writeImage.pixels[i] = c;
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage blur(float radius) {
  radius = round(radius);
  PImage writeImage = buffer.copy();
  PImage readBuffer2 = addPadding(readBuffer, (int) radius);
  
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < writeImage.pixels.length; currentIndex++) {
    int i = currentIndex;
    int row = i / writeImage.width;
    int col = i % writeImage.width;
    int r = 0, g = 0, b = 0;
    
    for (int j = (int) -radius; j < radius + 1; j++) {
      for (int k = (int) -radius; k < radius + 1; k++) {
        //int index = ((row + j) * writeImage.width) + (col + k);
        int index = paddingTransform(buffer, row + j, col + k, (int) radius);
        color c = readBuffer2.pixels[index];
        
        r += red(c);
        g += green(c);
        b += blue(c);
      }
    }
    
    r /= ((2 * radius) + 1) * ((2 * radius) + 1);
    g /= ((2 * radius) + 1) * ((2 * radius) + 1);
    b /= ((2 * radius) + 1) * ((2 * radius) + 1);
    
    writeImage.pixels[i] = color(r, g, b);
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage removeColor(String c) {
  PImage writeImage = createImage(readBuffer.width, readBuffer.height, RGB);
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < readBuffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    color cc = readBuffer.pixels[i];
    if (c.equals("red")) cc = color(0, green(cc), blue(cc));
    if (c.equals("green")) cc = color(red(cc), 0, blue(cc));
    if (c.equals("blue")) cc = color(red(cc), green(cc), 0);

    writeImage.pixels[i] = cc;
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage grayscale() {
  PImage writeImage = createImage(readBuffer.width, readBuffer.height, RGB);

  pt = System.nanoTime() * NANO_TO_MILLI;

  for (; currentIndex < writeImage.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    color cc = color((red(c) + green(c) + blue(c)) / 3);
    writeImage.pixels[i] = cc;
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

color blurPixel(PImage img, int i, float radius) {
  radius = round(radius);
  //PImage paddedImg = createImage(img.width + ((int) radius * 2), img.height + ((int) radius * 2), RGB);
  int row = i / img.width;
  int col = i % img.width;
  int r = 0, g = 0, b = 0;
  
  for (int j = (int) -radius; j < radius + 1; j++) {
    for (int k = (int) -radius; k < radius + 1; k++) {
      int index = paddingTransform(img, row - j, col - k, (int) radius);
      color c = paddedBuffer.pixels[index];
      
      r += red(c);
      g += green(c);
      b += blue(c);
    }
  }
  
  r /= ((2 * radius) + 1) * ((2 * radius) + 1);
  g /= ((2 * radius) + 1) * ((2 * radius) + 1);
  b /= ((2 * radius) + 1) * ((2 * radius) + 1);
  
  return color(r, g, b);
}

PImage bloom(float amt) {
  if (currentIndex == 0) paddedBuffer = addPadding(buffer, (int) round(amt));
  
  PImage writeImage = buffer.copy();
  
  pt = System.nanoTime() * NANO_TO_MILLI;
    
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    
    color blurred = blurPixel(readBuffer, i, amt);
    if (brightness(blurred) == 0) {
      writeImage.pixels[i] = readBuffer.pixels[i];
    } else {
      //blur/bloom
      writeImage.pixels[i] = (total(readBuffer.pixels[i]) > total(blurred)) ? readBuffer.pixels[i] : blurred;
    }
    
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage threshold(float lim) {
  PImage writeImage = buffer.copy();
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    writeImage.pixels[i] = ((red(c) + green(c) + blue(c)) / 3 > lim) ? readBuffer.pixels[i] : color(0, 0, 0);
    if (pastLimit()) return writeImage;  
  }
  
  return writeImage;
}

PImage thresholdColor(float lim) {
  PImage writeImage = buffer.copy();
  
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    float r = (red(c) > lim ? red(c) : 0);
    float g = (green(c) > lim ? green(c) : 0);
    float b = (blue(c) > lim ? blue(c) : 0);
    writeImage.pixels[i] = color(r, g, b);
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

PImage contrast(float strength) {
  println(strength);
  float lim = 200;
  PImage writeImage = buffer.copy();
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    int br = total(readBuffer.pixels[currentIndex]);
    int addition = (int) ((strength * 0.3) * (br - lim));
    if (addition < 0) addition *= 6;
    writeImage.pixels[currentIndex] = brighten(readBuffer.pixels[currentIndex], addition);
  }
  
  return writeImage;
}

boolean pastLimit() {
  return (System.nanoTime() * NANO_TO_MILLI) - pt >= timeLimit;
}

PImage brighten(float amt) {
  PImage writeImage = buffer.copy();
  pt = System.nanoTime() * NANO_TO_MILLI;
  
  for (; currentIndex < buffer.pixels.length; currentIndex++) {
    writeImage.pixels[currentIndex] = brighten(buffer.pixels[currentIndex], amt);
    if (pastLimit()) return writeImage;
  }
  
  return writeImage;
}

//PImage saturate1(PImage readImage, int amt) {
//  PImage writeImage = createImage(readImage.width, readImage.height, RGB);
//  for (int i = 0; i < readImage.pixels.length; i++) {
//    color c = readImage.pixels[i];
//    float r = red(c);
//    float g = green(c);
//    float b = blue(c);
//    float max = max(r, g, b);
//    color nc = c;
//    int subAmt = (int) ((total(c) / 3 > 240) ? 0 : -amt * 0.5);
//    if (red(c) == max) nc = add(c, amt, subAmt, subAmt);
//    if (green(c) == max) nc = add(c, subAmt, amt, subAmt);
//    if (blue(c) == max) nc = add(c, subAmt, subAmt, amt);
//    if (total(c) / 3 == red(c)) nc = c;
        
//    writeImage.pixels[i] = nc;
//  }

//  return writeImage;
//}

PImage saturate(float amt) {
  PImage writeImage = buffer.copy();
  pt = System.nanoTime() * NANO_TO_MILLI;

  for (; currentIndex < readBuffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    float avg = total(c) / 3;
    float amt2 = amt;
    float diff = maxChannel(c) - minChannel(c);
    amt2 = Math.min(1, 0.03*diff) * amt;

    
    //float r2 = r + ((r - avg >= 0) ? amt2 : -amt2);    
    //float g2 = g + ((g - avg >= 0) ? amt2 : -amt2);    
    //float b2 = b + ((b - avg >= 0) ? amt2 : -amt2);
    
    float rFactor = 0.1 * (r - avg);
    rFactor = Math.max(0, Math.min(1, rFactor));
    
    float gFactor = 0.1 * (g - avg);
    gFactor = Math.max(0, Math.min(1, gFactor));

    float bFactor = 0.1 * (b - avg);
    bFactor = Math.max(0, Math.min(1, bFactor));

    float r2 = r + (rFactor * amt2);
    float g2 = g + (gFactor * amt2);
    float b2 = b + (bFactor * amt2);

    writeImage.pixels[i] = color((int) r2, (int) g2, (int) b2);
    if (pastLimit()) return writeImage;
  }

  return writeImage;
}

PImage saturate2(float amt) {
  pt = System.nanoTime() * NANO_TO_MILLI;
  amt = (int) amt;
  
  PImage writeImage = createImage(buffer.width,  buffer.height, RGB);
  for (; currentIndex < readBuffer.pixels.length; currentIndex++) {
    int i = currentIndex;
    color c = readBuffer.pixels[i];
    float min = minChannel(c);
    color nc = c;
    if (red(c) == min) nc = add(c, -amt, 0, 0);
    if (green(c) == min) nc = add(c, 0, -amt, 0);
    if (blue(c) == min) nc = add(c, 0, 0, -amt);
    if (maxChannel(c) - minChannel(c) < 10) nc = c;
        
    writeImage.pixels[i] = nc;
    if (pastLimit()) return writeImage;
  }

  return writeImage;
}

int total(color c) {
  return (int) (red(c) + green(c) + blue(c));
}

color darken(color c, int v) {
  return color(red(c) - v, green(c) - v, blue(c) - v);
}

color darken(color c) {
  return color(red(c) - 20, green(c) - 20, blue(c) - 20);
}

color brighten(color c) {
  return color(red(c) + 20, green(c) + 20, blue(c) + 20);
}

color brighten(color c, float v) {
  return color(red(c) + v, green(c) + v, blue(c) + v);
}

color add(color c1, color c2) {
  return color(red(c1) + red(c2), green(c1) + green(c2), blue(c1) + blue(c2));
} 

color add(color c1, float... a) {
  return color(red(c1) + a[0], green(c1) + a[1], blue(c1) + a[2]);
}

float maxChannel(color c) {
  return max(red(c), blue(c), green(c));
}

float minChannel(color c) {
  return min(red(c), blue(c), green(c));
}

PImage addPadding(PImage readImage, int padding) {
  PImage newImg = createImage(readImage.width + (padding * 2), readImage.height + (padding * 2), RGB);
  color avgColor = getAvg(readImage);
  
  for (int i = 0; i < newImg.pixels.length; i++) {
    int row = i / newImg.width;
    int col = i % newImg.width;
    if ((row > padding - 1 && row < newImg.height - padding) && (col > padding - 1 && col < newImg.width - padding)) {
      int i2 = inversePaddingTransform(readBuffer, i, padding);
      newImg.pixels[i] = readImage.pixels[i2];
    } else {
      newImg.pixels[i] = avgColor;
    }
    
  } 
  
  return newImg;
}

PImage padding(int padding) {
  PImage newImg = createImage(buffer.width + (padding * 2), buffer.height + (padding * 2), RGB);

  for (; currentIndex < newImg.pixels.length; currentIndex++) {
    int i = currentIndex;
    int row = i / newImg.width;
    int col = i % newImg.width;
    if ((row > padding - 1 && row < newImg.height - padding) && (col > padding - 1 && col < newImg.width - padding)) {
      int i2 = inversePaddingTransform(readBuffer, i, padding);
      newImg.pixels[i] = readBuffer.pixels[i2];
    } else {
      newImg.pixels[i] = color(0, 0, 0);
    } 
  } 
  
  return newImg;
}

int inversePaddingTransform(PImage originalImg, int index, int padding) {
  int row = index / (originalImg.width + (padding * 2));
  int col = index % (originalImg.width + (padding * 2));
  return ((row - padding) * originalImg.width) + (col - padding);
}

int paddingTransform(PImage originalImg, int index, int padding) {
  int row = index / originalImg.width;
  int col = index % originalImg.width;
  return ((row + padding) * (originalImg.width + (2 * padding))) + (col + padding);
}

int paddingTransform(PImage originalImg, int row, int col, int padding) {
  return ((row + padding) * (originalImg.width + (2 * padding))) + (col + padding);
}

color getAvg(PImage img) {
  int r = 0;
  int g = 0;
  int b = 0;
  
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    r += red(c);
    g += green(c);
    b += blue(c);
  }
  int size = img.width * img.height;
  return color(round(r / size), round(g / size), round(b / size));
}
