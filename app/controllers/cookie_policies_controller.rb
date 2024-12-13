class CookiePoliciesController < ApplicationController
  def show
    @date = Date.parse('2024/12/13').strftime("%Y-%m-%d")
  end
end
