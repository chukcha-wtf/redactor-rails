require 'redactor_rails/redactor_controller'

class RedactorRails::PicturesController < RedactorRails::RedactorController

  def index
    condition = {}
    condition[RedactorRails.devise_user_key] = redactor_current_user.id  if has_devise_user?
    @pictures = RedactorRails.picture_model.where(condition)
    render json: @pictures
  end

  def create
    @picture = RedactorRails.picture_model.new

    file = params[:file]
    @picture.data = RedactorRails::Http.normalize_param(file, request)
    if has_devise_user?
      @picture.send("#{RedactorRails.devise_user}=", redactor_current_user)
      @picture.assetable = redactor_current_user
    end

    if @picture.save
      render json: { filelink: @picture.url }
    else
      render nothing: true
    end
  end
  
  private
  
  def has_devise_user?
    @_has_devise_user ||= RedactorRails.picture_model.new.respond_to?(RedactorRails.devise_user)
  end

  
  
end
