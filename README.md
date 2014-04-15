Pure OCaml CloudStack API client
================================

This is a work-in-progress. Currently it can invoke synchronous CloudStack API calls
based on the API of a post-4.4 master transport.

Try the following commands:
```
$ ./client/cloud.native listVirtualMachines --api-key=$API --secret=$SECRET
{ "listvirtualmachinesresponse" : { } }
```

```
$ ./client/cloud.native deployVirtualMachine --help
```
