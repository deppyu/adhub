require 'digest/sha1'   

module  Imon     
  module ActiveRecord     
    module Password     
      PASSWORD_CHARACTERS='01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-'
      def self.included(base)
        base.extend(ClassMethods)
      end                        
      
      module ClassMethods     
        def has_password(clear_field='password', encrypted_field='password_hash', ha1_field = nil, ha1_realm=nil)
          clear_field=clear_field.to_s.to_sym unless clear_field.is_a?(Symbol)
          attr_accessor clear_field.to_s.to_sym
          
          class_eval %Q$
            def encrypt_#{clear_field} 
              unless #{clear_field}.nil? || #{clear_field}.empty? 
                self.#{encrypted_field}=Imon::ActiveRecord::Password::encrypt(self.#{clear_field})
              end
            end$            
            
          class_eval %Q$
            def reset_#{clear_field}  
              @#{clear_field}=Imon::ActiveRecord::Password::generate 
            end$

          before_save "encrypt_#{clear_field}".to_sym

          unless ha1_field.nil?
            ha1_realm = 'System' if ha1_realm.nil?
            
            class_eval %Q$
              def encrypt_#{ha1_field}
                unless #{clear_field}.nil? or #{clear_field}.empty?
                    self.#{ha1_field} = Digest::MD5.hexdigest([self.login_name, '#{ha1_realm}', self.#{clear_field}].join(':')) 
                end
              end
            $
            before_save "encrypt_#{ha1_field}".to_sym
          end
        end
      end #module ClassMethods
      
      def self.encrypt(clear_text)
        Digest::MD5.hexdigest(clear_text) 
      end                  
      
      def self.generate(length=8)  
        p=''
        1.upto(8) { |i| p << PASSWORD_CHARACTERS[rand(PASSWORD_CHARACTERS.length)] }
        p
      end
      
    end #module Password
  end #module ActiveRecord
end # module Imon

