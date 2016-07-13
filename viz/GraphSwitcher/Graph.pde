/*Template for different types of graphs. Handles all graph functions except
  for management of and drawing the data. */
public abstract class Graph {
  protected float minY, maxY;  //min and max y values
  protected float originX, originY;
  protected int numElems;
  protected float width_g, height_g; //width and height of the box around the graph
  protected float boxX, boxY; //top left corner of the box
  protected float width_scale, height_scale; // used to size the graph
  protected float top; // y coordinate of the top y axis tick
  protected String L1, L2;
  
  public Graph() {
    width_scale = .85;
    height_scale = .80;
    setOrigin();
  }

  //draws a box around the graph
  protected void drawBox() {
    width_g  = width * width_scale;
    height_g = height * height_scale;
    boxX     = (width  - width_g)  / 2;
    boxY     = (height - height_g) / 2;
    stroke(255);
    fill(255);
    rect(boxX, boxY, width_g, height_g);
  }
  
  //draws the title, y label and x label
  protected void drawLabels() {
    fill(0);
    textAlign(CENTER, BOTTOM);
    textSize(boxY * .4);
    text(L2 + " vs. " + L1, (width - width_g) / 2, 0, width_g, boxY); // title
    textAlign(CENTER, TOP);
    textSize(boxY * .4);
    text(L1, 0, boxY + height_g, width, height); //xLabel
    textAlign(RIGHT, CENTER);
    textSize(boxY * .4);
    text(L2, 0, boxY, boxX, boxY + height_g); //yLabel
  }
  
  //calculates the location of the origin
  protected void setOrigin() {
    originX = (.1 * width_g) + boxX;
    originY = height - (.22 * height_g);
  }
  
  protected void setTop() {
    top = (height_g * .05) + boxY;
    if(top < (boxY + 12))
      top = boxY + 12;
  }  
  
  protected float getGraphWidth() {
    return width_g;
  }
  
  protected float getGraphHeight() {
    return height_g;
  }
  
  public void setXLabel(String inLabel) {
    L1 = inLabel;
  }
  
  public void setYLabel(String inLabel) {
    L2 = inLabel;
  }
  
  protected void drawAxes() {
    stroke(0);
    line(originX, originY, boxX + width_g, originY);
    line(originX, originY, originX, boxY);
  }

  /*draws 5 evenly spaced ticks on the y axis and calculates their
  value based on the data */
  protected void drawYTicks() {
    float half_length = .005 * width_g; // half the length of 1 tick
    float spacing = (originY - top) / 4.0;
    float diff = (maxY - minY) / 4.0; // difference between the y values
    fill(0);
    float x = originX - half_length;
    float y;
    float text_size;
    for(int i = 0; i < 5; i++) {
      y = originY - (spacing * i);
      line(x, y, originX + half_length, y);
      text_size = ((width_g + height_g) / 2) * .02;
      textSize(text_size);
      textAlign(RIGHT, CENTER);
      text((minY + (diff * i)), x - 2, y);
    }
  }
  
  //Draws the name of a data element along the x axis
  protected void drawCaption(float x, float y, String name, float spacing) {
    fill(0);
    float text_size = ((width_g + height_g) / 2) * .02;
    textSize(text_size);
    textAlign(CENTER, TOP);
    text(name, x - (spacing / 2), y, spacing, (boxY + height_g) - y);
  }  
  
  //main draw routine
  public void drawGraph() {
    setTop();
    drawBox();
    setOrigin();
    drawLabels();
    drawAxes();
    drawYTicks();
    drawData();  
  }
  
  //draws the points and x axis ticks
  protected abstract void drawData();
}
