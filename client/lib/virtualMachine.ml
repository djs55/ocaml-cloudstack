open Common

let _command = "command"
let _apiKey = "apiKey"
let _signature = "signature"
let _response = "response"

let _account = "account"
let _affinitygroupid = "affinitygroupid"
let _details = "details"
let _domainid = "domainid"
let _forvirtualnetwork = "forvirtualnetwork"
let _groupid = "groupid"
let _hostid = "hostid"
let _hypervisor = "hypervisor"
let _id = "id"
let _isoid = "isoid"
let _isrecursive = "isrecursive"
let _keyword = "keyword"
let _listall = "listall"
let _name = "name"
let _networkid = "networkid"
let _page = "page"
let _pagesize = "pagesize"
let _podid = "podid"
let _projectid = "projectid"
let _state = "state"
let _storageid = "storageid"
let _tags = "tags"
let _templateid = "templateid"
let _vpcid = "vpcid"
let _zoneid = "zoneid"

module Args = struct
  type t = {
    account: string option;
    (* TODO: autogenerate lots of this *)
  }
  let pairs t =
    let account = match t.account with None -> [] | Some x -> [ _account, x ] in
    account
  let make account = { account }
end

let list_uri common args =
  let pairs = [
    _command, "listVirtualMachines";
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

