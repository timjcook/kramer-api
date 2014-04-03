require 'grape'

class API < Grape::API

  version 'v1', using: :header, vendor: 'kramer'
  content_type :json, "application/json"
  format :json

  helpers do
    def json_params
      request.body.rewind
      json_params = ActionController::Parameters.new(ActiveSupport::JSON.decode(request.body))
    end
  end

  resource :user do
    post 'new' do
      user = User.new
      Rails.logger.info "params #{json_params}"
      service = UserService.new(user).update(json_params.require(:user).permit(:first_name, :last_name, :email))
      
      Rails.logger.info "params #{json_params[:user][:first_name]}"
      Rails.logger.info "params #{json_params[:user][:last_name]}"
      Rails.logger.info "params #{json_params[:user][:email]}"

      if service.save
        status 201
        { "user created" => "first_name=#{user.first_name} last_name=#{user.last_name} email=#{user.email}" }
      else
        status 400
      end
    end
  end

  resource :item do
    post 'new' do
      item = Item.new
      service = ItemService.new(item).update(json_params.require(:item).permit(:name))
      
      Rails.logger.info "params #{json_params[:item]}"

      if service.save
        status 201
        { "user created" => nil }
      else
        status 400
      end
    end
  end

end
