River r;
PGraphics pickbuffer;
Parser p;
int cur_width, cur_height;
int highlighted; // id of the highlighted stream

void setup() {
  //frame.setResizable(true);
  cur_width = 800;
  cur_height = 600;
  size(cur_width, cur_height);
  pickbuffer = createGraphics(width, height);
  p = new Parser("data.csv");
  r = new River(p.getStreams());
  pickbuffer = createGraphics(width, height);
  drawBackBuffer();
  setHighlightedStream();
}

void draw() {
  background(255);
  r.drawRiver(highlighted);
}

// checks the pickbuffer for the id of the highlighted stream
void setHighlightedStream() {
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
  setHighlightedStream();
}

void drawBackBuffer() {
  pickbuffer.beginDraw();
  pickbuffer.background(255);
  r.renderBackBuffer(pickbuffer);
  pickbuffer.endDraw();
}

