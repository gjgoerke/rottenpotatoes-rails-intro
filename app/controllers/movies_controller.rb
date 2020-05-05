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
    @all_ratings = []
    Movie.select(:rating).distinct.each do |movie|
        @all_ratings.push(movie.rating)
    end
    if params[:ratings]
        @movies = Movie.where(rating: params[:ratings].keys)
    else
        @movies = Movie.all
    end
    if session[:sortby] == 'title' && params[:ratings]
        @movies = Movie.where(rating: params[:ratings].keys).order(:title)
    elsif session[:sortby] == 'title' && !params[:ratings]
        Movie.all.order(:title)
    elsif (session[:sortby] == 'rating') && params[:ratings]
        @movies = Movie.where(rating: params[:ratings].keys).order(:rating)
    elsif (session[:sortby] == 'rating') && !params[:ratings]
        @movies = Movie.all.order(:rating)
    elsif session[:sortby] == 'release_date' && params[:ratings]
        @movies = Movie.where(rating: params[:ratings].keys).order(:release_date)
    elsif session[:sortby] == 'release_date' && !params[:ratings]
        @movies = Movie.all.order(:release_date)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def sortby_title
    if session[:sortby] == 'title'
        session[:sortby] = ''
    else
        session[:sortby] = :title 
    end
    redirect_to movies_path
  end
  def sortby_rating
    if session[:sortby] == 'rating'
        session[:sortby] = ''
    else
        session[:sortby] = :rating
    end
    redirect_to movies_path
  end
  def sortby_release_date
    if session[:sortby] == 'release_date'
        session[:sortby] = ''
    else
        session[:sortby] = :release_date
    end
    redirect_to movies_path
  end

end
