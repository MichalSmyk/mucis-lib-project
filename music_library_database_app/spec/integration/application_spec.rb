require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /' do 
    it 'returns html hello message with the given name' do 
      response = get('/', name: 'Mike')

      expect(response.body).to include('<h1>Hello Mike </h1>')
      
    end
  end 

  context 'GET /albums' do 
    it 'should return the list of albums in html format' do
      response = get('/albums')
      # expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Get more information</a>')
      expect(response.body).to include('<a href="/albums/3">Get more information</a>')
      expect(response.body).to include('<a href="/albums/4">Get more information</a>')
      # expect(response.body).to include('<h1>Albums</h1>')
      # expect(response.body).to include('Title: Surfer Rosa')
      # expect(response.body).to include('Released: 1988')
    end
  end

  context 'GET /albums/:id' do 
    it 'should return info about album 2' do
      response = get('/albums/2')
      
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context 'GET /albums/new' do 
    it 'should return the form to add a new album' do 
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')

    end
  end
  context 'POST /albums' do
    it ' should create a new album' do 
      response = post(
        '/albums',
        title: 'OK Computer',
        release_year: '1997',
        artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.body).to include('OK Computer')
    end

    it 'should validate album parameters' do
      response = post(
        '/albums',
        invalid_artist_title: 'Ok Computer',
        another_invalid_thing: 123
      )

      expect(response.status).to eq(400)
    end
  end


  context 'GET /artists/new' do 
    it 'should return form to add new artist' do 
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end

  context "GET /artists" do
    it 'returns 200 OK' do
      response = get('/artists')
      # expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'

      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies')
    end
  end

  context "POST /artists" do
    it 'returns 200 OK' do
     
      response = post('/artists',
      name: 'Wild Nothing',
      genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild Nothing')

    end
  end

  context 'GET /artists/:id' do 
    it 'shows artist by id' do 
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Info</h1>')
    end
  end

  

end
