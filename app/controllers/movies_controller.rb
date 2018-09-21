class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if !params[:sort].nil?
        @sort = params[:sort]
    elsif !session[:sort].nil?
        @sort = session[:sort]        
    end
    
    if !params[:ratings].nil?
        @ratings = params[:ratings]
    elsif !session[:ratings].nil?
        @ratings = session[:ratings]
    else    
        @ratings = all_ratings
    end
     
    session[:sort] = @sort
    session[:ratings] = @ratings
    
    @movies = Movie.where( { rating: @ratings.keys } ).order(@sort)
   
    
     if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path sort: @sort, ratings: @ratings
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    movie = Movie.create!(movie_params)
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    movie = Movie.find params[:id]
    movie.update_attributes!(movie_params)
    redirect_to movie_path(@movie)
  end

  def destroy
    movie = Movie.find(params[:id])
    movie.destroy
    redirect_to movies_path
  end

  helper_method :hilite
    def hilite(header)
        return 'hilite' if @sort == header
    end
    

    def all_ratings  
        hash = {}
        @all_ratings.each { |x| hash[x] = '1' }
        return hash
     end
end