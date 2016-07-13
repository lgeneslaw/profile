public class LineGraph extends Graph {
  ArrayList data;
  
  public LineGraph(ArrayList points) {
    super();
    numElems = points.size();
    if(numElems == 0) return;
    data = points;
    setMinMaxY();
    setTop();
  }
  
  public void setMinMaxY() {
    DataElement cur = (DataElement)data.get(0);
    minY = cur.getDataValue();
    maxY = minY;
    float temp;

    for(int i = 1; i < numElems; i++) {
      cur = (DataElement)data.get(i);
      temp = cur.getDataValue();
      if(temp < minY)
        minY = temp;
      if(temp > maxY)
        maxY = temp;
    }
    minY -= (.05 * minY); // makes it so that all points are above the x axis
  }

  protected void drawData() {
    Point p1, p2;
    float x, y;
    x = originX;
    float spacing = (float)(boxX + width_g - originX) / (float)(numElems + 1);
    float half_length = .01 * height_g;
    p2 = (Point)data.get(0);
    x += spacing;
    y = ((1.0 - ((p2.getDataValue() - minY) / (maxY - minY))) * (originY - top)) + top;
    p2.setPosX(x);
    p2.setPosY(y);
    p2.drawDataElement();
    
    /*draws a point, then a line connecting it to the previous point,
    then the point's name */
    for(int i = 1; i < numElems; i++) {
      p1 = p2;
      p2 = (Point)data.get(i);
      x += spacing;
      y = ((1.0 - ((p2.getDataValue() - minY) / (maxY - minY))) * (originY - top)) + top;
      p2.setPosX(x);
      p2.setPosY(y);
      p2.drawDataElement();
      line(originX + (spacing * i), originY, originX + (spacing * i), originY - half_length);
      line(p1.getPosX(), p1.getPosY(), p2.getPosX(), p2.getPosY());
      drawCaption(originX + (spacing * i), originY, p1.getDataName(), spacing);
    }
    
    line(originX + (spacing * numElems), originY, originX + (spacing * numElems), originY - half_length);
    drawCaption(originX + (spacing * numElems), originY, p2.getDataName(), spacing);
  }
  

}
