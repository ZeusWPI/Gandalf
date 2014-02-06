# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
#
Isengard::Application.config.secret_key_base = 'a27fcd9aa2eabd14030493d6b5a1521ba09c9d23a1dd90b3c9d6914b8d226d1df8b46af3005f73a29c3ef1acd86de3669fbe08605d9ce8da73856c734f8a0e36'
Isengard::Application.config.fk_auth_url = 'http://fkgent.be/api_isengard_v2.php'
Isengard::Application.config.fk_auth_salt = '#development#'
Isengard::Application.config.fk_auth_key = '#development#'
Isengard::Application.config.enrollment_key = '#development#'
