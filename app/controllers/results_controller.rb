class ResultsController < ApplicationController

  def index
    @ip = request.remote_ip
    if @ip == "127.0.0.1"
      #@ip = "50.78.167.161"
      #@ip = "86.24.222.18"
      @ip = "82.18.13.139"
    end
    @country = request.location.country
    @country = "United Kingdom" if @country == "Reserved"
    @visitor = Visitor.find_or_create_by(@ip, @country)
    @iso_country = Country.find_country_by_name(@country)
    session[:local_currency] = @iso_country.currency['code']
    session[:local_currency_symbol] = @iso_country.currency['symbol']
    
    session[:genre] = params[:genre][:genre_id]
    session[:category] = params[:category][:category_id]
    session[:topic] = params[:topic][:topic_id]
    session[:method] = nil
    session[:loctn] = nil
    session[:price] = nil
    session[:qualification] = nil
    session[:supplier] = nil
    session[:kword] = nil
    session[:country] = @country
    session[:latitude] = @visitor.latitude
    session[:longitude] = @visitor.longitude
    session[:arrangement] = nil
    @products = find_products
#    @products = find_products
    @search_string = find_search_string
#    @t_methods = @products.t_methods
    @t_methods = TrainingMethod.product_selection(@products)
    respond_to do |format|
      format.html
      format.json { render json: @products }
      format.js
    end
  end

  def filter_by_method
    session[:method] = params[:method_id]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def filter_by_location
    session[:loctn] = params[:loc_id]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def filter_by_price
    session[:price] = params[:prc_id]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def filter_by_qualification
    session[:qualification] = params[:qualification_string]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def filter_by_supplier
    session[:supplier] = params[:supplier_string]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def filter_by_keyword
    session[:kword] = params[:keyword_string]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def sort_by_arrangement
    session[:arrangement] = params[:arr_id]
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @results }
      format.js
    end
  end

  def show
  end

  private 

    def find_products
      if session[:topic] == ""
        if session[:category] == ""
          @genre = Genre.find(session[:genre])
          products = @genre.active_products
        else
          @category = Category.find(session[:category])
          products = @category.active_products
        end
      else
        @topic = Topic.find(session[:topic])
        products = @topic.active_products
      end
      products = products.where("training_method_id = ?", session[:method]) unless session[:method].nil? || session[:method].blank?
      products = products.price_filter(session[:price]) unless session[:price].nil? || session[:price].blank?
      products = products.q_filter(session[:qualification]) unless session[:qualification].nil? || session[:qualification].blank?
      products = products.supply_filter(session[:supplier]) unless session[:supplier].nil? || session[:supplier].blank?
      products = products.keyword_filter(session[:kword]) unless session[:kword].nil? || session[:kword].blank?
      unless session[:loctn].nil? || session[:loctn].blank?
        if session[:loctn] == "This country"
          products = products.select_by_country(session[:country])
        elsif session[:loctn] == "Within 50 km"     # within 50kms
          products = products.nearby(session[:latitude], session[:longitude])
        elsif session[:loctn] == "Within 200 km"   #within 200 kms
          products = products.accessible(session[:latitude], session[:longitude])
        else
          products
        end
      end
      products = products.list_arrange(session[:arrangement], session[:latitude], session[:longitude])
      @count_of_products = products.count
      #products
      products.page(params[:page]).per(10)
    end

    def find_search_string
      if session[:topic] == ""
        if session[:category] == ""
          @genre = Genre.find(session[:genre])
          search_string = @genre.description
        else
          @category = Category.find(session[:category])
          search_string = @category.classification
        end
      else
        @topic = Topic.find(session[:topic])
        search_string = @topic.classification
      end
    end
end
