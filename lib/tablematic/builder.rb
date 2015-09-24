module TableHelper
  class TableBuilder
    extend Forwardable
    def_delegators :@view_context, :concat, :content_tag, :capture

    def initialize(records, attr, opts={})
      @records = records
      @attr = attr
      @model = @records.first.class
      @namespace = opts.fetch(:namespace,'')
      @config = Tablematic.configuration
      @opts = opts
    end

    def build(view_context, &block)
      @view_context = view_context
      content_tag(:table, class: table_classes) do
        emit_html_heading +
        emit_html_rows(&block)
      end.html_safe
    end

    protected

    def column_heading_for(attribute)
      return attribute.values.first if attribute.is_a?(Hash)
      return attribute.to_s.humanize
    end

    def emit_html_heading
      content_tag(:thead) do
        content_tag(:tr) do
          @attr.each do |attribute|
            css_classes = "#{attribute_css_class(attribute)} #{attribute_type_css_class(attribute)}"
            concat(content_tag(:th, column_heading_for(attribute), class: css_classes))
          end
        end
      end
    end

    def emit_html_rows(&block)
      content_tag(:tbody) do
        @records.each_with_index do |record,i|
          columns = ''
          @attr.each do |attribute|
            message = attribute.is_a?(Hash) ? attribute.keys.first.to_sym : attribute.to_sym
            value = record.send(message).to_s
            columns << content_tag(:td, value, class: "#{attribute_css_class(attribute)} #{attribute_type_css_class(attribute)}")
          end
          columns += capture(record, &block) if block_given?

          odd_even = i % 2 == 0 ? "#{@namespace}even" : "#{@namespace}odd"
          concat(content_tag(:tr, columns.html_safe, class: odd_even))
        end
      end
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
