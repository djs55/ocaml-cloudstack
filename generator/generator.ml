
let string_of_file filename =
  let ic = open_in filename in
  let output = Buffer.create 1024 in
  try
    while true do
      let block = String.make 4096 '\000' in
      let n = input ic block 0 (String.length block) in
      if n = 0 then raise End_of_file;
      Buffer.add_substring output block 0 n
    done;
    "" (* never happens *)
  with End_of_file ->
    close_in ic;
    Buffer.contents output

let _ =
  let json = ref "" in
  Arg.parse [
   "-json", Arg.Set_string json, "json-encoded response of listApis command"
  ] (fun x -> Printf.fprintf stderr "Ignoring argument: %s\n" x)
  "Generate OCaml CloudStack bindings from the CloudStack API introspection API";
  if !json = "" then begin
    Printf.fprintf stderr "Please supply a -json parameter\n";
    exit 1;
  end;
  let text = string_of_file !json in
  let t = ListApis_j.t_of_string text in
  Printf.fprintf stderr "OK\n"
