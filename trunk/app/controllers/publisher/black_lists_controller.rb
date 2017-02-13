# -*- coding: utf-8 -*-
require 'dynamic_query'
class Publisher::BlackListsController < Publisher::PublisherController
    include Imon::DynamicQuery
    before_filter :find_black_list, :only=>[:edit, :destroy, :show]
    layout "default"

    def index
      exps = []
      if !params[:keyword].nil? and !params[:keyword].empty?
        ids = []
        parties = Party.find_by_sql ["select id from parties where name like ?", "%#{params[:keyword]}%"]
        advertisements = Advertisement.find_by_sql ["select id from advertisements where name like ?", "%#{params[:keyword]}%"]
        parties.collect {|p| ids << p.id } if parties and parties.count > 0
        advertisements.collect {|a| ids << a.id } if advertisements and advertisements.count > 0
        exps << self.in(:black_member_id, ids) if ids.count > 0
      end
      exps << self.equal(:party_id, current_user.party.id)
      exps << self.equal(:black_member_type, params[:black_member_type]) if params[:black_member_type] and !params[:black_member_type].empty?
      @black_lists = BlackList.paginate :all, :conditions=>self.and(exps).conditions, :order=>'created_at desc', :page=>params[:page], :per_page=>10
    end

    def create
      if current_user.party.black_lists.where(params[:black_list]).count > 0
        alert "黑名单中已经存在该成员，不能重复添加!"
        return
      end
      @black_list = current_user.party.black_lists.build params[:black_list]
      unless @black_list.save
        alert "添加到黑名单失败!"
      end
    end # def create

    def destroy
      unless @black_list.destroy
        flash.now[:notice] = "移除失败！"
      end
    end

private
    def find_black_list
        @black_list = BlackList.find params[:id]
    end
end
