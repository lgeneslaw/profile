  /* constants that control the sizes of various display elements */
int max_players_displayable; // the max number of players on the screen at once
float string_width; // width on the screen available for player strings 
float row_height;   // height on the screen for player rows
float spacing;      // width on the screen between player rows
float title_height; // height at top of screen for Task title
float task_view_height; // height of the main task display
float mission_caption_height; // height of the mission numbers at the bottom of each column
float control_space_height;   // height of the control space at the bottom of the screen
float player_scroll_width;

int num_improves_displayed; //number of improvement selection categories
int num_tasks_displayed;
int first_task_displayed;

Parser parser;
PrePostParser diffparser;
int start_index;   // topmost player displayed
int end_index;     // bottommost player displayed
float lo_improve;
float hi_improve;
int improve_group_index;
ArrayList tasks;   // one entry per task page
String players[];  // maps array indeces to player names
float differences[]; //pre-post score differences, value is a %
int selected_task; // which task is currently displayed
int selected_mission;
int num_players;
Button task_buttons[];
Button task_prev;
Button task_next;
Button player_prev;
Button player_next;
Button improvement[];



void setup(){
  size(1100, 700);
  //frame.setResizable(true);
  setScreenDimensions();
  parser = new Parser("tasks.csv");
  diffparser = new PrePostParser("scoredifference.csv");
  differences = diffparser.get_differences();
  tasks = parser.getTasks();
  players = parser.getPlayers();
  num_players = parser.getNumPlayers();
  start_index = 0;
  if(num_players < max_players_displayable)
    end_index = num_players - 1;
  else
    end_index = start_index + max_players_displayable;
  selected_task = 0;
  selected_mission = 0;
  task_buttons = new Button[tasks.size()];
  for(int i = 0; i < task_buttons.length; i++){
    task_buttons[i] = new Button(((Task)tasks.get(i)).get_name());
  }
  num_improves_displayed = 4;
  improve_group_index = -1;
  num_tasks_displayed = 4; //temporary. displaying four task buttons at bottom
  first_task_displayed = selected_task;
  task_prev = new Button("<");
  task_next = new Button(">");
  player_prev = new Button("^");
  player_next = new Button("v");
  improvement = new Button[num_improves_displayed];
  improvement[0] = new Button("51+");
  improvement[1] = new Button("50 - 26");
  improvement[2] = new Button("25 - 1");
  improvement[3] = new Button("Did not improve");
  Task first = (Task)tasks.get(0);
  first.set_click_state();
  task_buttons[selected_task].set_click_state(true);
}

void setScreenDimensions() {
  title_height = .05 * height;
  control_space_height = .15 * height;
  mission_caption_height = title_height;
  task_view_height = height - title_height - mission_caption_height - control_space_height;
  string_width = .1 * width;
  row_height = 15;
  spacing = .3 * row_height;
  max_players_displayable = (int)(task_view_height / (row_height + spacing));
  if(max_players_displayable > num_players)
    max_players_displayable = num_players;
  player_scroll_width = .07 * width;
}


void update_indeces() {
  if((num_players - start_index) < max_players_displayable)
    end_index = num_players - 1;
  else
    end_index = start_index + max_players_displayable;
}


void draw(){
  background(255);
  setScreenDimensions();
  update_indeces();
  Task t = (Task)tasks.get(selected_task);
  textAlign(CENTER, CENTER);
  textSize(.8 * title_height);
  fill(0);
  text(t.get_name(), 0, 0, width, title_height);  
  for(int i = start_index; i < end_index; i++) {
    drawPlayer(find_player_with_rank(t, i + 1));
  line(0, height - control_space_height * .6, width, height - control_space_height * .6);
  fill(0);
  textSize((control_space_height + width) * .02);
  textAlign(CENTER, BOTTOM);
  text("Tasks", width * .28, height - control_space_height * .6);
  text("Improvement Percentiles", width * .76, height - control_space_height * .6);
  }
  draw_task_buttons();
  draw_improve_buttons();
  draw_mission_buttons();
  draw_player_scroll_buttons();
  drawColorKey();
}

