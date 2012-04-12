require 'rack-session-mongo'
require 'sinatra'
require 'uri'

configure do
  enable :sessions

  uri  = URI.parse(ENV['MONGOLAB_URI'])
  conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  DB   = conn.db(uri.path.gsub(/^\//, ''))
  use Rack::Session::Mongo, :db => DB, :key => 'mongo.session'
end

get '/' do
  {
    :db_collections => defined?(DB) && DB.collection_names,
    :session_time => session[:time] ||= Time.now,
    :time_now => Time.now
  }
end
