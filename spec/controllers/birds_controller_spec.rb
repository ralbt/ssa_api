require 'rails_helper'

RSpec.describe BirdsController, type: :controller do

  describe 'GET /birds' do

    it 'returns empty' do
      get :index
      expect(response).to have_http_status(200)
      resp = JSON.parse(response.body)
      expect(resp).to be_empty
    end

    it 'return empty items' do
      name = 'Pigeon'
      family = 'Doves'
      continents = ['Asia']
      bird = Bird.create(name: name, family: family, continents: continents)

      get :index
      expect(response).to have_http_status(200)
      resp = JSON.parse(response.body)
      expect(resp).to be_empty
    end

    it 'return items' do
      name = 'Pigeon'
      family = 'Doves'
      continents = ['Asia']
      bird = Bird.create(name: name, family: family, continents: continents, visible: true)

      get :index
      expect(response).to have_http_status(200)
      resp = JSON.parse(response.body)
      expect(resp).not_to be_empty
      expect(resp.count).to eq(1)
      expect(resp[0]['name']).to eq(name)
      expect(resp[0]['family']).to eq(family)
      expect(resp[0]['continents']).to eq(continents)
      expect(resp[0]['added']).to eq(Time.zone.now.strftime('%Y-%m-%d'))
    end
  end

  describe 'POST /birds' do
    let(:bird_attributes) {{ name: 'Pigeon', family: 'Doves', continents: ['Doves']}}

    it 'should create a bird' do
      post :create, params: bird_attributes

      expect(response).to have_http_status(201)
      resp = JSON.parse(response.body)
      expect(resp['name']).to eq(bird_attributes[:name])
    end

    it 'should return http status 422' do
      post :create, params: { name: 'Pigeon' }
      expect(response).to have_http_status(422)
    end
  end

  describe 'GET /birds/:id' do

    it 'returns the bird' do
      name = 'Pigeon'
      family = 'Doves'
      continents = ['Asia']
      bird = Bird.create(name: name, family: family, continents: continents)

      get :show, id: bird.id
      expect(response).to have_http_status(200)
      resp = JSON.parse(response.body)
      expect(resp).not_to be_empty
      expect(resp['name']).to eq(name)
      expect(resp['family']).to eq(family)
      expect(resp['continents']).to eq(continents)
    end

    it 'should return 404' do
      get :show, id: 'xyz'
      expect(response).to have_http_status(404)
    end

  end

  describe 'DELETE /birds/:id' do

    it 'should delete a record' do
      name = 'Pigeon'
      family = 'Doves'
      continents = ['Asia']
      bird = Bird.create(name: name, family: family, continents: continents)

      delete :destory, id: bird.id
      expect(response).to have_http_status(200)
    end

    it 'should return 404' do
      delete :destory, id: 'xyz'
      expect(response).to have_http_status(404)
    end
  end

end
