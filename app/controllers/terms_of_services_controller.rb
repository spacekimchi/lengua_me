class TermsOfServicesController < ApplicationController
  def show
    @date = l(Date.parse('2024/12/13'))
  end
end
