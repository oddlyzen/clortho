module MongoMapper
  module Plugins
    module Clortho
      extend ActiveSupport::Concern
      
      included do
      end
      
      module ClassMethods
        
        def searchable(*args)
          options = args.extract_options!
          
          args.each do |arg|
            key :"#{arg}_keywords", String, default: ""
            key :"#{arg}_keywords_array", Array, default: []
            
            class_eval <<-CODE
              class << self
              end
            CODE
          end
        end
        
      end
      
      module InstanceMethods
      end
      
    end
  end
end