/*reads data from a file called "data.csv" and stores
  that data in an ArrayList of Points and another
  ArrayList of Bars */

class Parser {
  int numVals;
  ArrayList<Point> points;
  ArrayList<Bar> bars;
  String xLabel, yLabel;
  
  public Parser(String filename) {
    points = new ArrayList<Point>();
    bars = new ArrayList<Bar>();
    /*String lines[] = loadStrings(filename);
    numVals = lines.length - 1;
    //vals = new String[numVals][2];
    String temp[] = split(lines[0], ',');
    xLabel = temp[0];
    yLabel = temp[1];
    int y;
    for (int i = 1; i < lines.length; i++) {
      temp = split(lines[i], ',');
      y = Integer.parseInt(temp[1]);
      points.add(new Point(temp[0], y));
      bars.add(new Bar(temp[0], y));
    } */
  }
  
  public ArrayList<Point> getPoints () {
    points.add("January", 18);
    points.add("February", 22);
    points.add("March", 34);
    points.add("April", 54);
    points.add("May", 62);
    points.add("June", 73);
    points.add("July", 81);
    points.add("August", 79);
    points.add("September", 65);
    points.add("October", 43);
    points.add("November", 39);
    points.add("December", 30);
    return points;
  }
  
  public ArrayList<Bar> getBars() {
    bars.add("January", 18);
    bars.add("February", 22);
    bars.add("March", 34);
    bars.add("April", 54);
    bars.add("May", 62);
    bars.add("June", 73);
    bars.add("July", 81);
    bars.add("August", 79);
    bars.add("September", 65);
    bars.add("October", 43);
    bars.add("November", 39);
    bars.add("December", 30);

    return bars;
  }
  
  public String getXLabel() {
    return "Month";
    //return xLabel;
  }
  
  public String getYLabel() {
    return "Average Temperature";
    //return yLabel;
  }
}
