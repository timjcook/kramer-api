require 'grape'

class API < Grape::API

  version 'v1', using: :header, vendor: 'twitter'
  format :json

  get :test do
    { :test => :test, :other => :other }
  end

end
