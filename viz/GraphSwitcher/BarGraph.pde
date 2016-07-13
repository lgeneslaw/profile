public class BarGraph extends Graph {
  ArrayList data;
  
  public BarGraph(ArrayList bars) {
    super();
    numElems = bars.size();
    if(numElems == 0) return;
    data = bars;
    setMinMaxY();
    setTop();
  }
  
  public void setMinMaxY() {
    DataElement cur = (DataElement) data.get(0);
    minY = cur.getDataValue();
    maxY = minY;
    float temp;

    for(int i = 1; i < numElems; i++) {
      cur = (DataElement) data.get(i);
      temp = cur.getDataValue();
      if(temp < minY)
        minY = temp;
      if(temp > maxY)
        maxY = temp;
    }
    minY -= (.05 * minY);
  }

  protected void drawData() {
    Bar b1, b2;
    float x, y;
    x = originX;
    float spacing = (float)(boxX + width_g - originX) / (float)(numElems + 1);
    float half_length = .01 * height_g;
    b2 = (Bar)data.get(0);
    x += spacing;
    y = ((1.0 - ((b2.getDataValue() - minY) / (maxY - minY))) * (originY - top)) + top;
    b2.setPosX(x);
    b2.setPosY(y);
    b2.setBarWidth(spacing / 4);
    b2.setBarHeight(originY - y);
    b2.drawDataElement();
    
    //draws a bar, then calls drawCaption on that Bar
    for(int i = 1; i < numElems; i++) {
      b1 = b2;
      b2 = (Bar)data.get(i);
      x += spacing;
      y = ((1.0 - ((b2.getDataValue() - minY) / (maxY - minY))) * (originY - top)) + top;
      b2.setPosX(x);
      b2.setPosY(y);
      b2.setBarWidth(spacing / 4);
      b2.setBarHeight(originY - y);
      b2.drawDataElement();
      drawCaption(originX + (spacing * i), originY, b1.getDataName(), spacing);
    }
    
    drawCaption(originX + (spacing * numElems), originY, b2.getDataName(), spacing);
  }
  

}
