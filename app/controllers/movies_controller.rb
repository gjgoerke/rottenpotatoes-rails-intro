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
    @movies = Movie.all
    if session[:sortby] == 'title'
        @movies = Movie.order(:title)#.sort_by(&:title)
    elsif (session[:sortby] == 'rating') 
        @movies = Movie.order(:rating)
    elsif session[:sortby] == 'release_date'
        @movies = Movie.order(:release_date)
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
