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
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings]
    if (!params[:ratings] || !params[:sort]) && @sort && @ratings
        rd = true
    end
    session[:sort] = params[:sort] unless !params[:sort]
    session[:ratings] = params[:ratings] unless !params[:ratings]
    if rd 
        # params.permit(:sort, :commit, :utf8, {:ratings => [{:R => 1}, {'PG-13' => 1}, {:G => 1}, {:PG => 1}]})
        params.permit!
        ps = {:sort => @sort, :ratings => @ratings}
        redirect_to movies_path(params: ps)
    end
    @movies = Movie.where(rating: @ratings.keys).order(@sort)
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
end
