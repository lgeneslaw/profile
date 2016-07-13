/* The DataElement class sets a template for different ways to represent graph data.
  This class holds the name and value of an element, but its subclasses must 
  know how to draw the data */

public abstract class DataElement {
  protected float value;
  protected String name;
  protected float posX, posY;  //position on the graph
  
  public DataElement(String n, float val) {
    name = n;
    value = val;
  }
  
  public void setPosX(float x) {
    posX = x;
  }
  
  public float getPosX() {
    return posX;
  }
  
  public void setPosY(float y) {
    posY = y;
  }
  
  public float getPosY() {
    return posY;
  }
  
  public String getDataName() {
    return name;
  }
  
  public float getDataValue() {
    return value;
  }
  
  public abstract void drawDataElement();
}
