class RedactorRails::DocumentsController < ApplicationController

  def index
    condition = {}
    condition = { RedactorRails.devise_user_key => redactor_current_user.id } if has_devise_user?
    @documents = RedactorRails.document_model.where(condition)
    render json: @documents
  end

  def create
    @document = RedactorRails.document_model.new

    file = params[:file]
    @document.data = RedactorRails::Http.normalize_param(file, request)
    if @document.respond_to?(RedactorRails.devise_user)
      @document.send("#{RedactorRails.devise_user}=", redactor_current_user)
      @document.assetable = redactor_current_user
    end

    if @document.save
      render json: { filelink: @document.url, filename: @document.filename }
    else
      render nothing: true
    end
  end

  private
  
  def has_devise_user?
    @_has_devise_user ||= RedactorRails.document_model.new.respond_to?(RedactorRails.devise_user)
  end
  
end
