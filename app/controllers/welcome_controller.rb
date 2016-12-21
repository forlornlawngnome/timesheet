class WelcomeController < ApplicationController
  def index
  	@hour_exception = HourException.new
  end
  def acknowledgements
  end
end
