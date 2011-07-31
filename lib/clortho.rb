module MongoMapper
  module Plugins
    module Clortho
      extend ActiveSupport::Concern
      
      included do
      end
      
      module ClassMethods
        
        def searchable(*args)
          args.each do |arg|
            key :"#{arg}_keywords", String
            key :"#{arg}_keywords_array", Array
          end
        end
        
      end
      
      module InstanceMethods
      end
      
    end
  end
end