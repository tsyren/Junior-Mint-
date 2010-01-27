ActionController::Routing::Routes.draw do |map|
  map.resources :stores

  map.namespace "admin" do |admin|
      admin.resources :jobs
  end
    
  map.root  :controller => 'users'
  map.home '/', :controller => 'users', :action => 'index'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect '/users/blog/:id.:format',:controller => 'users', :action => 'blog'
  map.connect 'posts/archive/:year/:month', :controller => 'posts', :action => 'archive'
  map.connect '/messages/new/:id', :controller => 'messages', :action => 'new', :method => :get
  
  map.resources :datafile
  map.resources :users
  map.resources :users, :member => { :suspend => :put, :unsuspend => :put,:purge => :delete }
  map.resources :events
  map.resources :posts
  map.resources :projects
  map.resources :feeders
  map.resources :invites
  map.resources :communities
  
  map.list_communities 'communities/list/', :controller => 'communities', :action => 'list'
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate',:activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.about '/about', :controller => 'sessions', :action => 'about'
  map.mypage '/mypage',:controller => 'users', :action => 'mypage'
  map.myfriends 'myfriends', :controller => 'friends', :action => 'index'
  map.myprofile '/myprofile', :controller => 'users', :action => 'profile'
  #map.profile '/profile/:id.:format', :controller => 'users', :action => 'profile'
  
  map.mynotes '/mynotes',:controller => 'users', :action => 'blog'
  map.myblogcom '/myblogcom',:controller => 'users', :action => 'blogcom'
  map.community 'communities/show/:id', :controller => 'communities', :action => 'show'
  map.mycommunities '/mycommunities', :controller => 'users', :action => 'mycommunities' 
  map.bookmarks '/bookmarks', :controller => 'bookmarks', :action => 'list' 
  map.monthly_archive 'blogs/archive/:month', :controller => 'posts', :action => 'monthly_index'
  map.dude 'dude/:id',  :controller => 'users', :action => 'dude' 
  map.faq  'faq', :controller => 'bookmarks', :action => 'faq' 
  map.messages '/messages/inbox', :controller => 'messages', :action => 'index'
  map.newletters '/newletters', :controller => 'messages', :action => 'view_new'
  map.edit 'edit/:type',  :controller => 'users', :action => 'edit' 
  map.forgot_password '/forgot_password', :controller => 'users',  :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'
  map.update 'update', :controller => 'users', :action => 'update'
  map.allcom 'allcom', :controller => 'communities', :action => 'list'
  map.feedback 'feedback', :controller => 'users',:action => 'feedback'
  map.help 'help', :controller => 'sessions',:action => 'help'
  map.rules 'rules', :controller => 'sessions',:action => 'rules'
  map.connect '/mypage/:page', :controller => "users", :action=>"mypage"
  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  
  map.foaf 'myprofile/:id.:format', :controller => "users", :action => "profile"
  

  
end
