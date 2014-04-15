
module IO = Cohttp_lwt_unix_io
module Net = Cohttp_lwt_unix_net
module Request = Cohttp_lwt.Make_request(IO)
module Response = Cohttp_lwt.Make_response(IO)
module Client = Cohttp_lwt.Make_client(IO)(Request)(Response)(Net)

open Lwt

let get uri =
  Client.get uri >>= fun (response, body) ->
  Cohttp_lwt_body.to_string body

