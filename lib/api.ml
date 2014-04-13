open Common

let _command = "command"
let _apiKey = "apiKey"
let _signature = "signature"
let _response = "response"
let _zoneid = "zoneid"

module Args = struct
  type t = { name: string option }
  let pairs t =
    let name = match t.name with None -> [] | Some n -> [ "name", n ] in
    name
  let make name = { name }
end

let list_uri common args =
  let pairs = [
    _command, "listApis";
    _apiKey, common.apikey;
    _response, "json";
  ] in
  let pairs = pairs @ (Args.pairs args) in
  let signature = sign pairs common.secret in
  let pairs = pairs @ [ _signature, Uri.pct_encode signature ] in
  Uri.make ~scheme:"http" ~host:common.host
    ~path:Constants.uri_path ~port:Constants.port
    ~query:(List.map (fun (k, v) -> k, [v]) pairs)
    ()

