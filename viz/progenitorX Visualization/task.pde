class Task{
 int clicked_button;
 int num_columns;
 int num_players;
 boolean on_task;
 int selected; //integer of selected mission 
 int scores[][];
 int ranks[][]; //First index corresponds to player
                //Second index corresponds to mission
 ArrayList columns;
 String name;
 Button mission_buttons[];
 
 public Task(Column col, int _num_players){
   name = col.get_task_name();
   columns = new ArrayList();
   columns.add(col);
   num_columns = 1;
   num_players = _num_players;
 }
 
 public int get_objective_num(int index){
   Column col = (Column)columns.get(index);
   return col.get_objective_number();
 }
 
 public boolean determine_onoff(){
   return name.substring(1,2) == "n";
 }
 
 public void set_score(int player, int mission, int score){
  scores[player][mission] = score; 
 }
 
 public int get_score(int player, int mission){
   return scores[player][mission];
 }
 
 public int get_num_objectives(){
   return num_columns;
 }
 
 public int get_num_players(){
   return num_players;
 }
 
 public int get_rank(int player, int mission) {
   return ranks[player][mission];
 }
 
 public String get_name(){
   return name; 
 }
 
 public void add_col(Column col){
   columns.add(col);
   num_columns++;
 }
 
 
 public void finish_initialization(){
   scores = new int[num_players][num_columns];
   ranks = new int[num_players][num_columns];
   //figure out what to do with ranks later
   for(int i = 0; i < num_players; i++){
     for(int j = 0; j < num_columns; j++){
       Column curr_col = (Column)columns.get(j);
       scores[i][j] = curr_col.get_action(i);
       ranks[i][j] = 0;
     }
   }
   mission_buttons = new Button[num_columns];
   for(int i = 0; i < mission_buttons.length; i++){
     Column col = (Column)columns.get(i);
     mission_buttons[i] = new Button("Objective " + col.get_objective_number());
   }
   sort_missions();
 }
 
 private void sort_missions() {
   Column c;
   int next_highest = -1;
   int current_rank;
   for(int i = 0; i < num_columns; i++) {
     current_rank = 1;
     next_highest = -1;
     next_highest = find_max(i);
     ranks[next_highest][i] = current_rank;
     for(int j = 1; j < num_players; j++) {
       current_rank++;
       next_highest = find_next_highest(i);
       ranks[next_highest][i] = current_rank;
     }
   }
 }
 
 private int find_max(int column_index) {
   int temp_high = 0;
   int num = 0;
   int high_index = -1;
   for(int i = 0; i < num_players; i++) {
     num = scores[i][column_index];
     if(num > temp_high) {
        high_index = i;
       temp_high = num;
     }
   }
   
   return high_index;
 }
 
 private int find_next_highest(int column_index) {
   int temp_high = 0;
   int num = 0;
   int high_index = -1;
   for(int i = 0; i < num_players; i++) {
     num = scores[i][column_index];
     if((ranks[i][column_index] == 0) && (num >= temp_high)) {
       high_index = i;
       temp_high = num;
     }
   }
   
   return high_index;
 }
 
 public void print_scores(){
   println(name);
   for(int i = 0; i < num_players; i++){
     for(int j = 0; j < num_columns; j++){
       print(scores[i][j]);
       print(' ');
     }
     println(' ');
   }
 }
 
 public void print_ranks() {
   println(name);
   for(int i = 0; i < num_players; i++){
     for(int j = 0; j < num_columns; j++){
       print("id" + (i + 2) + ": " + ranks[i][j]);
       print(' ');
     }
     println(' ');
   }
 }
 
 public void check_button_intersections(){
   for(int i = 0; i < mission_buttons.length; i++){
     mission_buttons[i].check_intersection();
   }
 }
 
 public int check_clicked_buttons(){
  clicked_button = -1;
  for(int i = 0; i < mission_buttons.length; i++){
     if(mission_buttons[i].clicked_on()){
       clicked_button = i;
     }
  }
  return clicked_button;
 }
 
 public void set_click_state(){
  if(selected_mission != -1){
   mission_buttons[selected_mission].set_click_state(true);
  }
 }
  
 public void draw_buttons(){
   float b_height = mission_caption_height;
   float b_width = (width / 2 / columns.size()) * .75;
   float y = title_height + task_view_height;
   float box_width = (width - string_width - player_scroll_width - 5) / columns.size();
   float x = string_width + 5 + (.25 * box_width);
   float button_spacing = box_width;
   for(int i = 0; i < mission_buttons.length; i++){
    mission_buttons[i].update_button(x, y, b_width, b_height);
    if(mission_buttons.length == 1)
      mission_buttons[i].draw_button(.04);
    else
      mission_buttons[i].draw_button(-1);
    x += button_spacing;
   }  
  }
      
}
