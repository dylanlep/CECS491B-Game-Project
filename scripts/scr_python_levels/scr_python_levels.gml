/// scr_python_levels()
/// All World 1 levels. One struct per level.
///   mode   : "reorder" = drag every block into its slot, in order
///            "fill"    = code is shown with blanks, drag blocks into the blanks
///   lines  : each line is a list of parts. "@" is a blank, anything else is fixed text
///   answer : the expected text for each blank, in order across all lines
///   blocks : every block the player gets (include wrong ones for fill levels)

function scr_python_levels() {
    return [
        {
            title:  "SAY HELLO",
            hint:   "print shows text on screen. Text goes in quotes.",
            mode:   "reorder",
            lines:  [ ["@", "@", "@", "@"] ],
            answer: [ "print", "(", "\"Hello, world!\"", ")" ],
            blocks: [ "print", "(", "\"Hello, world!\"", ")" ]
        },
        {
            title:  "NAME A VALUE",
            hint:   "A variable names a value. print(name) shows the value.",
            mode:   "fill",
            lines:  [ ["@", " = ", "\"Ada\""],
                      ["print(", "@", ")"] ],
            answer: [ "name", "name" ],
            blocks: [ "name", "name", "Name", "\"name\"" ]
        }
    ];
}