void draw_mission_buttons(){
  Task curr_task = (Task)tasks.get(selected_task);
  curr_task.draw_buttons(); 
}

void draw_improve_buttons(){
   float y = height - (control_space_height * .5);
   float b_width = (width / 2 / num_improves_displayed) * .75;
   float button_spacing = (b_width / .75) * .125;
   float x = button_spacing + (width / 2) * 12/11;
   line(x - button_spacing * 1.2, height - (control_space_height * .6), x - button_spacing * 1.2, height);
   float b_height = control_space_height / 2.5;
   
   for(int i = 0; i < num_improves_displayed; i++){
     improvement[i].update_button(x, y, b_width, b_height);
     x = x + button_spacing + b_width;
     improvement[i].draw_button(-1);
   }
   
}

void draw_task_buttons(){
  float y = height - (control_space_height * .5);
  float b_width = (width / 2 / num_tasks_displayed) * .75;
  float button_spacing = (b_width / .75) * .125;
  float x = button_spacing;
  float b_height = control_space_height / 2.5;
  
  float ib_width = b_width * .25;
  
  task_prev.update_button(x, y, ib_width, b_height);
  if(first_task_displayed != 0)
    task_prev.draw_button(-1);
  else
    task_prev.draw_button_inactive();
  stroke(0);
  x = x + button_spacing + ib_width;
  
  for(int i = 0; i < task_buttons.length; i++){
    task_buttons[i].update_button(0, 0, 0, 0);
  }
  
  for(int i = first_task_displayed; i < (first_task_displayed + num_tasks_displayed); i++){
    task_buttons[i].update_button(x, y, b_width, b_height);
    x = x + button_spacing + b_width;
    task_buttons[i].draw_button(-1);
  }
  
  task_next.update_button(x, y, ib_width, b_height);
  if(first_task_displayed + num_tasks_displayed != tasks.size())
    task_next.draw_button(-1);
  else{
    fill(230);
    stroke(200);
    rect(x, y, ib_width, b_height);
    textSize((ib_width + b_height) * .4);
    fill(150);
    text(">", x, y, ib_width, b_height);   
  }
  stroke(0);
}


void drawColorKey() {
  final float COLOR_DIFF = (255 * 2) / num_players;
  float center_x = width - (player_scroll_width / 2);
  float box_width = player_scroll_width * .4;
  float box_height = .3 * height;
  float y = title_height + 20;
  fill(0);
  textSize((width + height) * .008);
  textAlign(CENTER, CENTER);
  text("high %ile", width - player_scroll_width / 2, title_height + 3);
  float small_height = box_height / num_players;
  for(int i = 0; i < num_players; i++) {
    float c = i * COLOR_DIFF;
    if(c < 255) {
      fill(255, 50 + (c * 100) / 255, c);
      stroke(255, 50 + (c * 100) / 255, c);
    }
    else {
      c = c % 255;
      fill((255 - c), 150, 255);
      stroke((255 - c), 150, 255);
    }
    rect(center_x - (box_width/2), y, box_width, small_height);
    y += small_height;
  }
  fill(0);
  text("low %ile", width - player_scroll_width / 2, y + 15);
}
    


void draw_player_scroll_buttons() {
  float b_width = .6 * player_scroll_width;
  float b_height = .07 * height;
  float pos_y = (height - title_height - control_space_height) * .7;
  float center_x = width - (player_scroll_width / 2);
  float x = center_x - (b_width / 2);
  float y = pos_y - (1.5 * b_height);
  
  player_prev.update_button(x, y, b_width, b_height);
  if(start_index != 0)
    player_prev.draw_button(-1);
  else
    player_prev.draw_button_inactive();
    
  y = pos_y + (b_height);
  player_next.update_button(x, y, b_width, b_height);
  if(end_index != num_players)
    player_next.draw_button(-1);
  else
    player_next.draw_button_inactive();
}

