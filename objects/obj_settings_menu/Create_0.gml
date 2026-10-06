
width = 200;
height = 104;
op_border = 8;
op_space = 16;

//general settings...
option[0, 0] = "Language Lessons";
option[0, 1] = "Difficulty";


//language settings menu
option[1, 0] = "Add/Remove Language";
option[1, 1] = "Select current lesson";
option[1, 2] = "Back";

//add lang sub menu
option[2, 0] = "Python";
option[2, 1] = "C";
option[2, 2] = "Java";
option[2, 3] = "Back";



//Language options
option_selected[1, 0] = true;
option_selected[1, 1] = false;
option_selected[1, 2] = false;
option_selected[1, 3] = false;


//Difficulty section
option[4, 0] = "Easy";
option[4, 1] = "Medium";
option[4, 2] = "Hard";
option[4, 3] = "Back";



global.current_lesson_language = "None";


current_difficulty = "Easy";

op_length = 0;

menu_level = 0;

pos = 0;

