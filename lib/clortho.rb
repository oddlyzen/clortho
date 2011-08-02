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
      
      module ExclusionConstants
        # Helper verbs, sometimes referred to as "forms of the verb (to) 'be'", usually offer no added meaning
        VERBS       = [:have, :has, :had, :do, :does, :did, :be, :am, :is, :are, :was, :were, :having, 
                       :been, :can, :could, :shall, :should, :will, :would, :may, :might, :must, :being]
        # Article adjectives are normally fluff and offer no additional context or meaning
        ADJECTIVES  = [:a, :an, :the]
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
        
        @defaults_set = false
        
        def inject_default_keywords
          searchable_with_options.each do |field|
            if !self.send(field[0]).nil?
              keywords = !field[1][:exclude].nil? ? filter_on_exclusions(field, self.send(field[0])) : self.send(field[0])
              keywords = filter_and_normalize(keywords)
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
                keywords.gsub!(exclusion.to_s, '')
              elsif exclusion.is_a? Symbol
                klass = self.class
                if exclusion == :adjectives
                  Clortho::ExclusionConstants::ADJECTIVES.each do |adj|
                    keywords.gsub!(adj.to_s, '')
                  end
                elsif exclusion == :verbs
                  Clortho::ExclusionConstants::VERBS.each do |v|
                    keywords.gsub!(v.to_s, '')
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