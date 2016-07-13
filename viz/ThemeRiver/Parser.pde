class Parser {
  int numVals;
  ArrayList streams;
  
  // reads data from [filename] into streams
  public Parser(String filename) {
    streams = new ArrayList();
    String lines[] = loadStrings(filename);
    numVals = lines.length - 1;
    String titles[] = split(lines[0], ','); // Point titles
    String temp[];
    String name; // stream name
    int length = titles.length;
    ArrayList points;  
    for (int i = 1; i < lines.length; i++) {
      temp = split(lines[i], ',');
      points = new ArrayList();
      name = temp[0];
      for(int j = 1; j < length; j++)
        points.add(new Point(titles[j], float(temp[j])));
      streams.add(new Stream(name, points, i));
    }
  }
  
  public ArrayList getStreams() {
    return streams;
  }
}
