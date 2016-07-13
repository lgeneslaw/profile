boolean state = true;
MyBox green;
MyBox blue;

void setup() {
  size(400, 400);
  green = new MyBox(width/2 - 150/2, height/2 - 50/2, 150, 50, "state true");
  green.setFillColor(0, 255, 0);
  blue = new MyBox(width/2 - 75/2, height/2 - 25/2, 75, 25, "state false");
  blue.setFillColor(0, 0, 255);
}

void draw() {
  background(255);
  MyBox box;
  if(state)
    box = green;
  else
    box = blue;
  box.drawMyBox();
}

void mouseClicked() {
  boolean boxClicked = true;
  MyBox box;
  if(state)
    box = green;
  else
    box = blue;
  if((mouseX < box.getX()) || (mouseX > box.getX() + box.getWidth()))
    boxClicked = false;
  if((mouseY < box.getY()) || (mouseY > box.getY() + box.getLength()))
    boxClicked =  false;
  if(boxClicked) 
    state = !state;
}
   
