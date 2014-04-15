open Lwt
open Cmdliner

let project_url = "https://github.com/djs55/ocaml-cloudstack"
(*
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
    Cloudstack_lwt_unix.get uri >>= fun response ->
    Printf.fprintf stdout "%s\n" response;
    return (`Ok ()) in
  try Lwt_main.run t with e -> exit 1

let listHypervisors common zoneid =
  let uri = Cloudstack.Hypervisor.list_uri common ?zoneid () in
  let t =
    Cloudstack_lwt_unix.get uri >>= fun response ->
    Printf.fprintf stdout "%s\n" response;
    return (`Ok ()) in
  try Lwt_main.run t with e -> exit 1

let listVirtualMachines common args =
  let uri = Cloudstack.VirtualMachine.list_uri common args in
  let t =
    Cloudstack_lwt_unix.get uri >>= fun response ->
    Printf.fprintf stdout "%s\n" response;
    return (`Ok ()) in
  try Lwt_main.run t with e -> exit 1

let listApis common args =
  let uri = Cloudstack.Api.list_uri common args in
  let t =
    Cloudstack_lwt_unix.get uri >>= fun response ->
    Printf.fprintf stdout "%s\n" response;
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

let listHypervisors_cmd =
  let doc = "List hypervisors" in
  let man = [
    `S "DESCRIPTION";
    `P "Lists all the hypervisors either globally (the default) or in the specified zone.";
  ] in
  let zoneid =
    let doc = "only list hypervisors in the specified zone" in
    Arg.(value & opt (some string) None & info [ "zoneid" ] ~docv:"ZONEID" ~doc) in
  Term.(ret(pure listHypervisors $ common_options_t $ zoneid)),
  Term.info "listHypervisors" ~sdocs:_common_options ~doc ~man

let listVirtualMachines_cmd =
  let doc = "List Virtual Machines" in
  let man = [
    `S "DESCRIPTION";
    `P "Lists all the Virtual Machines.";
  ] in
  let account =
    let doc = "list resources by account. Must be used with the domainId parameter" in
    Arg.(value & opt (some string) None & info [ "account" ] ~docv:"ACCOUNT" ~doc) in
  let args = Term.(pure Cloudstack.VirtualMachine.Args.make $ account) in
  Term.(ret(pure listVirtualMachines $ common_options_t $ args)),
  Term.info "listVirtualMachines" ~sdocs:_common_options ~doc ~man

let listApis_cmd =
  let doc = "lists all Apis" in
  let man = [
    `S "DESCRIPTION";
    `P "lists all available apis on the server, provided by the Api Discovery plugin";
  ] in
  let apiname =
    let doc = "API name" in
    Arg.(value & opt (some string) None & info [ "name" ] ~docv:"NAME" ~doc) in
  let args = Term.(pure Cloudstack.Api.Args.make $ apiname) in
  Term.(ret(pure listApis $ common_options_t $ args)),
  Term.info "listApis" ~sdocs:_common_options ~doc ~man

let default_cmd = 
  let doc = "CloudStack API client" in 
  let man = help in
  Term.(ret (pure (fun _ -> `Help (`Pager, None)) $ common_options_t)),
  Term.info "cloud" ~version:"1.0.0" ~sdocs:_common_options ~doc ~man

let cmds = [ listZones_cmd; listHypervisors_cmd; listVirtualMachines_cmd; listApis_cmd ]
*)
let () = match Term.eval_choice default_cmd Cmdliner_commands.all with
  | `Ok () -> exit 0
  | _ -> exit 1

