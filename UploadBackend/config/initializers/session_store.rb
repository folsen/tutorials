# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fileupload_session',
  :secret      => '7b9811da722b2a966add4cc6d48858e2a599cf5fbab22f08958f91ddd2f4f58839ccad15b755e60a23796f93877548837f5e53ce75f2b654f55e28b9ebe3d8fc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
