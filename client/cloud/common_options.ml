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
  Term.(pure Common.make $ host $ apikey $ secret)

