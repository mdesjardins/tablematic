class Configuration
  attr_accessor :exclude, :table_class

  def initialize
    @exclude = []
    @table_class = ''
  end
end
