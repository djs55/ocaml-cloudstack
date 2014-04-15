open ListApis_t
open Utils

let dedup_assoc xs =
  let rec loop names acc = function
  | [] -> List.rev acc
  | x :: xs ->
    loop (x.name :: names) (if List.mem x.name names then acc else x :: acc) xs in
  loop [] [] xs

let _library = "library"
let _cmdliner = "cmdliner"

let _ =
  let json = ref "" in
  let mode = ref _library in
  Arg.parse [
   "-json", Arg.Set_string json, "json-encoded response of listApis command";
   "-generated", Arg.Set_string output, Printf.sprintf "output directory for generated code (default: %s)" !output;
   "-mode", Arg.Symbol ([ _library; _cmdliner ], (fun x -> mode := x)), "choose whether to output the library code or the cmdliner terms";
  ] (fun x -> Printf.fprintf stderr "Ignoring argument: %s\n" x)
  "Generate OCaml CloudStack bindings from the CloudStack API introspection API";
  if !json = "" then begin
    Printf.fprintf stderr "Please supply a -json parameter\n";
    exit 1;
  end;
  let text = string_of_file !json in
  let t = ListApis_j.t_of_string text in

  (* ListVolumes has duplicate 'storageid' parameter *)
  let t =
    let api = List.map
      (fun api ->
         let params = dedup_assoc api.params in
         { api with params }
      ) t.listapisresponse.api in
    { listapisresponse = { t.listapisresponse with api }} in

  (* TODO: consider grouping the APIs the same way they appear in the online
   * docs *)
  (* Generate API bindings *)
  if !mode = _library then begin
    Gen_library.apis_ml t;
    Gen_library.apis_mli t;
  end else begin
    Gen_cmdliner.apis_ml t
  end
