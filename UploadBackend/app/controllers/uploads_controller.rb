class UploadsController < ApplicationController

  def index
    @uploads = Upload.all
    render :json => @uploads.to_json
  end

  def show
    upload = Upload.find(params[:id])
    send_file upload.attachment.path, :type => upload.attachment_content_type
  end

  def create
    @upload = Upload.new(params[:upload])
    if @upload.save
      render :text => @upload.to_json, :status => :created
    else
      render :text => @upload.errors.to_json, :status => :unprocessable_entity
    end
  end
  
end
