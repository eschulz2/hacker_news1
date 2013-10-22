get '/' do
  # Look in app/views/index.erb
  @posts = Post.all
  if request.xhr?
    erb :_all_posts, layout: false
  else
    erb :index
  end
end

get '/create_post' do
  erb :create_post, layout: !request.xhr?
end

get '/user/:user_id' do
  @user = User.find(params[:user_id])
  erb :profile
end

get '/user/:user_id/posts' do
  @user = User.find(params[:user_id])
  erb :user_posts
end

get '/user/:user_id/comments' do
  @user = User.find(params[:user_id])
  erb :user_comments
end

get "/post/comments/:post_id" do
  @post = Post.find(params[:post_id])
  erb :post_comments
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
end


post '/create_user' do
  User.create(params[:user])
  redirect to '/'
end

post '/login' do
  found_user = User.find_by_name(params[:name])
  
  if found_user
    @current_user = User.authenticate(params[:name], params[:password])
  end

  if @current_user
    session[:user_id] = @current_user.id
    redirect to '/'
  else
    redirect to '/'
  end
end

post '/created_post' do
  if session[:user_id]
    @post = Post.create(params[:post])
    @user = User.find(session[:user_id])
    @user.posts << @post

    if request.xhr?
      erb :_single_post, layout: false, locals: {post: @post}
    else
      redirect to '/'
    end
  else
    redirect to '/'
  end
end
