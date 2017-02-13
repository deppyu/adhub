# encoding: UTF-8
# -*- coding: UTF-8 -*-
require 'call_to_action'

module ApplicationHelper
  def page_title(title)
    @page_title = title
  end
  
  def page_title_tag
    title_token = [@page_title]
    title_token << t('site.title')
    return content_tag(:title, title_token.join('——'))
  end

  def include_js_file(*js_files)
    @js_files = @js_files || []
    @js_files << js_files
  end
  
  def include_css_file(*css_files)
    @css_files = @css_files || []
    @css_files << css_files
  end

  def side_bar(side_bar)
    @side_bar = side_bar.to_s
  end

  def side_bar_2(side_bar)
    @side_bar_2 = side_bar.to_s
  end
  
  def body_class(css_class=nil)
    @body_class = [] if @body_class.nil?
    if css_class
      @body_class << css_class
    else
      if @side_bar_2
        @body_class << (@side_bar ? 'column_3' : 'column_2b')
      elsif @side_bar
        @body_class << 'column_2'
      else
        @body_class << 'column_1'
      end
    end
    @body_class.join(' ')
  end
  
  def use_remote_form_dialog
    @use_remote_form_dialog = true
  end
  
  def use_google_map
    @use_google_map = true
    include_css_file 'map'
  end

  def format_date(date, format=:long)
    return '' if date.nil?
    l date, :format=>format
  end

  def format_time(time, format=:long)
    return '' if time.nil?
    l time.localtime, :format=>format
  end

  def format_money(money)
    return '' if money.nil?
    number_to_currency money, :unit=>'￥'
  end

  def navigation_bar(navi_items = [], options={}, &block)
    html = '<div class="navigation_bar">'
    html << capture(&block) if block_given?
    html << navi_items.join('&nbsp;&gt;&nbsp;')
    html << "</div>"
    @navigation_bar_content = raw(html)
  end

  def call_to_action_select(form, method)
    form.collection_select method, CallToAction.actions, :name, :note
  end

  def ad_format_select(form, method, options={}, html_options={})
    form.collection_select method, AdFormat.formats, :name, :note, options, html_options
  end

  def approve_option_select_tag(name, selected=nil)
    select_tag name, options_for_select([['审核通过', '0'], ['审核不通过', '1']], selected)
  end
  def business_type_select(form, method, options={})
      option_tags = [['发行商', Contract::BUSINESS_TYPE_PUBLISHER], ['代理商', Contract::BUSINESS_TYPE_AGENT], ['广告主', Contract::BUSINESS_TYPE_AD_OWNER]]
      form.select method, option_tags, options
  end
end
