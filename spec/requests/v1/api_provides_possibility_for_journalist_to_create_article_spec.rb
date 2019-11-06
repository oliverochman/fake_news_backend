RSpec.describe 'Can create article with attributes' do
  let(:journalist) { create(:user, role: 'journalist') }
  let(:credentials) { journalist.create_new_auth_token}
  let(:headers) {{ HTTP_ACCEPT: "application/json" }.merge!(credentials)}
  let(:image) do
    [{
      type: 'application/jpg',
      encoder: 'name=new_iphone.jpg;base64',
      data: 'iVBORw0KGgoAAAANSUhEUgAABjAAAAOmCAYAAABFYNwHAAAgAElEQVR4XuzdB3gU1cLG8Te9EEgISQi9I71KFbBXbFixN6zfvSiIjSuKInoVFOyIDcWuiKiIol4Q6SBVOtI7IYSWBkm',
      extension: 'jpg'
    }]
  end
  
  describe "can post article successfully" do
    let(:category) {FactoryBot.create(:category)}

    before do
      post '/v1/articles', params: {
        title: "Which drugs can kill you?",
        content: "Oh it is all of them!",
        category_id: category.id,
        category: category.name,
        journalist: journalist,
        image: image
      },
      headers: headers
    end

    it "returns 200 response" do
      
      # binding.pry
      
      expect(response.status).to eq 200
    end
    
    it "that has an image attached" do
      article = Article.find_by(title: response.request.params['title'])
      expect(article.image.attached?).to eq true  
    end
  end

  describe "cannot post article successfully with incomplete information" do

    before do
      post '/v1/articles', params: {
        title: "Wh",
        content: "Oh",
        image: image
      },
      headers: headers
    end

    it "returns an error status when title and content is incomplete" do
      article = Article.find_by(title: response.request.params['title'])
      expect(response.status).to eq 400
    end

    it "returns an error message when title and content is incomplete" do
      article = Article.find_by(title: response.request.params['title'])
      expect(response_json['error_message']).to eq 'Title is too short (minimum is 3 characters), Content is too short (minimum is 10 characters), and Category must exist'
    end
  end
end