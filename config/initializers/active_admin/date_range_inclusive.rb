module ActiveAdmin
  class ResourceDSL
    def filter(*args)
      field = args[0]
      klass = @config.resource_class_name.constantize
      type  = klass.columns.select{|c| c.name == field.to_s}.first.try(:type)
 
      if type == :datetime
        controller do
          before_filter do
            if !params["q"].blank? && !params["q"]["#{field}_lteq"].blank?
              params["q"]["#{field}_lteq"] += " 23:59:59.999999"
            end
          end
        end
      end
 
      super
    end
  end
end