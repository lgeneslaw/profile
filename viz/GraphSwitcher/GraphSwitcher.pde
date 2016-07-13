/*This class switches between a line and bar graph when
  the button is clicked */
public class GraphSwitcher {
  private Graph curr_graph;
  private LineGraph lg;
  private BarGraph bg;
  private MyButton b;
  private Parser p;
  
  /*creates a parser to readin data and initializes the graphs */
  public GraphSwitcher() {
    p = new Parser("data.csv");
    lg = new LineGraph(p.getPoints());
    bg = new BarGraph(p.getBars());
    lg.setXLabel(p.getXLabel());
    lg.setYLabel(p.getYLabel());
    bg.setXLabel(p.getXLabel());
    bg.setYLabel(p.getYLabel());
    curr_graph = lg;
    b = new MyButton();
  }
  
  //main draw routine
  public void drawGraphSwitcher() {
    drawButton();
    curr_graph.drawGraph();
  }
  
  private void drawButton() {
    if(curr_graph == lg)
      b.setButton(curr_graph.getGraphWidth(), 0, width - curr_graph.getGraphWidth(), ((height - curr_graph.getGraphHeight()) / 2) - 1, "Bar Graph");
    else
      b.setButton(curr_graph.getGraphWidth(), 0, width - curr_graph.getGraphWidth(), ((height - curr_graph.getGraphHeight()) / 2) - 1, "Line Graph");
    b.drawMyButton();
  }
  
  public void HandleGraphSwitcherClickEvent() {
    if(b.mouseIsOverButton())
      switchGraph();
  }
  
  //changes the current graph
  private void switchGraph() {
    if(curr_graph == lg)
      curr_graph = bg;
    else
      curr_graph = lg;  
  }
}


