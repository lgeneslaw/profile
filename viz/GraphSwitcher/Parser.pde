/*reads data from a file called "data.csv" and stores
  that data in an ArrayList of Points and another
  ArrayList of Bars */

class Parser {
  int numVals;
  ArrayList points;
  ArrayList bars;
  String xLabel, yLabel;
  
  public Parser(String filename) {
    points = new ArrayList();
    bars = new ArrayList();
    String lines[] = loadStrings(filename);
    numVals = lines.length - 1;
    //vals = new String[numVals][2];
    String temp[] = split(lines[0], ',');
    xLabel = temp[0];
    yLabel = temp[1];
    int y;
    for (int i = 1; i < lines.length; i++) {
      temp = split(lines[i], ',');
      y = int(temp[1]);
      points.add(new Point(temp[0], y));
      bars.add(new Bar(temp[0], y));
    }
  }
  
  public ArrayList getPoints () {
    //points.add(new Point("January", 25));
    //points.add(new Point("February", 30));
    return points;
  }
  
  public ArrayList getBars() {
    //bars.add(new Bar("January", 25));
    //bars.add(new Bar("February", 30));
    return bars;
  }
  
  public String getXLabel() {
    return xLabel;
  }
  
  public String getYLabel() {
    return yLabel;
  }
}
