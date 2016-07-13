Circle circles[];
int numCircles = 35;

void setup() {
  size(1000, 500);
  circles = new Circle[numCircles];
  float diam, xvel, yvel;
  int r, g, b, stroke_r, stroke_g, stroke_b;
  for(int i = 0; i < numCircles; i++) {
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
    stroke_r = (int)random(255);
    stroke_g = (int)random(255);
    stroke_b = (int)random(255);
    diam = random(10, 200);
    circles[i] = new Circle(random(diam/2, width - diam/2),
      random(diam/2, height - diam/2), diam);
    circles[i].setFillColor(r, g, b, 128);
    circles[i].setStrokeColor(stroke_r, stroke_g, stroke_b);
  }
}

void draw() {
  background(255);
  Circle c;
  Circle temp;
  for(int i = 0; i < numCircles; i++) {
    c = circles[i];
    c.move();
    if(c.mouseInCircle())
      c.drawCircle();
    else
      c.drawWhite();
  }
}

void mouseClicked() {
  Circle c;
  for(int i = 0; i < numCircles; i++) {
    c = circles[i];
    if(c.mouseInCircle())
      c.start_stop();
  }
}
