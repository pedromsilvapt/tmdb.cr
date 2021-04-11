require "./person"
require "./tv_season"

class Tmdb::Credit
  enum Type
    Cast
    Crew
  end

  class Media
    enum Type
      Tv
      Movie
    end

    getter media_type : Type
    getter media : MovieResult | TVShowResult
    getter character : String

    def initialize(@media_type : Type, data : JSON::Any)
      if media_type.tv?
        @media = TVShowResult.new(data)
      else
        @media = MovieResult.new(data)
      end

      @character = data["character"].as_s
    end
  end

  getter credit_type : Type
  getter department : String
  getter job : String
  getter media : Media
  getter id : String
  getter person : Person

  def self.detail(id : String) : Credit
    res = Resource.new("/credit/#{id}")
    data = res.get

    Credit.new(data)
  end

  def initialize(data : JSON::Any)
    @credit_type = Type.parse(data["credit_type"].as_s)
    @department = data["department"].as_s
    @job = data["job"].as_s
    @media = Media.new(Media::Type.parse(data["media_type"].as_s), data["media"])
    @id = data["id"].as_s
    @person = Person.new(
      name: data["person"]["name"].as_s,
      id: data["person"]["id"].as_i64,
    )
  end
end
