open ListApis_t
open Utils

let _ =
  let json = ref "" in
  Arg.parse [
   "-json", Arg.Set_string json, "json-encoded response of listApis command";
   "-generated", Arg.Set_string output, Printf.sprintf "output directory for generated code (default: %s)" !output;
  ] (fun x -> Printf.fprintf stderr "Ignoring argument: %s\n" x)
  "Generate OCaml CloudStack bindings from the CloudStack API introspection API";
  if !json = "" then begin
    Printf.fprintf stderr "Please supply a -json parameter\n";
    exit 1;
  end;
  let text = string_of_file !json in
  let t = ListApis_j.t_of_string text in
  (* TODO: consider grouping the APIs the same way they appear in the online
   * docs *)
  (* Generate API bindings *)
  Gen_library.apis_ml t;
  Gen_library.apis_mli t;
  Gen_cmdliner.apis_ml t
