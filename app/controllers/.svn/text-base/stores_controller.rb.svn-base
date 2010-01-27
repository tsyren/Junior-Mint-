class StoresController < ApplicationController
  include ApplicationHelper
  before_filter :login_required
  layout 'users'
  # GET /stores
  # GET /stores.xml
  def index
    @stores = Store.find :all, :conditions => {:user_id => current_user}
    @tags = Store.tag_counts
    if params[:view] == "public"
    @stores = Store.find :all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stores }
    end
  end
  
  # view tags  within params
  #
  # access: public
  # 
  def tag
     @stores = Store.find_tagged_with(params[:id])
     #all tags
     @tags = Store.tag_counts
  end

  # GET /stores/1
  # GET /stores/1.xml
  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store }
  end
    
  #access
  #publio
  def get_file
   
    @file = Store.find params[:id]
    @file.dcount +=1
    send_file @file.path,:type => @file.store_content_type,:disposition => 'inline'

  end

  end

  # GET /stores/new
  # GET /stores/new.xml
  def new
    @store = Store.new 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
    params[:tags] = @store.tag_list.split().join(", ")
  end

  # POST /stores
  # POST /stores.xml
  def create
    @store = Store.new(params[:store])
    @store.tag_list = params[:tags]
    
    respond_to do |format|
      if @store.save
        flash[:notice] = 'Store was successfully created.'
        format.html { redirect_to(@store) }
        format.xml  { render :xml => @store, :status => :created, :location => @store }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.xml
  def update
    @store = Store.find(params[:id])
    @store.save_tags
    
    respond_to do |format|
      
       if @store.update_attributes(params[:store])
         flash[:notice] = 'Изменения успешно приняты.'
         format.html { redirect_to(@store) }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
       end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.xml
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to(stores_url) }
      format.xml  { head :ok }
    end
  end
end
