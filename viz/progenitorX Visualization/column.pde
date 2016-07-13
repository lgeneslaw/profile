class Column{
  String task_name;
  int objective_number;
  int array_size;
  int num_actions[]; //correspond to player moves
  
  Column(String _task_name, int _obj_num, int _size){
    task_name = _task_name;
    objective_number = _obj_num;
    array_size = _size;
    num_actions = new int[array_size];
  }
  
  String get_task_name(){
    return task_name;
  }
  
  int get_objective_number(){
    return objective_number;
  }
  
  int get_action(int index){
    return num_actions[index];
  }
  
  void add_move(int num_moves, int index){
    num_actions[index] = num_moves;
  }
  

}
