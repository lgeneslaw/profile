class MyButton {
  private float x, y, w, l;
  private int r, g, b;
  private String msg;
  
  public MyButton() {
    r = 255;
    g = 0;
    b = 0;
  }
  
  public MyButton(float inX, float inY, float inW, float inL, String inMsg) {
    instantiate(inX, inY, inW, inL, inMsg);
  }
  
  private void instantiate(float inX, float inY, float inW, float inL, String inMsg) {
    x = inX;
    y = inY;
    w = inW;
    l = inL;
    msg = inMsg;
  }
  
  public void setButton(float inX, float inY, float inW, float inL, String inMsg) {
    instantiate(inX, inY, inW, inL, inMsg);
  }
  
  public void setText(String inMsg) {
    msg = inMsg;
  }
  
  public float getWidth() {
    return w;
  }
  
  public float getLength() {
    return l;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public void drawMyButton() {
    if(mouseIsOverButton())
      fill(r, 128, 128);
    else
      fill(r, g, b);
    rect(x, y, w, l);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(((width + height) / 2) * .018);
    text(msg, x + (w / 2), y + (l / 2));
  }
  
  private boolean mouseIsOverButton() {
    if((mouseX < x) || (mouseX > (x + w)))
      return false;
    if((mouseY < y) || (mouseY > (y + l)))
      return false;
    return true;
  }
      
  public void setFillColor(int inR, int inG, int inB) {
    r = inR;
    g = inG;
    b = inB;
  }
}
