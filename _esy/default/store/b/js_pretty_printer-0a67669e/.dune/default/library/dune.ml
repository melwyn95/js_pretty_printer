module Jbuild_plugin : sig
(** API for jbuild plugins *)

(* CR-someday amokhov: rename to [dune_plugin]. *)

module V1 : sig
  (** Current build context *)
  val context : string

  (** OCaml version for the current build context. It might not be the same as
      [Sys.ocaml_version] *)
  val ocaml_version : string

  (** Output of [ocamlc -config] for this context *)
  val ocamlc_config : (string * string) list

  (** [send s] send [s] to Dune. [s] should be the contents of a [dune] file
      following the specification described in the manual. *)
  val send : string -> unit

  (** Execute a command and read its output *)
  val run_and_read_lines : string -> string list
end

end = struct
let () =
  Hashtbl.add Toploop.directive_table "require"
    (Toploop.Directive_string ignore);
  Hashtbl.add Toploop.directive_table "use"
    (Toploop.Directive_string
       (fun _ ->
         failwith "#use is not allowed inside a dune file in OCaml syntax"));
  Hashtbl.add Toploop.directive_table "use_mod"
    (Toploop.Directive_string
       (fun _ ->
         failwith "#use is not allowed inside a dune file in OCaml syntax"))

module V1 = struct
  let context = "default"
        let ocaml_version = "4.06.1"
        let send_target = "/Users/melwyns/oss/js_pretty_printer/_esy/default/store/b/js_pretty_printer-0a67669e/.dune/default/library/dune"
        let ocamlc_config = [ "version"                   , "4.06.1"
      ; "standard_library_default"  , "/Users/melwyns/.esy/3_________________________________________________________________/i/ocaml-4.6.1003-080693f6/lib/ocaml"
      ; "standard_library"          , "/Users/melwyns/.esy/3_________________________________________________________________/i/ocaml-4.6.1003-080693f6/lib/ocaml"
      ; "standard_runtime"          , "/Users/melwyns/.esy/3_________________________________________________________________/i/ocaml-4.6.1003-080693f6/bin/ocamlrun"
      ; "ccomp_type"                , "cc"
      ; "c_compiler"                , "gcc"
      ; "ocamlc_cflags"             , "-O2 -fno-strict-aliasing -fwrapv"
      ; "ocamlc_cppflags"           , "-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
      ; "ocamlopt_cflags"           , "-O2 -fno-strict-aliasing -fwrapv"
      ; "ocamlopt_cppflags"         , "-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
      ; "bytecomp_c_compiler"       , "gcc -O2 -fno-strict-aliasing -fwrapv -D_FILE_OFFSET_BITS=64 -D_REENTRANT"
      ; "bytecomp_c_libraries"      , "-lcurses -lpthread"
      ; "native_c_compiler"         , "gcc -O2 -fno-strict-aliasing -fwrapv -D_FILE_OFFSET_BITS=64 -D_REENTRANT"
      ; "native_c_libraries"        , ""
      ; "cc_profile"                , "-pg"
      ; "architecture"              , "amd64"
      ; "model"                     , "default"
      ; "int_size"                  , "63"
      ; "word_size"                 , "64"
      ; "system"                    , "macosx"
      ; "asm"                       , "clang -arch x86_64 -Wno-trigraphs -c"
      ; "asm_cfi_supported"         , "false"
      ; "with_frame_pointers"       , "false"
      ; "ext_exe"                   , ""
      ; "ext_obj"                   , ".o"
      ; "ext_asm"                   , ".s"
      ; "ext_lib"                   , ".a"
      ; "ext_dll"                   , ".so"
      ; "os_type"                   , "Unix"
      ; "default_executable_name"   , "a.out"
      ; "systhread_supported"       , "true"
      ; "host"                      , "x86_64-apple-darwin20.2.0"
      ; "target"                    , "x86_64-apple-darwin20.2.0"
      ; "profiling"                 , "true"
      ; "flambda"                   , "false"
      ; "spacetime"                 , "false"
      ; "safe_string"               , "false"
      ; "exec_magic_number"         , "Caml1999X011"
      ; "cmi_magic_number"          , "Caml1999I022"
      ; "cmo_magic_number"          , "Caml1999O022"
      ; "cma_magic_number"          , "Caml1999A022"
      ; "cmx_magic_number"          , "Caml1999Y022"
      ; "cmxa_magic_number"         , "Caml1999Z022"
      ; "ast_impl_magic_number"     , "Caml1999M022"
      ; "ast_intf_magic_number"     , "Caml1999N022"
      ; "cmxs_magic_number"         , "Caml1999D022"
      ; "cmt_magic_number"          , "Caml1999T022"
      ; "natdynlink_supported"      , "true"
      ; "supports_shared_libraries" , "true"
      ; "windows_unicode"           , "false" ]
        

  let send s =
    let oc = open_out_bin send_target in
    output_string oc s;
    close_out oc

  let run_and_read_lines cmd =
    let tmp_fname = Filename.temp_file "dune" ".output" in
    at_exit (fun () -> Sys.remove tmp_fname);
    let n =
      Printf.ksprintf Sys.command "%s > %s" cmd (Filename.quote tmp_fname)
    in
    let rec loop ic acc =
      match input_line ic with
      | exception End_of_file ->
        close_in ic;
        List.rev acc
      | line -> loop ic (line :: acc)
    in
    let output = loop (open_in tmp_fname) [] in
    if n = 0 then
      output
    else
      Printf.ksprintf failwith
        "Command failed: %%s\nExit code: %%d\nOutput:\n%%s" cmd n
        (String.concat "\n" output)
end

end
# 1 "library/dune"
(* -*- tuareg -*- *)

open Jbuild_plugin.V1

let () =
  run_and_read_lines ("pesy dune-file " ^ Sys.getcwd ())
  |> String.concat "\n"
  |> send
