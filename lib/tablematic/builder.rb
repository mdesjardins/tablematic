module TableHelper
  class TableBuilder
    def initialize(records, attr, opts={})
      @records = records
      @attr = attr
      @model = @records.first.class
      @namespace = opts.fetch(:namespace,'')
      @config = Tablematic.configuration
      @opts = opts
    end

    def build(view_context, &block)
      result = "<table class='#{table_classes}'>"
      result += emit_html_heading
      result += emit_html_rows(view_context, &block)
      result += "</table>"
      result.html_safe
    end

    def output_buffer=(other)
    end

    protected

    def column_heading_for(attribute)
      return attribute.values.first if attribute.is_a?(Hash)
      return attribute.to_s.humanize
    end

    def emit_html_heading
      result = "<thead><tr>"
      @attr.each do |attribute|
        result += "<th class='#{attribute_css_class(attribute)} #{attribute_type_css_class(attribute)}'>#{column_heading_for(attribute)}</th>"
      end
      result += "</tr></thead>"
    end

    def emit_html_rows(view_context, &block)
      result = "<tbody>"
      @records.each_with_index do |record,i|
        odd_even = i % 2 == 0 ? "#{@namespace}even" : "#{@namespace}odd"
        result += "<tr class='#{odd_even}'>"
        append_to_rows = block_given? ? view_context.capture(record, &block) : ''
        @attr.each do |attribute|
          message = attribute.is_a?(Hash) ? attribute.keys.first.to_sym : attribute.to_sym
          value = record.send(message).to_s
          result += "<td class='#{attribute_css_class(attribute)} #{attribute_type_css_class(attribute)}'>#{value}</td>"
        end
        result += append_to_rows
        result += "</tr>"
      end
      result += "</tbody>"
    end

    def attribute_css_class(attribute_name)
      "#{@namespace}#{attribute_name.to_s.parameterize.underscore}"
    end

    def attribute_type_css_class(attribute_name)
      column = @model.columns_hash[attribute_name.to_s]
      "#{@namespace}#{column.type.to_s.parameterize.underscore}" if column
    end

    def table_classes
      css_classes = @opts.fetch(:table_class, @config.table_class)
      ([] << css_classes << 'tablematic').flatten.join(' ')
    end
  end
end
