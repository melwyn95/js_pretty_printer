Console.log("\n");
Console.log(Library.Util.pretty_print("  var     x     =     1 ;
    do {
        console.log('done')
    } while(false)

"));

let getLinesFromFile = path => {
    let ic = open_in(path);
  
    let rec aux = (ic, lines) =>
      try(input_line(ic) |> (x => List.cons(x, lines) |> aux(ic))) {
      | End_of_file =>
        close_in(ic);
        lines;
      };
  
    let lines = aux(ic, []) |> List.rev;

    String.concat("\n", lines)
};

let jsCodeFromFile = getLinesFromFile("./bin/un_formatted_code.js");

let pretty_printer = Library.Util.pretty_print;

Console.log("\n");
Console.log(pretty_printer(jsCodeFromFile));
