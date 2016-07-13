class Parser{
  int num_players;
  String player_names[];
  String objective_names[];
  ArrayList columns; //just used to figure out tasks
  ArrayList tasks;
  //Task tasks[];
  
  public Parser(String filename){
   String buffer[];
   String lines[] = loadStrings(filename);
   num_players = lines.length - 1;
   player_names = new String[num_players];
   buffer = split(lines[0], ',');
   
   //loop starts at 1 to skip "player"
   int curr_objective_number;
   int name_start_index;
   String task_name;
   columns = new ArrayList();
   for (int i = 1; i < buffer.length; i++) {
     name_start_index = buffer[i].indexOf(' ') + 1;
     //finds index of the first space, then adds 1
     //to it to get the start of the Task name.
     curr_objective_number = int(buffer[i].substring(0, name_start_index - 1));
     task_name = buffer[i].substring(name_start_index);
     columns.add(new Column(task_name, curr_objective_number, num_players));
   }
   
   for(int i = 1; i < lines.length; i++){
     buffer = split(lines[i], ',');
     player_names[i - 1] = buffer[0];
     for(int j = 0; j < columns.size(); j++){ //starts at 1 because of first col in dataset of player names
       Column curr_col = (Column)columns.get(j); // 
       curr_col.add_move(int(buffer[j + 1]), i - 1); //i - 1 corresponds to the player
     
     }
   }
   
   //This block of code should create Tasks and fill them 
   //with all of the correct columns
   tasks = new ArrayList();
   for(int i = 0; i < columns.size(); i++){
     Column curr_col = (Column)columns.get(i);
     task_name = curr_col.get_task_name();
     if(tasks.size() == 0) {
       tasks.add(new Task(curr_col, num_players));
     }
     else{
       boolean found = false;
       for(int j = 0; j < tasks.size(); j++){
         Task curr_task = (Task)tasks.get(j);
         if(task_name.equals(curr_task.get_name())){
           curr_task.add_col(curr_col);
           found = true;  
         }
       }
       if(found == false){    
         tasks.add(new Task(curr_col, num_players));
       }
     }
   }
   
   for(int i = 0; i < tasks.size(); i++) {
     Task curr_task = (Task)tasks.get(i);
     curr_task.finish_initialization();  
   }
  }

  public ArrayList getTasks() {
    return tasks;
  }
  
  public String[] getPlayers() {
    return player_names;
  }
  
  public int getNumPlayers() {
    return num_players;
  }
}
    

