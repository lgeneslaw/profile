/* DataElement type for a bar graph. posX and posY represent the top 
  left corner of the bar */
public class Bar extends DataElement {
  private int r, g, b;
  private float bar_width, bar_height;
  
  public Bar(String n, float val) {
    super(n, val);
    r = 50;
    g = 100;
    b = 50;
  }
  
  public void setBarWidth(float inWidth) {
    bar_width = inWidth;
  }
  
  public void setBarHeight(float inHeight) {
    bar_height = inHeight;
  }
  
  public float getBarWidth() {
    return bar_width;
  }
  
  public float getBarHeight() {
    return bar_height;
  }
  
  public void drawDataElement() {
    if(mouseIsOverDataElement()) {
      drawDataElementHilighted();
      return;
    }
    stroke(0);
    fill(r, g, b);
    rect(posX - (bar_width / 2), posY, bar_width, bar_height);
  }
  
  private boolean mouseIsOverDataElement() {
    float x = posX - (bar_width / 2);
    float y = posY;
    if((mouseX < x) || (mouseX > (x + bar_width)))
      return false;
    if((mouseY < y) || (mouseY > (y + bar_height)))
      return false;
    return true;
  }
  
  //draws a bar with a different color and displays its name and value
  private void drawDataElementHilighted() {
    stroke(0);
    fill(20, 0, 150);
    rect(posX - (bar_width / 2), posY, bar_width, bar_height);
    fill(0);
    float text_size = ((width + height) / 2) * .02;
    textSize(text_size);
    textAlign(CENTER, BOTTOM);
    text(name + ", " + value, posX, posY - (text_size / 2));
  }
}
