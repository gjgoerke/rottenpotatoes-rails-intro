class MoviesController < ApplicationController

  def MoviesController.all_ratings
    @all_ratings = {}
        Movie.select(:rating).distinct.each do |movie|
            @all_ratings[movie.rating] = '1'
        end
    @all_ratings
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings]
        session[:ratings] = params[:ratings]
    end
    session[:ratings] = MoviesController.all_ratings unless session[:ratings]
    if session[:sortby]
        @movies = Movie.where(rating: session[:ratings].keys).order(session['sortby'])
    else
       @movies = Movie.where(rating: session[:ratings].keys)
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
