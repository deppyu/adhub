module Fusion
  module Security
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include HelperMethods
        helper_method :has_privilege  if self.respond_to?(:helper_method)
      end
    end
    
    def check_privilege
      requirement = self.class.security_requirement_manager.find_requirement_for_action(action_name)
      return true if requirement.nil?
      if (data_object = requirement.data_object)
        if data_object.is_a? Symbol
          data_object = self.instance_variable_get(data_object)
        end
      end
      if current_user
        check_result = requirement.check(current_user, data_object)
        logger.info "check_result is #{check_result}"
        return true if check_result == true
      else
        redirect_to new_session_url
        return false
      end
      respond_to do |format|
        format.html {
          if request.xhr?
            alert t('error.no_privilege')
          else
            flash[:notice] = t('error.no_privilege')
            redirect_to '/'
          end
        }
      end
      return false
    end
    
    module HelperMethods
      def has_privilege(privilege, user, data_object=nil)
        return false if user.nil?
        roles = user.role_names
        return nil if roles.nil? or roles.empty?
        role = roles.find do |role_name|
          (r = RoleRepository.find_role(role_name)) and r.has_privilege(privilege, user, data_object)
        end
        unless role.nil?
          if block_given?
            return yield
          else
            return true
          end
        else
          return false
        end
      end
    end
    
    module ClassMethods
      def require_privilege(privilege, options={})
        security_requirement_manager.append_security_requirement(privilege, options)
      end
      
      def security_requirement_manager
        if manager = read_inheritable_attribute('security_requirement_manager')
          return manager
        else
          write_inheritable_attribute('security_requirement_manager', SecurityRequirementManager.new)
          return security_requirement_manager
        end
      end
      
    end # ClassMethods
    
    class SecurityRequirementManager
      def initialize
        @requirements = Array.new
      end
      
      def append_security_requirement(privilege, options={})
        @requirements << SecurityRequirement.new(privilege, options)
      end
      
      def find_requirement_for_action(action_name)
        return @requirements.find { |requirement| requirement.applied_to? action_name}
      end
    end
    
    class SecurityRequirement
      include HelperMethods
      
      def initialize(privilege, options={})
        @privilege = privilege
        @options = update_options(options)
      end
      
      def applied_to?(action_name)
        if @options[:only]
          return @options[:only].include?(action_name)
        elsif @options[:except]
          return !@options[:except].include?(action_name)
        else
          return true
        end
      end

      def check(user, data_object=nil)
        return has_privilege(@privilege, user, data_object)
      end
      
      def data_object
        return @options[:data_object]
      end
      
      private
      def update_options(options)
        return {} if options.nil?
        [:only, :except].each do |key|
          if values = options[key]
            options[key] = Array(values).map(&:to_s).to_set
          end
        end
        return options
      end
    end # SecurityPolicy
    
    class RoleRepository
      class << self
        attr_accessor :repository
      end
      def self.config
        self.repository = RoleRepository.new
        if block_given?
          yield self.repository
        end
      end
      
      def self.find_role(role_name)
        return nil if self.repository.nil?
        return self.repository.find_role(role_name)
      end
      
      def initialize
        @roles = {}
      end
      
      def add_role(name)
        role = Role.new(name)
        if block_given?
          yield role
        end
        @roles[name] = role
      end
      
      def find_role(name)
        return nil if name.nil?
        return @roles[name.to_sym]
      end
    end # RoleRepository
    
    class Role
      def initialize(name)
        @name = name
        @privileges = []
      end
      
      def add_privilege(privileges, options={})
        privs = [privileges].flatten
        @privileges << [privs, options]
      end
      
      def has_privilege(privilege, user, data_object)
        @privileges.find do |priv|
          if priv[0].include? privilege
            condition = priv[1][:condition]
            if condition and condition.is_a? Proc
              condition.call privilege, user, data_object
            else
              true
            end
          else
            false
          end
        end
      end
    end # Role

  end # Security
end #Fusion
