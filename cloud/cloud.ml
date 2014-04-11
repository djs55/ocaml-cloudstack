open Lwt
open Cmdliner

let project_url = "https://github.com/djs55/ocaml-cloudstack"

(* Help sections common to all commands *)

let _common_options = "COMMON OPTIONS"
let help = [ 
 `S _common_options; 
 `P "These options are common to all commands.";
 `S "MORE HELP";
 `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command."; `Noblank;
 `S "BUGS"; `P (Printf.sprintf "Check bug reports at %s" project_url);
]

(* Options common to all commands *)
let common_options_t = 
  let host =
    let doc = "The hostname or address of the Cloudstack API endpoint" in
    Arg.(value & opt string "127.0.0.1" & info [ "host" ] ~docv:"HOST" ~doc) in
  let apikey =
    let doc = "The CloudStack API key" in
    Arg.(value & opt string "" & info [ "api-key" ] ~docv:"APIKEY" ~doc) in
  let secret =
    let doc = "The CloudStack secret" in
    Arg.(value & opt string "" & info [ "secret" ] ~docv:"SECRET" ~doc) in
  Term.(pure Cloudstack.Common.make $ host $ apikey $ secret)

let listZones common available =
  let uri = Cloudstack.Zone.list_uri common available in
  let t =
    Cloudstack.Http.get uri >>= fun response ->
    Printf.fprintf stdout "%s" response;
    return (`Ok ()) in
  try Lwt_main.run t with e -> exit 1

let listZones_cmd =
  let doc = "List zones" in
  let man = [
    `S "DESCRIPTION";
    `P "A zone is the second largest organisational unit within a CloudStack cloud. A zone typically corresponds to a single datacenter, although it is permissible to have multiple zones in a datacenter.";
  ] in

  let available =
    let doc = "true if you want to retrieve all available Zones. False if you only want to return the Zones from which you have at least one VM. Default is false." in
    Arg.(value & opt bool false & info [ "available" ] ~docv:"AVAILABLE" ~doc) in
  Term.(ret(pure listZones $ common_options_t $ available)),
  Term.info "listZones" ~sdocs:_common_options ~doc ~man

let default_cmd = 
  let doc = "CloudStack API client" in 
  let man = help in
  Term.(ret (pure (fun _ -> `Help (`Pager, None)) $ common_options_t)),
  Term.info "cloud" ~version:"1.0.0" ~sdocs:_common_options ~doc ~man

let cmds = [ listZones_cmd ]

let () = match Term.eval_choice default_cmd cmds with
  | `Ok () -> exit 0
  | _ -> exit 1

