class Button{
 String name;
 float x_coord;
 float y_coord;
 float b_width;
 float b_height;
 boolean intersected;
 boolean clicked;
 
 public Button(String _name){
  name = _name;
  intersected = false;
  clicked = false;
 } 
 
 public void update_button(float x, float y, float _width, float _height){
   x_coord = x;
   y_coord = y;
   b_width = _width;
   b_height = _height;
 }
  
 public boolean check_intersection(){
  intersected = (mouseX >= x_coord && mouseX <= (x_coord + b_width) &&
     mouseY >= y_coord && mouseY <= (y_coord + b_height));
  return intersected;
 }
 
 public boolean clicked_on(){
   clicked = (mouseX >= x_coord && mouseX <= (x_coord + b_width) &&
     mouseY >= y_coord && mouseY <= (y_coord + b_height));
  return clicked;
 }
 
 public void draw_button(float size){
   stroke(0);
   if(intersected || clicked){
     fill(204, 255, 255);
   }
   else{
     fill(0, 150, 255);
   }
   rect(x_coord, y_coord, b_width, b_height);
   fill(0);
   if(name == ">" || name == "<" || name == "^" || name == "v") {
     textSize((b_width + b_height) * .3);
   }
   else{
     textSize((b_width + b_height) * .06);
     if(size != -1){
       textSize((b_width + b_height) * size);
     }
   }
   textAlign(CENTER, CENTER);
   text(name, x_coord, y_coord, b_width, b_height);
 }
  
  public void draw_button_inactive() {
    fill(230);
    stroke(200);
    rect(x_coord, y_coord, b_width, b_height);
    textSize((b_width + b_height) * .3);
    fill(150);
    textAlign(CENTER, CENTER);
    text(name, x_coord, y_coord, b_width, b_height);  
  }
  
  public void set_click_state(boolean state){
    clicked = state;
  }
}
