open Lwt
open Cmdliner

open Common_options

let default_cmd = 
  let doc = "CloudStack API client" in 
  let man = help in
  Term.(ret (pure (fun _ -> `Help (`Pager, None)) $ common_options_t)),
  Term.info "cloud" ~version:"1.0.0" ~sdocs:_common_options ~doc ~man

let () = match Term.eval_choice default_cmd Cmdliner_commands.all with
  | `Ok () -> exit 0
  | _ -> exit 1

