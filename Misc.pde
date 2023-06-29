PVector worldToScreen(PVector worldPos, PVector offset, PVector scale) {
    float x = (worldPos.x - offset.x) * scale.x;
    float y = (worldPos.y - offset.y) * scale.y;
    return new PVector(x,y);
}

PVector worldToScreen(PVector worldPos, PVector offset, float scale) {
    float x = (worldPos.x - offset.x) * scale;
    float y = (worldPos.y - offset.y) * scale;
    return new PVector(x,y);
}

PVector screenToWorld(PVector screenPos, PVector offset, PVector scale) {
    float x = (screenPos.x / scale.x) + offset.x;
    float y = (screenPos.y / scale.y) + offset.y;
    return new PVector(x,y);
}

PVector screenToWorld(PVector screenPos, PVector offset, float scale) {
    float x = (screenPos.x / scale) + offset.x;
    float y = (screenPos.y / scale) + offset.y;
    return new PVector(x,y);
}


PVector worldToScreen(PVector worldSize, PVector scale) {
    float w = worldSize.x * scale.x;
    float h = worldSize.y * scale.y;
    return new PVector(w, h);
}

float worldToScreen(float worldSize, float scale) {
    return worldSize * scale;
}


PVector screenToWorld(PVector screenSize, PVector scale) {
    float w = screenSize.x / scale.x;
    float h = screenSize.y / scale.y;
    return new PVector(w, h);
}

float screenToWorld(float screenSize, float scale) {
    return screenSize / scale;
}

void textStroke(String text, float x, float y) {
  fill(0);
  for(int i = -1; i <= 1; i++){
    text(text, x+i,y);
    text(text, x,y+i);
  }
  
  fill(255);
  
  text(text, x, y);
}

void textStroke(String text, float x, float y, int thickness) {
  fill(0);
  for(int i = -thickness; i <= thickness; i++){
    text(text, x+i,y);
    text(text, x,y+i);
  }
  
  fill(255);
  
  text(text, x, y);
}

void textStroke(String text, float x, float y, int thickness, float alpha) {
  fill(0, alpha);
  for(int i = -thickness; i <= thickness; i++){
    text(text, x+i,y);
    text(text, x,y+i);
  }
  
  fill(255, alpha);
  
  text(text, x, y);
}

void textStroke(String text, float x, float y, int thickness, int textSize, float alpha) {
  fill(0, alpha);
  textSize(textSize);
  for(int i = -thickness; i <= thickness; i++){
    text(text, x+i,y);
    text(text, x,y+i);
  }
  
  fill(255, alpha);
  
  text(text, x, y);
}

boolean mouseIn(PVector TL, PVector size) {
  return mouseX > TL.x && mouseX < TL.x + size.x && mouseY > TL.y && mouseY < TL.y + size.y;
}

boolean pointInsideRect(PVector point, PVector pos, PVector size) {
  return (point.x > pos.x && point.x < pos.x + size.x) && (point.y > pos.y && point.y < pos.y + size.y);
}
