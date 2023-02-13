from solcx import compile_standard, install_solc
import json
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

install_solc("0.6.0")

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# Compile Our Solidity

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# when we deploy it to a chain we need the bytecode and the abi

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]


# for connecting to ganache
"""
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:8545"))
chain_id = 1337
my_address = "0xEa16b7cD895A5bC6EE81e940955E7542ECA2ef78"

# load private key from .env file

private_key = os.getenv("PRIVATE_KEY")
"""

# Connecting to Goerli
w3 = Web3(
    Web3.HTTPProvider("https://goerli.infura.io/v3/e5ec4f11886e4214a399606115580637")
)
chain_id = 5
my_address = "0x4477AB95ce2727e4a18bc7F48c50d321Cd3a828A"

# load private key from .env file

private_key = os.getenv("PRIVATE_KEY")


# Create the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get the latestes transaction
nonce = w3.eth.get_transaction_count(my_address)


# Build a transaction
transaction = SimpleStorage.constructor().build_transaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }
)
# Sign a transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# Send a transaction
print("Deploying contract.....")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Deployed!!")
# Working with the contract
# Contract Address
# Contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

# Call -> Simulate making the call and getting a return value ( calls don't make a state change )
# Transact -> Actually make a state change

# Initial value of favorite number
print(simple_storage.functions.retrieve().call())
print("Updating contract.....")
store_transaction = simple_storage.functions.store(86).build_transaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)

signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_recepit = w3.eth.wait_for_transaction_receipt(send_store_tx)
print("Updated!")
print(simple_storage.functions.retrieve().call())
