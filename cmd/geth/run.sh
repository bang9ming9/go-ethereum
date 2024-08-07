rm -rf ${DATA_DIR}
mkdir -p ${DATA_DIR}

go run . --datadir=${DATA_DIR} init ${CONFIG_DIR}/genesis.json

go run .\
 --datadir "${DATA_DIR}"\
 --identity "local-el"\
 --verbosity 5\
 --http --http.addr "0.0.0.0" --http.corsdomain "*" --http.api "debug,eth,net,txpool,web3"\
 --ws --ws.addr "0.0.0.0" --ws.origins "*" --ws.api "debug,eth,net,txpool,web3"\
 --authrpc.addr "0.0.0.0" --authrpc.vhosts "*" --authrpc.jwtsecret "${CONFIG_DIR}/jwtsecret"\
 --nodekey "${CONFIG_DIR}/nodekey"\
 --metrics\
 --nat none\
 --syncmode full\
 --state.scheme path\
 --allow-insecure-unlock\
 --unlock "${ADDRESS}"\
 --password "${CONFIG_DIR}/password.txt"\
 --nodiscover\
 --keystore "/Users/wm-bd000036/workspace/go-workspace/bang9ming/geth-env/keystore"