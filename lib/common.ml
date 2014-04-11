
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

