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
    @all_ratings = Movie.ratings
    @checks = @all_ratings
    @checks = session[:r] if session.key?(:r)
    @checks = params[:ratings].keys if params.key?(:ratings)
    #@movies = Movie.where(rating: @checks)
    if params.key?(:by_title)
      @movies = Movie.where(rating: @checks).order(:title)
      session[:by_title] = 0;
      session.delete(:by_date)
    elsif params.key?(:by_date)
      @movies = Movie.where(rating: @checks).order(:release_date)
      session[:by_date] = 0;
      session.delete(:by_title)
    elsif session.key?(:by_title)
      @movies = Movie.where(rating: @checks).order(:title)
    elsif session.key?(:by_date)
      @movies = Movie.where(rating: @checks).order(:release_date)
    end
    session[:r] = @checks
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
