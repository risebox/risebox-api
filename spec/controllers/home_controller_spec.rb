require 'spec_helper'

describe HomeController do
  describe '#index' do
    it 'renders index view' do
      get :index
      expect(response).to render :index
    end
  end
end

