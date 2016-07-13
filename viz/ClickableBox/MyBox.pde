class MyBox {
  private int x, y, w, l;
  private int r, g, b;
  private String msg;
  
  public MyBox(int inX, int inY, int inW, int inL, String inMsg) {
    instantiate(inX, inY, inW, inL, inMsg);
  }
  
  private void instantiate(int inX, int inY, int inW, int inL, String inMsg) {
    x = inX;
    y = inY;
    w = inW;
    l = inL;
    msg = inMsg;
  }
  
  public int getWidth() {
    return w;
  }
  
  public int getLength() {
    return l;
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  public void drawMyBox() {
    fill(0);
    text(msg, x, y);
    fill(r, g, b);
    rect(x, y, w, l);
  }
  
  public void setFillColor(int inR, int inG, int inB) {
    r = inR;
    g = inG;
    b = inB;
  }
}
