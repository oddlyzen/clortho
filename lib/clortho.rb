module MongoMapper
  module Plugins
    
    module Clortho
      extend ActiveSupport::Concern
      
      included do
        class_attribute  :searchable_with_options
        self.searchable_with_options = []
        set_callback :create, :before, :inject_default_keywords
        set_callback :update, :before, :inject_default_keywords
        extend ClassMethods
        include InstanceMethods
      end
      
      module ExclusionConstants
        # Helper verbs, sometimes referred to as "forms of the verb (to) 'be'", usually offer no added meaning
        VERBS       = %w(have has had do does did be am is are was were having
                         been can could shall should will would may might must being)
        # Article adjectives are normally fluff and offer no additional context or meaning
        ADJECTIVES  = %w(an a the)
      end
      
      module ClassMethods
        
        def searchable(*args)
          options = args.extract_options!
          
          args.each do |arg|
            key :"#{arg}_keywords", String, :default => ""
            key :"#{arg}_keywords_array", Array, :default => []
            
            searchable_with_options << [arg.to_sym, options]
            
            class_eval <<-CODE
              class << self
                def search_#{arg}_keywords_for(*keywords)
                  records = []
                  keywords.each do |word|
                    records << self.all.select{ |record| record[:'#{arg}_keywords_array'].include?(word.downcase) }
                  end
                  records.flatten.uniq
                end
              end
            CODE
          end
        end
        
      end
      
      module InstanceMethods
                
        def inject_default_keywords
          searchable_with_options.each do |field|
            if !self.send(field[0]).nil?
              text = self.send(field[0]).to_s
              keywords = filter_and_normalize(!field[1][:exclude].nil? ? filter_on_exclusions(field, filter_and_normalize(text)) : text)
              self.send("#{field[0].to_s}_keywords=".to_sym, keywords) if keywords
              self.send("#{field[0].to_s}_keywords_array=".to_sym, keywords.split.each{ |kw| kw.downcase }) if keywords
            end
          end
        end
        
        def filter_on_exclusions(field_and_options, keywords)
          field, options = field_and_options
          if options[:exclude]
            
            options[:exclude].each do |exclusion|
              if exclusion.is_a? String
                keywords.gsub!(/(\b#{exclusion}\b)/, '')
              elsif exclusion.is_a? Symbol
                klass = self.class
                ex = exclusion.to_s.upcase.to_sym
                if Clortho::ExclusionConstants::const_get(ex)
                  Clortho::ExclusionConstants::const_get(ex).each do |e|
                    keywords.gsub!(/(\b#{e}\b)/, '')
                  end
                end
              end
            end
          end
          # strip punctuation and extra spaces
          unless keywords.nil?
            filter_out_punctuation(keywords)
          end
        end
        
        def filter_out_punctuation(text)
          text.gsub(/\b\W/, ' ').strip.gsub(/\s+/, ' ')
        end
        
        def filter_and_normalize(text)
          filter_out_punctuation(text).downcase
        end
        
      end
      
    end
  end
end