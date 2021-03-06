class UsersController < ApplicationController
    skip_before_action :authorized, only: [:index, :show, :create, :update]

    def index
        users = User.all
        render json: { users: users }, status: :accepted
    end

    def show
        user = User.find_by(id: params[:id])
        render json: { user: UserSerializer.new(user) }, status: :accepted
    end

    def create
        user = User.create(user_params)
        
        if user.valid?
            token = encode_token({ user_id: user.id })
            render json: { user: UserSerializer.new(user), jwt: token }, status: :created
        else
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def update
        user = User.find_by( id: params[:id] )
        
        if user
            user.update(update_params)
            render json: { user: UserSerializer.new(user) }, status: :accepted
        else
            render json: { error: 'user not found' }, status: :not_acceptable
        end
    end


    private

    def user_params
        params.require(:user).permit( :name, :username, :password )
    end

    def update_params
        params.require(:user).permit( :name, :username )
    end

end
