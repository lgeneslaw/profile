// holds Points. To be drawn by the River class with color r, g, b
public class Stream {
  private String name;
  private ArrayList points;
  private int numPoints;
  int r, g, b; // color
  int id; // unique id for each stream
  
  public Stream(String n, ArrayList p, int inID) {
    points = p;
    numPoints = p.size();
    name = n;
    id = inID;
    r = 0;
    g = 0;
    b = 0;
  }
  
  public int getNumPoints() {
    return numPoints;
  }
 
  public String getStreamName() {
    return name;
  }
  
  public ArrayList getPoints() {
    return points;
  }
  
  public void setFillColor(int numStreams) {
    g = int((255 / numStreams) * id);
    b = int((255 / numStreams) * (numStreams - id));
    r = int(random(0, (255 / numStreams)) * id);
  }
  
  public void fillStream() {
    fill(r, g, b);
  }
}
