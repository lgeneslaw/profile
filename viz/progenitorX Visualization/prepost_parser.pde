class PrePostParser {
  float differences[];
  
  public PrePostParser(String filename) {
    String buffer[];
    String lines[] = loadStrings(filename);
    int num_players = lines.length - 1;
    differences = new float[num_players];
    for(int i = 0; i < num_players; i++){
      buffer = split(lines[i + 1], ',');
      differences[i] = float(buffer[1]);
    }
  }
  
  public float[] get_differences(){
    return differences;
  }
}
    
