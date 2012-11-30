# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_crc_session',
  :secret      => 'bc87fa9c5ca32af6dedf07de0e14f334547cd43a207338ecf18698e07e65d651dd91822450aae83f5cad41f9ba304a6baba14b834550db64bc41977e06925b74'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
