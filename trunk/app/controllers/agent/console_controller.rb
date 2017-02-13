require 'dynamic_query'
class Agent::ConsoleController < Agent::AgentController
  include Imon::DynamicQuery
  layout "default"
  
  def index
    if params[:a_id]
       party = Party.find params[:a_id]
       session[:party] = party
    end
  end
end
