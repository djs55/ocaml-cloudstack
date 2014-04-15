open Common

let _command = "command"
let _apiKey = "apiKey"
let _signature = "signature"
let _response = "response"
let _zoneid = "zoneid"

let list_uri common ?(zoneid) () =
  let pairs = [
    _command, "listHypervisors";
    _apiKey, common.apikey;
    _response, "json";
  ] in
  let pairs = pairs @ (match zoneid with None -> [] | Some id -> [ _zoneid, id ]) in
  let signature = sign pairs common.secret in
  let pairs = pairs @ [ _signature, Uri.pct_encode signature ] in
  Uri.make ~scheme:"http" ~host:common.host
    ~path:Constants.uri_path ~port:Constants.port
    ~query:(List.map (fun (k, v) -> k, [v]) pairs)
    ()

