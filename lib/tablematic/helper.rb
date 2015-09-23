require 'action_view'

module TableHelper
  def table_for(records, options={}, &block)
    attr = options[:attributes] || records.first.attribute_names
    concat TableBuilder.new(records, attr, options).build(self, &block)
  end
end

ActionView::Base.class_eval do
  include TableHelper
end
