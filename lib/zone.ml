open Common

let _command = "command"
let _apiKey = "apiKey"
let _signature = "signature"
let _response = "response"

let list_uri common available =
  let pairs = [
    _command, "listZones";
    _apiKey, common.apikey;
(*    "available", string_of_bool available; *)
    _response, "json";
  ] in
  let signature = sign pairs common.secret in
  let pairs = pairs @ [ _signature, Uri.pct_encode signature ] in
  Uri.make ~scheme:"http" ~host:common.host
    ~path:Constants.uri_path ~port:Constants.port
    ~query:(List.map (fun (k, v) -> k, [v]) pairs)
    ()

