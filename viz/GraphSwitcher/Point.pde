/* DataElement type for line graphs */
public class Point extends DataElement {

  private float diam;
  private float small_diam;  //when mouse is not over the point
  private float big_diam;  //when mouse is over the point
  
  //calculates the size of the point and the size of the highlighted point
  public Point(String n, float val) {
    super(n, val);
    small_diam = .01 * ((width + height) / 2);
    big_diam   =  small_diam * 2;
    diam       =  small_diam;
  }
  
  public Point(float _x, float _y, String n, float val) {
    super(n, val);
    small_diam = .01 * ((width + height) / 2);
    big_diam   =  small_diam * 2;
    diam       =  small_diam;
  }
  
  public float getDiam() {
    return diam;
  }
  
  //draws the point. If the mouse is over the point, draws the point highlighted
  public void drawDataElement() {
    small_diam = .01 * ((width + height) / 2);
    big_diam = small_diam * 2;
    if(mouseIsOverDataElement()) {
      diam = big_diam;
      drawDataElementHilighted();
    }
    else {
      diam = small_diam;
      fill(0);
      ellipse(posX, posY, diam, diam);
    }
  }
  
  private boolean mouseIsOverDataElement() {
    return mouseDistance() <= (diam);
  }
    
  private float mouseDistance() {
    return sqrt((float)(pow((mouseX - posX), 2) + pow((mouseY - posY), 2)));
  }
  
  private void drawDataElementHilighted() {
    stroke(0);
    fill(0, 0, 255);
    ellipse(posX, posY, diam, diam);
    fill(0);
    textSize(((width + height) / 2) * .02);
    textAlign(CENTER, BOTTOM);
    text(name + ", " + value, posX, posY - (diam / 2));
  }
}
