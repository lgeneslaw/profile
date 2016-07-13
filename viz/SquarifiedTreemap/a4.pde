Rectangle root;
PGraphics pickbuffer;
float scale = .9;
int highlighted;
int cur_width, cur_height;

void drawBackBuffer() {
  pickbuffer.beginDraw();
  pickbuffer.background(255);
  root.renderBackBuffer(pickbuffer);
  pickbuffer.endDraw();
}

void setup() {
  //frame.setResizable(true);
  cur_width = 700;
  cur_height = 600;
  size(cur_width, cur_height);
  Parser p = new Parser("data.csv");
  root = p.getRoot();
  root.setValue();
  pickbuffer = createGraphics(width, height);
}

void draw() {
  float x = (1 - scale) * width;
  float y = (1 - scale) * height;
  float w = (scale * width) - x;
  float h = (scale * height) - y;
  root.setDimensions(w, h);
  root.setX(x);
  root.setY(y);
  root.placeChildren();
  drawBackBuffer();
  setHighlightedRect();
  root.drawChildren(highlighted);
}

// checks the pickbuffer for the id of the highlighted stream
void setHighlightedRect() {
  highlighted = pickbuffer.get(mouseX, mouseY);
  highlighted = highlighted & 0xFFFFFF;
}

void mouseMoved() {
  if((width != cur_width) || (height != cur_height)) {
    pickbuffer = createGraphics(width, height);
    drawBackBuffer();
    cur_width = width;
    cur_height = height;
  }
  setHighlightedRect();
}
