#VIM:fileencoding=UTF-8
class SdksController < ApplicationController
  layout 'default'
  
  def index  
 
  end
  
  def sdks_list
    @sdks = Sdk.paginate :all,:conditions=>['status=?',Sdk::ACTIVE_STATUS],:order=>'os_type',:page=>params[:page],:per_page=>15
  end
  
  def download
    @sdk = Sdk.where(:os_type=>params[:os_type].to_i,
                        :status=>Sdk::ACTIVE_STATUS).first
    path = @sdk.file.path
    begin      
    send_file(path,
#              :filename=>path.split(/\//)[path.split(/\//).size-1],
              :stream=>true,
              :dispotition=>'attachment',
              :buffer_size=>1024*100)
     header["Content-Description"] = "Top secret"
     rescue ActiveRecord::RecordNotFound => ex then
          raise ex
     end
  end
end