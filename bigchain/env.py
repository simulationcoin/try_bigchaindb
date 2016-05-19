from bigchaindb import crypto
from bigchaindb import Bigchain

b = Bigchain()


# lib

def sign_and_write(tx, private_key):
  tx_signed = b.sign_transaction(tx, private_key)
  b.write_transaction(tx_signed)
  return tx_signed


# commands (CLI api)

def keys():
  return b.me_private, b.me

def keys_new():
  return crypto.generate_key_pair()

def assets_new(private_key, asset_owner_pub_key):
  asset_payload = {'msg': 'Arbitrary data as asset description'}
  tx = b.create_transaction(private_key, asset_owner_pub_key, None, 'CREATE', payload=asset_payload)
  tx_signed = sign_and_write(tx, b.me_private)

  time.sleep(8) # bigchaindb takes a couple of seconds to confirm a transaction
  tx_retrieved = b.get_transaction(tx_signed['id'])
  return tx_retrieved

def assets_new_admin():
  priv, pub = keys()
  tx_retrieved = assets_new(priv, pub)
  return tx_retrieved
