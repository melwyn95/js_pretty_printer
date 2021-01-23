open FlowParser;
let hello = () => "hello";

let parse = () => program(~fail=false, "var x = 1;") |> Console.log;
