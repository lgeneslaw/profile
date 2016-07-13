class Circle {
  private float x, y, diam, xv, yv;
  private int r, g, b, trans;
  private int stroke_r, stroke_g, stroke_b;
  //private float priority;
  private float max_xv, max_yv;
  private boolean moving;
  
  public Circle(float inX, float inY, float inD) {
    instantiate(inX, inY, inD);
  }
  
  private void instantiate(float inX, float inY, float inD) {
    x = inX;
    y = inY;
    diam = inD;
    do {
      xv = random(-4, 4);
    }while(abs(xv) < .5);
    do {
      yv = random(-4, 4);
    }while(abs(yv) < .5);
    max_xv = xv;
    max_yv = yv;
    //priority = random(1, numCircles);
    moving = true;
  }
  
  void reInstantiate() {
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
    do {
      xv = random(-3, 3);
    }while(abs(xv) < 1);
    do {
      yv = random(-3, 3);
    }while(abs(yv) < .5);
    max_xv = xv;
    max_yv = yv;
    diam = random(10, 200);
  }
  
  public void move() {
    if((x < diam/2) || (x > (width-diam/2))) {
      xv = -xv;
      max_xv = xv;
    }
    if((y < diam/2) || (y > (height-diam/2))) {
      yv = -yv;
      max_yv = yv;
    }
    x += xv;
    y += yv;
}
  
  public void start_stop() {
    if(moving) {
      xv = 0;
      yv = 0;
    }
    else {
      xv = max_xv;
      yv = max_yv;
    }
    moving = !moving;
  }
  
  public float getDiameter() {
    return diam;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getXVel() {
    return xv;
  }
  
  public float getYVel() {
    return yv;
  }
  
  public void drawCircle() {
    strokeWeight(5);
    stroke(stroke_r, stroke_g, stroke_b);
    fill(r, g, b, trans);
    ellipse(x, y, diam, diam);
  }
  
  public void drawWhite() {
    strokeWeight(5);
    stroke(stroke_r, stroke_g, stroke_b);
    fill(255, 255, 255, 0);
    ellipse(x, y, diam, diam);
  }
  
  public void setFillColor(int inR, int inG, int inB, int inTrans) {
    r = inR;
    g = inG;
    b = inB;
    trans = inTrans;
  }
  
  public void setStrokeColor(int inR, int inG, int inB) {
    stroke_r = inR;
    stroke_g = inG;
    stroke_b = inB;
  }
  
  public boolean mouseInCircle() {
    if(mouseDistance() <= diam/2)
      return true;
    return false;
  }
  
  private float mouseDistance() {
    return sqrt((float)(Math.pow((mouseX - x), 2) + Math.pow((mouseY - y), 2)));
  }
}
