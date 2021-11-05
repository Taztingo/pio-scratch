#!/bin/bash
PROVENANCE_DEV_DIR=~/code/provenance
WASM_BIN_DIR=~/code/pio-scratch/wasms
COMMON_TX_FLAGS="--gas auto --gas-prices 1905nhash --gas-adjustment 2 --chain-id testing --keyring-backend test --yes -o json"

######################################### SETUP FOR ATS CONTRACT EXECUTION ##############################################

export VALIDATOR_ID=$(${PROVENANCE_DEV_DIR}/build/provenanced keys show -a validator --home ${PROVENANCE_DEV_DIR}/build/run/provenanced -t)
export BUYER=$(${PROVENANCE_DEV_DIR}/build/provenanced keys show -a buyer --home ${PROVENANCE_DEV_DIR}/build/run/provenanced -t)
export SELLER=$(${PROVENANCE_DEV_DIR}/build/provenanced keys show -a seller --home ${PROVENANCE_DEV_DIR}/build/run/provenanced -t)

# Wasm Contract Storing and Initializing 

echo "Storing ${WASM_BIN_DIR}/ats_smart_contract.wasm"
${PROVENANCE_DEV_DIR}/build/provenanced -t --home ${PROVENANCE_DEV_DIR}/build/run/provenanced \
    tx wasm store ${WASM_BIN_DIR}/ats_smart_contract.wasm  \
    --from validator \
    ${COMMON_TX_FLAGS} | jq

echo "Initiating wasm contract id 1"
${PROVENANCE_DEV_DIR}/build/provenanced -t --home ${PROVENANCE_DEV_DIR}/build/run/provenanced \
    tx wasm instantiate 1 \
    '{"name":"ats-ex", "bind_name":"ats-ex.pb", "base_denom":"gme.local", "convertible_base_denoms":[], "supported_quote_denoms":["usd.local"], "approvers":[], "executors":["'${VALIDATOR_ID}'"], "ask_required_attributes":[], "bid_required_attributes":[], "price_precision": "0", "size_increment": "1"}' \
    --admin ${VALIDATOR_ID} \
    --label ats-ex \
    --from validator \
    ${COMMON_TX_FLAGS} | jq