int find_player_with_rank(Task t, int rank) {
  for(int i = 0; i < num_players; i++) {
    if(t.get_rank(i, selected_mission) == rank)
      return i;
  }
  return -1;
}
  
  

void drawPlayer(int player) {
  Task t = (Task)tasks.get(selected_task);
  int bg;
  float x_pos = 0;
  int player_pos = t.get_rank(player, selected_mission) - 1 - start_index;
  float y_pos = title_height + (player_pos * row_height) + (player_pos * spacing);
  fill(0);
  int diff = int(differences[player]);
  textSize(row_height * .7);
  stroke(0);
  text(players[player], x_pos, y_pos, string_width, row_height);
  int num_missions = t.get_num_objectives();
  float box_width = (width - string_width - player_scroll_width - 5) / num_missions;
  x_pos += (string_width + 5);
  final float COLOR_DIFF = (255 * 2) / num_players;
 
 
  for(int i = 0; i < num_missions; i++) {
    float c = t.get_rank(player, i) * COLOR_DIFF;
    if(improve_group_index == -1 || (improve_group_index != -1 && diff >= lo_improve && diff <= hi_improve)){
      if(c < 255) {
        fill(255, 50 + (c * 100) / 255, c);
      }
      else {
        c = c % 255;
        fill((255 - c), 150, 255);
      }
    }
    else{
     fill(200, 200, 200);
    }
    
    
    
    rect(x_pos + (i * box_width), y_pos, box_width, row_height);
  }
  strokeWeight(1);
}



void mouseMoved(){
  
  for(int i = 0; i < tasks.size(); i++){
    Task t = (Task)tasks.get(i);
    t.check_button_intersections();
  }
  
  for(int i = 0; i < task_buttons.length; i++){
    task_buttons[i].check_intersection();
  }
  task_prev.check_intersection();
  task_next.check_intersection();
  player_prev.check_intersection();
  player_next.check_intersection();
  for(int i = 0; i < improvement.length; i++){
    improvement[i].check_intersection();
  }
}

void mouseClicked(){
  
  for(int i = 0; i < task_buttons.length; i++){
    if(task_buttons[i].clicked_on()){
      selected_task = i;
      selected_mission = 0;
      Task selected = (Task)tasks.get(i);
      selected.set_click_state();
    }
  }
  
  Task curr = (Task)tasks.get(selected_task);
  int temp = curr.check_clicked_buttons();
  if(temp != -1)
    selected_mission = temp;
  curr.set_click_state();
  
  
  task_buttons[selected_task].set_click_state(true);
  
  
  if(task_prev.check_intersection()){
    if(first_task_displayed != 0){
      first_task_displayed--;
    }
  }
  if(task_next.check_intersection()){
    if(first_task_displayed + num_tasks_displayed != tasks.size()){
      first_task_displayed++;
    }
  }
  
  if(player_prev.check_intersection()){
    if(start_index != 0){
      start_index--;
      end_index--;
    }
  }
  
  if(player_next.check_intersection()){
    if(end_index != num_players){
      start_index++;
      end_index++;
    }
  }
  
  for(int i = 0; i < improvement.length; i++){
    if(improvement[i].clicked_on()){
      if(improve_group_index == i){
        improvement[i].set_click_state(false);
        improve_group_index = -1;
      }
      else{
        improve_group_index = i;
        if(i == 0) {
           lo_improve = 51;
           hi_improve = 1000;
        }
        else if(i == 1){
          lo_improve = 26;
          hi_improve = 50;
        }
        else if(i == 2){
          lo_improve = 1;
          hi_improve = 25;
        }
        else{
          lo_improve = -1000;
          hi_improve = 0;
        }
      }
    }
  }
  if(improve_group_index != -1)
    improvement[improve_group_index].set_click_state(true);
}
