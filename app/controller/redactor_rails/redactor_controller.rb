class RedactorRails::RedactorController < ApplicationController
  before_action :redactor_authenticate_user!

  private
  
  def redactor_authenticate_user!
    if has_devise_user?
      super
    end
  end

end
