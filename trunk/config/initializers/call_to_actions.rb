# encoding: UTF-8
require 'call_to_action'

CallToAction.add 'url', '在浏览器中显示URL。' do |action|
  action.add_param 'URL', '显示的URL', :type=>'url'
end

CallToAction.add 'install_app', '安装应用。' do |action|
  action.add_param 'URL', '下载应用的URL', :type=>'url'
end
