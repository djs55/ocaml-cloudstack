
let convert_uuid : Common.Uuid.t Cmdliner.Arg.converter =
  let parse_uuid x = match Common.Uuid.of_string x with Some x -> `Ok x | None -> `Error "Failed to parse UUID" in
  let print_uuid fmt x = Format.pp_print_string fmt (Common.Uuid.to_string x) in
  parse_uuid, print_uuid

let convert_list : string list Cmdliner.Arg.converter =
  let parse_list x = failwith "parse_list" in
  let print_list fmt x = Format.pp_print_string fmt (Printf.sprintf "[ %s ]"
  (String.concat ", " x)) in
  parse_list, print_list

let convert_map : (string * string) list Cmdliner.Arg.converter =
  let parse_map x = failwith "parse_map" in
  let print_map fmt x = Format.pp_print_string fmt (Printf.sprintf "[ %s ]"
  (String.concat ", " (List.map (fun (k, v) -> k ^ " = " ^ v) x))) in
  parse_map, print_map
