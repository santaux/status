class ApplicationController < ActionController::Base
  layout lambda { |controller| request.xhr? ? false : 'application' }

  protect_from_forgery
end
