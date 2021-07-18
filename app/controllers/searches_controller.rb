class SearchesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @search = Supports::Search.search(params)
  end
end
