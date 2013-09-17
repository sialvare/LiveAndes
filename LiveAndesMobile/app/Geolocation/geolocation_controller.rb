require 'rho/rhocontroller'
require 'helpers/browser_helper'

class GeolocationController < Rho::RhoController
  include BrowserHelper

  # GET /Geolocation
  def index
    @geolocations = Geolocation.find(:all)
    render :back => '/app'
  end

  # GET /Geolocation/{1}
  def show
    @geolocation = Geolocation.find(@params['id'])
    if @geolocation
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Geolocation/new
  def new
    @geolocation = Geolocation.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Geolocation/{1}/edit
  def edit
    @geolocation = Geolocation.find(@params['id'])
    if @geolocation
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Geolocation/create
  def create
    @geolocation = Geolocation.create(@params['geolocation'])
    redirect :action => :index
  end

  # POST /Geolocation/{1}/update
  def update
    @geolocation = Geolocation.find(@params['id'])
    @geolocation.update_attributes(@params['geolocation']) if @geolocation
    redirect :action => :index
  end

  # POST /Geolocation/{1}/delete
  def delete
    @geolocation = Geolocation.find(@params['id'])
    @geolocation.destroy if @geolocation
    redirect :action => :index  
  end
  #Incorporados desde la API de la documentación
  def preload_map
       puts '$$$ preload map START'
       
       options = { :engine => @params['provider'],
           :map_type => @params['map_type'],
           :top_latitude => 60.1,
           :left_longitude => 30.0,
           :bottom_latitude => 59.7,
           :right_longitude => 30.6,
           :min_zoom => 9,
           :max_zoom => 11
         }
       count = MapView.preload_map_tiles(options, url_for(:action => :preload_callback))    
       puts '$$$ preload map FINISH   count = '+count.to_s
       redirect :action => :index
   end
 
   def showmap
      puts @params.inspect
      
     if System::get_property('platform') != 'Blackberry'
         GeoLocation.set_notification "", ""
     end
      
      #pin color
      if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
        #@params['latitude'] = '37.349691'
        #@params['longitude'] = '-121.983261'
        @params['latitude'] = '59.9'
        @params['longitude'] = '30.3'
      end
      
      region = [@params['latitude'], @params['longitude'], 0.6, 0.6]     
      #region = {:center => @params['latitude'] + ',' + @params['longitude'], :radius => 0.2}

     map_params = {
           :provider => @params['provider'],
           :settings => {:map_type => "roadmap", :region => region,
                         :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => true, :api_key => '0jDNua8T4Teq0RHDk6_C708_Iiv45ys9ZL6bEhw'},
           :annotations => myannotations
      }
 
      #if @params['provider'] == 'RhoGoogle'
          MapView.set_file_caching_enable(1)
      #end 
 
      puts map_params.inspect            
      MapView.create map_params
      redirect :action => :index
   end


    
  
  
end
