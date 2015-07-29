class SigningController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # def new
  #   @field_name = params[:field]
  #   @storage = storage_for_media_type(params[:media_type])
  #   @path_prefix = path_prefix_for_media_type(params[:media_type], params[:sub_folder])
  # end

  def form
    @storage          = Storage.new(storage_name_from_upload_type("strip_photos"))
  end

  def sign
    # @transport        = params[:transport] || (request.env['HTTP_USER_AGENT'].match(/MSIE/) ? 'iframe' : 'xhr')
    puts "params  #{params}"
    @storage          = Storage.new(storage_name_from_upload_type(params[:upload_type]))
    @image_name       = params[:file_name]
    extension         = 'jpg'

    respond_to do |format|
      format.all {
        render json: {
          url:        @storage.url,
          bucket:     @storage.bucket,
          access_key: @storage.access_key,
          policy:     upload_policy(),
          signature:  upload_signature(),
          key:        upload_key(@image_name, Time.now, extension)
        }
      }
    end
  end

  def upload_done
    render :text => 'done', :layout => false, :content_type => "text/plain"
  end

private

  def upload_policy
    return @policy if @policy
    if @storage.local?
      ret = {"expiration" => 5.minutes.from_now.utc.xmlschema,
        "conditions" =>  [
          ["starts-with", "$key", @image_name]
        ]
      }
    elsif @storage.provider == 'Google'
      ret = {"expiration" => 5.minutes.from_now.utc.xmlschema,
        "conditions" =>  [
          ["starts-with", "$key", @image_name],
          {"acl" => "public-read"},
          ['starts-with','$Content-Type','image/'],
          ["content-length-range", 0, @storage.max_size]
        ]
      }
    elsif @storage.provider == 'AWS'
      ret = {"expiration" => 5.minutes.from_now.utc.xmlschema,
        "conditions" =>  [
          {"bucket" => @storage.bucket },
          ["starts-with", "$key", @image_name],
          {"acl" => "public-read"},
          ['starts-with','$Content-Type','image/'],
          ["content-length-range", 0, @storage.max_size]
        ]
      }
    end

    # ret['conditions'] << {"success_action_redirect" => upload_upload_done_url} if @transport == 'iframe'

    @policy = Base64.encode64(ret.to_json).gsub(/\n/,'')
  end

  def upload_signature
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), @storage.secret_key, upload_policy)).gsub("\n","")
  end

  def upload_key name, time, extension
    "#{name}_#{time.strftime('%Y-%m-%d_%I-%M-%S')}.#{extension}"
  end

  def storage_name_from_upload_type upload_type
    upload_type.to_sym
  end

end
