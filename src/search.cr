require "./lazy_iterator"
require "./movie_result"

class Tmdb::Search
  def self.movie(
    query : String,
    language : String? = nil,
    include_adult : Bool? = nil,
    region : String? = nil,
    year : Int32? = nil,
    primary_release_year : Int32? = nil
  ) : LazyIterator(MovieResult)
    filters = Hash(Symbol, String).new
    filters[:query] = query
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:region] = region.not_nil!.upcase unless region.nil?
    filters[:year] = year.not_nil!.to_s unless year.nil?
    filters[:primary_release_year] = primary_release_year.not_nil!.to_s unless primary_release_year.nil?

    res = Resource.new("/search/movie", filters)
    LazyIterator(MovieResult).new(res)
  end
end
