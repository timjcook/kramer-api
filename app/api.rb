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
        { "user" => { :id => user.id, :first_name => user.first_name, :last_name => user.last_name } }
      else
        status 400
      end
    end

    get 'all' do
      users = User.all
      users.map{|user| {:id => user.id, :first_name => user.first_name, :last_name => user.last_name} }
    end 

  end

  resource :item do
    post 'new' do
      item = Item.new
      service = ItemService.new(item).update(json_params.require(:item).permit(:name))
      
      Rails.logger.info "params #{json_params[:item]}"

      if service.save
        status 201
        { "item created" => "name=#{item.name}" }
      else
        status 400
      end
    end

    get 'all' do
      items = Item.all
      items.map{|item| {:name => item.name} }
    end
  end

  resource :friend do
    post 'add' do
      Rails.logger.info "params #{json_params}"
      sending_user = User.find_by! id: (json_params[:friend][:sending_user])
      accepting_user = User.find_by! id: (json_params[:friend][:accepting_user])

      service = FriendService.new
      if service.request_friendship(sending_user, accepting_user)
        status 201
        { "friendship added" => "#{sending_user.name} and #{accepting_user.name} are now friends." }
      else
        status 400
      end
    end
  end

end
