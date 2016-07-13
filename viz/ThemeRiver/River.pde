// Holds and knows how to draw an ArrayList of Streams
public class River {
  private ArrayList streams;
  private ArrayList heights; // the sum of the heights at each time step
  private int numStreams;
  private int numPoints;
  private float h;  // largest height of the river
  private float scale; // used to scale the river to the window
  private float spacing; // pixel spacing between time steps
  
  public River(ArrayList s) {
    streams = s;
    numStreams = s.size();
    heights = new ArrayList();
    fillHeights();
    h = largestHeight();
    Stream temp = (Stream)streams.get(0);
    numPoints = temp.getNumPoints();
    calcScale();
    calcSpacing();
    colorStreams();
  }
  
  
  // adds all of the values at a given time step and pushes the sum onto heights
  private void fillHeights() {
    float sum = 0;
    Stream temp;
    temp = (Stream)streams.get(0);
    int points = temp.getNumPoints();
    Point p;
    for(int i = 0; i < points; i++) {
      for(int j = 0; j < numStreams; j++) {
        temp = (Stream)streams.get(j);
        p = (Point)temp.getPoints().get(i);
        sum += p.getValue();
      }
      //heights.add(new Float(sum));
      heights.add(sum);s
      sum = 0;
    }
  }
  
  
  // returns the largest value in heights
  private float largestHeight() {
    float high = (Float)heights.get(0);
    for(int i = 1; i < heights.size(); i++) {
      if(high < (Float)heights.get(i))
        high = (Float)heights.get(i);
    }
    return high;
  }
  
  
  // sets scale based on the height of the window and h
  private void calcScale() {
    float numPix = .7 * height;
    scale = numPix / h;
  }
  
  
  // sets the spacing based on the number of points and the width of the window
  private void calcSpacing() {
    spacing = width / (numPoints - 1);
  }
  
  
  // sets the r, g, and b values for each stream
  public void colorStreams() {
    Stream s;
    for(int i = 0; i < numStreams; i++) {
      s = (Stream)streams.get(i);
      s.setFillColor(numStreams);
    }
  }



  /* draws all of the streams using curveVertex(). If id matches the id of one of the streams,
   then that stream is drawn highlighted with text over the mouse */
  public void drawRiver(int id) {
    boolean textNecessary = false; // true if id is in streams
    if((id > 0) && (id <= streams.size()))
      textNecessary = true;
    calcSpacing();
    calcScale();
    drawAxis();
    ArrayList yvals = new ArrayList(); // holds the vertices of the previously drawn stream
    float x = 0;
    float y;
    Point p;
    // manually fills yvals with the top spline
    for(int i = 0; i < numPoints; i++)
      yvals.add((height / 2) - (((Float)heights.get(i) / 2) * scale));
    Stream temp;
    /* draws the streams by drawing over the previously drawn spline, then wrapping around
      and calculating the y offset of the bottom spline based on the Point values */
    for(int i = 0; i < numStreams; i++) {
      temp = (Stream)streams.get(i);
      x = 0;
      y = (Float)yvals.get(0);
      beginShape();
      if((i + 1) == highlighted) // if the mouse is over this stream
        fill(255, 0, 0);
      else
        temp.fillStream();
      curveVertex(x, y);
      // draws the top of the curve
      for(int j = 0; j < numPoints; j++) {
        x = j * spacing;
        y = (Float)yvals.get(j);
        curveVertex(x, y);
      }
      // draws the side of the curve
      curveVertex(x + spacing, y);
      p = (Point)temp.getPoints().get(numPoints - 1);
      curveVertex(x + spacing, y + scale * p.getValue());
      // draws the bottom of the curve using yvals and the Point values as offsets
      for(int j = numPoints - 1; j >= 0; j--) {
        x = j * spacing;
        p = (Point)temp.getPoints().get(j);
        y = (Float)yvals.get(j) + (scale * p.getValue());
        yvals.set(j, y); // these yvals will be used by the next stream
        curveVertex(x, y);
      }
      curveVertex(x, y);
      endShape();
    }
    if(textNecessary)
      drawCaption(id);
  }
  
  
  // writes the information for the current Stream and Point over the mouse
  void drawCaption(int id) {
    Stream s = (Stream)streams.get(id - 1);
    String name = s.getStreamName();
    int time = round(mouseX / spacing);
    Point p = (Point)s.getPoints().get(time % s.getPoints().size());
    if(mouseX > (width / 2))
      textAlign(RIGHT, BOTTOM);
    else
      textAlign(LEFT, BOTTOM);
    fill(0);
    text(name + ", " + p.getTitle() + ", " + p.getValue(), mouseX, mouseY);
  }
  
  
  //draws the backbuffer in the same way that the front image is drawn
  void renderBackBuffer(PGraphics pg) {
    calcSpacing();
    calcScale();
    ArrayList yvals = new ArrayList();
    float x = 0;
    float y;
    Point p;
    for(int i = 0; i < numPoints; i++)
      yvals.add((height / 2) - (((Float)heights.get(i) / 2) * scale));
      
    Stream temp;
    for(int i = 0; i < numStreams; i++) {
      temp = (Stream)streams.get(i);
      x = 0;
      y = (Float)yvals.get(0);
      pg.beginShape();
      pg.noStroke();
      pg.fill((int)red(i + 1), (int)green(i + 1), (int)blue(i + 1));
      pg.curveVertex(x, y);
      for(int j = 0; j < numPoints; j++) {
        x = j * spacing;
        y = (Float)yvals.get(j);
        pg.curveVertex(x, y);
      }
      pg.curveVertex(x + spacing, y);
      p = (Point)temp.getPoints().get(numPoints - 1);
      pg.curveVertex(x + spacing, y + scale * p.getValue());
      for(int j = numPoints - 1; j >= 0; j--) {
        x = j * spacing;
        p = (Point)temp.getPoints().get(j);
        y = (Float)yvals.get(j) + (scale * p.getValue());
        yvals.set(j, y);
        pg.curveVertex(x, y);
      }
      pg.curveVertex(x, y);
      pg.endShape();
    }
  }
  
  
  //draws the axis and labels on the bottom of the screen
  private void drawAxis() {
    line(0, .95 * height, width, .95 * height);
    float length = .02 * height;
    float x = 0;
    String caption;
    Stream s = (Stream)streams.get(0);
    ArrayList cur_points;
    Point p;
    float y = (.95 * height) - (length / 2);
    float ts = (width + height) * .01;
    for(int i = 0; i < numPoints; i++) {
      p = (Point)s.getPoints().get(i);
      caption = p.getTitle();
      line(x, y, x, y + length);
      fill(0);
      textSize(ts);
      if(i == 0)
        textAlign(LEFT, BOTTOM);
      else if(i == (numPoints - 1))
        textAlign(RIGHT, BOTTOM);
      else
        textAlign(CENTER, BOTTOM);
      text(caption, x, y);
      x += spacing;
      if(x > width)
        x = width - 1;
    }
  }
}
  
