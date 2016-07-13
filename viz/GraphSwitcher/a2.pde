GraphSwitcher gs;

void setup() {
  size(800, 600);
  gs = new GraphSwitcher();
  //frame.setResizable(true);
}

void draw() {
  background(175);
  gs.drawGraphSwitcher();
}

void mouseClicked() {
  gs.HandleGraphSwitcherClickEvent();
}
