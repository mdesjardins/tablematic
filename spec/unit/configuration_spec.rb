# -*- coding: utf-8 -*-
require_relative './spec_helper'

describe 'Configuration' do
  it 'should set exclude' do
    Tablematic.configure do |config|
      config.exclude = [:created_at]
    end
    expect(Tablematic.configuration.exclude).to eq([:created_at])
  end

  it 'should set table_class' do
    Tablematic.configure do |config|
      config.table_class = 'table table-condensed'
    end
    expect(Tablematic.configuration.table_class).to eq('table table-condensed')
  end
end
