module MongoMapper
  module Plugins
    autoload :Clortho, 'clortho'
    
    module Clortho
      extend ActiveSupport::Concern
      
      included do
        class_inheritable_accessor  :searchable_with_options
        write_inheritable_attribute :searchable_with_options, []
        set_callback :create, :before, :inject_default_keywords
        extend ClassMethods
      end
      
      module ClassMethods
        
        def searchable(*args)
          options = args.extract_options!
          
          args.each do |arg|
            key :"#{arg}_keywords", String, default: ""
            key :"#{arg}_keywords_array", Array, default: []
            
            searchable_with_options << [arg.to_sym, options]
            
            class_eval <<-CODE
              class << self
              end
            CODE
          end
        end
        
      end
      
      module InstanceMethods
        
        @defaults_set = false
        
        def inject_default_keywords
          searchable_with_options.each do |field|
            if !self.send(field[0]).nil?
              keywords = self.send(field[0])
              self.send("#{field[0].to_s}_keywords=".to_sym, keywords) if keywords
              self.send("#{field[0].to_s}_keywords_array=".to_sym, keywords.split) if keywords
            end
          end
        end
        
      end
      
    end
  end
end