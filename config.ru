# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-ebay-oauth'

EBAY_APP_ID  = ENV['EBAY_APP_ID']
EBAY_CERT_ID = ENV['EBAY_CERT_ID']
RUNAME = ENV['EBAY_RUNAME']
SCOPE = 'https://api.ebay.com/oauth/api_scope'

class App < Sinatra::Base # :nodoc:
  get '/' do
    <<-HTML
    <html>
    <head>
      <title>Ebay Oauth2</title>
    </head>
    <body>
      <form action="/auth/ebay" method="get">
      <button type="submit">Authorize via Ebay</button>
      </form>
    </body>
    </html>
    HTML
  end

  get '/auth/:provider/callback' do
    <<-HTML
    <html>
    <head>
      <title>Ebay Oauth2</title>
    </head>
    <body>
      <h3>Authorized</h3>
      <p>Token: #{request.env['omniauth.auth']['credentials']['token']}</p>
    </body>
    </html>
    HTML
  end

  get '/auth/failure' do
    <<-HTML
    <html>
    <head>
      <title>Ebay Oauth2</title>
    </head>
    <body>
      <h3>Failed Authorization</h3>
      <p>Message: #{params[:message]}</p>
    </body>
    </html>
    HTML
  end
end

use Rack::Session::Cookie, secret: SecureRandom.hex(64)

use OmniAuth::Builder do
  provider :ebay,
           ENV['EBAY_APP_ID'],
           ENV['EBAY_CERT_ID'],
           redirect_uri: ENV['EBAY_RUNAME'],
           sandbox: true
end

run App.new
