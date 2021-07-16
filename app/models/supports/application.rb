class Supports::Application
  class << self
    def object_paginate convert_method=nil, objects
      if objects == []
        WillPaginate::Collection.create(1, 1, 0) do |pager|
          pager.replace([])
        end        
      else
        current_page   = objects.current_page
        per_page       = objects.per_page
        total_entries  = objects.total_entries
        model_name     = objects.model.name
        convert_method = "convert_#{model_name.downcase.pluralize}" if convert_method.nil?
        WillPaginate::Collection.create(current_page, per_page, total_entries) do |pager|
          pager.replace("Supports::#{model_name}".constantize.send(convert_method, objects))
        end
      end
    end
  end
end
