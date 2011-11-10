class ProductsController < ApplicationController
  respond_to :json, :xml
  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
      format.json  { render :json => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
      format.json  { render :json => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
      format.json  { render :json => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
        format.json  { render :json => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        format.json  { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }

        # RhoConnect server
        server = "http://127.0.0.1:9292"
        login = "rhoadmin"
        password = ""

        # Login to the RhoConnect server
        res = RestClient.post("#{server}/login", { :login => login, :password => password }.to_json, :content_type => :json)

        # Get the token from the login response
        token = RestClient.post("#{server}/api/get_api_token", '', { :cookies => res.cookies })

        # Send a ping message, which triggers a ping on the device
        ping_params = {
          :api_token => token,
          :user_id => ["bhanu"], # user_id that this message is for
          :sources => ["Product"], # sources we want to sync when this message is received
          :vibrate => "2",
          :message => "#{params[:product][:name]} has been updated",
          :sound => ''
        }

        RestClient.post("#{server}/api/ping", ping_params.to_json, :content_type => :json)

      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        format.json  { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
