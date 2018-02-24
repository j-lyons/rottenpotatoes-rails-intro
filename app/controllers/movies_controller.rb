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
    @all_ratings = Movie.ratings
    ratings_hash = params[:ratings] || session[:ratings] || @all_ratings.product(["1"]).to_h
    @checks = ratings_hash.keys
    
    p params
    sort = params[:sort] || session[:sort] || nil   #:sort=>
    p sort
    @sort_hash = {"title" => '', "release_date" => ''}
    @sort_hash[sort] = "hilite"
    p @sort_hash
    
    session[:sort] = sort
    session[:ratings] = ratings_hash
    
    if ratings_hash != params[:ratings] || sort != params[:sort]
      flash.keep
      return redirect_to movies_path(:sort => sort, :ratings => ratings_hash)
    end  
    
    @movies = Movie.where(rating: @checks).order(sort)
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
