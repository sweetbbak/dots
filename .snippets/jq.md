## jq - json parser

# convert `key=value` lines into `{"key":"value"}` json
$ jq --raw-input 'split("=") | {(.[0]):.[1]}' some.conf | jq --slurp 'add'
