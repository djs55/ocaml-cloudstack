
type t = {
  host: string;
  apikey: string;
  secret: string;
}

let make host apikey secret = { host; apikey; secret }

let sign pairs secret =
  let hash = Cryptokit.MAC.hmac_sha1 secret in
  let s =
    pairs
    |> List.map (fun (k, v) -> String.lowercase k, String.lowercase (Uri.pct_encode v))
    |> List.sort (fun a b -> compare (fst a) (fst b))
    |> List.map (fun (k, v) -> k ^ "=" ^ v)
    |> String.concat "&" in
  hash#add_string s;
  Cohttp.Base64.encode (hash#result)

let _command = "command"
let _apiKey = "apiKey"
let _signature = "signature"
let _response = "response"
let _zoneid = "zoneid"

let uri common command args =
  let pairs = [
    _command, command;
    _apiKey, common.apikey;
    _response, "json";
  ] @ args in
  let signature = sign pairs common.secret in
  let pairs = pairs @ [ _signature, Uri.pct_encode signature ] in
  Uri.make ~scheme:"http" ~host:common.host
           ~path:Constants.uri_path ~port:Constants.port
           ~query:(List.map (fun (k, v) -> k, [v]) pairs)
           ()

module Date = struct
  type t = string
  let to_string x = x
end
module Uuid = struct
  type t = string
  let to_string x = x
  let of_string x = Some x
end
module Tzdate = struct
  type t = string
  let to_string x = x
end
