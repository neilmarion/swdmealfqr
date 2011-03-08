require 'hashie'

module YieldStarClient
  class BaseModel < Hashie::Trash
    # Defines an attribute, including the creation of accessor and mutator methods.
    #
    # @param [Symbol] property_name the name of the attribute
    # @param [Hash] options 
    # @option options [Object] :default the default value for this property 
    # @option options [Symbol,String] :from the original write-only attribute name 
    # @option options [Object] :type the type that the value should be converted to (String, Integer, Float, Array, Date, Symbol)
    def self.property(property_name, options = {})
      super

      if options[:type]
        if options[:type].to_s =~ /^date$/i
          converter = "Date.parse(raw_#{property_name}(&block).to_s)"
        elsif options[:type].to_s =~ /^symbol$/i
          converter = "raw_#{property_name}(&block).downcase.gsub(/\s+/,'_').to_sym"
        else
          converter = "#{options[:type].to_s.capitalize}(raw_#{property_name}(&block))"
        end

        class_eval <<-RUBY
          alias :raw_#{property_name} :#{property_name}
          def #{property_name}!(&block)
            val = raw_#{property_name}(&block) 
            val.is_a?(#{options[:type].to_s.capitalize}) ? val : #{converter}
          end

          def #{property_name}(&block)
            #{property_name}!(&block) rescue raw_#{property_name}(&block)
          end
        RUBY
      end 
    end
  end
end
