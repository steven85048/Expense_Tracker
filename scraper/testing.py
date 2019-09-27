import datetime
import plaid
import json

def pretty_print_response(response):
  print(json.dumps(response, indent=2, sort_keys=True))

# Fill in your Plaid API keys - https://dashboard.plaid.com/account/keys
PLAID_CLIENT_ID = ''
PLAID_SECRET = ''
PLAID_PUBLIC_KEY = ''
# Use 'sandbox' to test with Plaid's Sandbox environment (username: user_good,
# password: pass_good)
# Use `development` to test with live users and credentials and `production`
# to go live
PLAID_ENV = 'development'
# PLAID_PRODUCTS is a comma-separated list of products to use when initializing
# Link. Note that this list must contain 'assets' in order for the app to be
# able to create and retrieve asset reports.
PLAID_PRODUCTS = 'transactions'

# PLAID_COUNTRY_CODES is a comma-separated list of countries for which users
# will be able to select institutions from.
PLAID_COUNTRY_CODES = 'US,CA,GB,FR,ES'

item_id = ''
access_token = ''

client = plaid.Client(client_id = PLAID_CLIENT_ID, secret = PLAID_SECRET,
                      public_key = PLAID_PUBLIC_KEY, environment = PLAID_ENV, api_version = '2019-05-29')

start_date = '{:%Y-%m-%d}'.format(datetime.datetime.now() + datetime.timedelta(-30))
end_date = '{:%Y-%m-%d}'.format(datetime.datetime.now())

try:
    identity_response = client.Transactions.get(access_token, start_date, end_date)
    pretty_print_response(identity_response)
except plaid.errors.PlaidError as e:
    print(e)

