open FlowParser;
let hello = () => "hello";

let parse = () => program(~fail=false, "var x = 1;") |> Console.log;

/*

Usage of pretty_printer:

let space_regex = Str.regexp_string " "

let newline_regex = Str.regexp_string "\n"

let assert_output ~ctxt ?msg ?(pretty = false) expected_str layout =
  let print =
    if pretty then
      Pretty_printer.print ~source_maps:None ~skip_endline:false
    else
      Compact_printer.print ~source_maps:None
  in
  let out = print layout |> Source.contents in
  let out = String.sub out 0 (String.length out - 1) in
  (* remove trailing \n *)
  let printer x =
    x
    |> Str.global_replace space_regex "\xE2\x90\xA3" (* open box *)
    |> Str.global_replace newline_regex "\xC2\xAC\n"
    (* not sign, what Atom uses *)
  in
  assert_equal ~ctxt ?msg ~printer expected_str out


*/