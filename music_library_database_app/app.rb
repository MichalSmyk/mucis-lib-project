# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do 
    @name = params[:name]
    # @cohort_name = 'Dec 2022'
    return erb(:index)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    
    
    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do 
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    

    return erb(:album)
  end  


  get '/artists' do 
    repo = ArtistRepository.new
    @artists = repo.all
    p "Artists #{@artists}"

    return erb(:artists)
  end


  get '/artists/new' do 
    return erb(:new_artist)
  end

  get '/artists/:id' do 
      p 'Id executed'
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    p "Artist #{@artist}"
   
    return erb(:artist_id)
  end



  post '/albums' do 

    if invalid_request_parameters?
      status 400
      return ''
    end

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ''
  end

  post '/artists' do 


    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    

    repo.create(new_artist)
    return ''
  end


  def invalid_request_parameters?
    return (params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil)
  end
  

end