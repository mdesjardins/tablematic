# -*- coding: utf-8 -*-
require_relative './spec_helper'

describe 'TableBuilder' do
  with_model :Post do
    table do |t|
      t.string   "title"
      t.text     "content"
      t.string   "added_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  before do
    create_posts
    @view = ActionView::Base.new("app/views")
    @view.output_buffer = ""
  end

  it 'should render a table' do
    result = @view.table_for(Post.all)
    expect(result).to match /<table/
    expect(result).to match /<\/table>/
  end

  it 'should have the tablematic class by default' do
    result = @view.table_for(Post.all)
    expect(result).to match /class=["'].*tablematic.*["']>/
  end

  it 'should respect the table_class option as a string' do
    result = @view.table_for(Post.all, table_class: 'fooclass')
    expect(result).to match /class=["'].*fooclass.*["']/
  end

  it 'should respect the table_class option as an array' do
    result = @view.table_for(Post.all, table_class: ['fooclass', 'barclass'])
    expect(result).to match /class=["'].*fooclass.*barclass.*["']/
  end

  it 'should set odd/even on the rows' do
    result = @view.table_for(Post.all)
    expect(result).to match /.*<tbody><tr class=['"]even.*?<\/tr><tr class=['"]odd.*<\/tr/
  end

  it 'should set the attribute name as a class on the header' do
    result = @view.table_for(Post.all)
    expect(result).to match /.*<th class=['"]title.*<\/th/
    expect(result).to match /.*<th class=['"]content.*<\/th/
    expect(result).to match /.*<th class=['"]added_by.*<\/th/
    expect(result).to match /.*<th class=['"]created_at.*<\/th/
    expect(result).to match /.*<th class=['"]updated_at.*<\/th/
  end

  it 'should set the data type on the header' do
    result = @view.table_for(Post.all)
    expect(result).to match /.*<th class=['"].*?string.*?<\/th/
    expect(result).to match /.*<th class=['"].*?datetime.*?<\/th/
  end

  it 'should respect user overrides of headers to include' do
    result = @view.table_for(Post.all, attributes: [:title, :content])
    expect(result).to match /.*<th class=['"]title.*<\/th/
    expect(result).to match /.*<th class=['"]content.*<\/th/
    expect(result).not_to match /.*<th class=['"]added_by.*<\/th/
    expect(result).not_to match /.*<th class=['"]created_at.*<\/th/
    expect(result).not_to match /.*<th class=['"]updated_at.*<\/th/
  end

  it 'should allow the user to override the heading title' do
    result = @view.table_for(Post.all, attributes: [{title: 'Fooble'}, {content: 'Fobble'}])
    expect(result).to match /.*<th.*?Fooble<\/th/
    expect(result).to match /.*<th.*?Fobble<\/th/
    expect(result).not_to match /.*<th.*?Title<\/th/
    expect(result).not_to match /.*<th.*?Content<\/th/
  end

  it 'should allow extra stuff to be passed in as a block' do
    result = @view.table_for(Post.all) do
      "
      <td>Foo</td>
      <td>Bar</td>
      ".html_safe
    end
    expect(result).to match /<td>Foo<\/td>\s*?<td>Bar<\/td>\s*?<\/tr>/
  end
end

def create_posts
  Post.create(title: 'Elvis had a Twin', content: "On January 8, 1935, Elvis Aron (later spelled Aaron) Presley was born at his parents' two-room house in East Tupelo, Mississippi, about 35 minutes after his identical twin brother, Jesse Garon, who was stillborn.", added_by: 'Lisa Marie')
  Post.create(title: 'Graceland', content: 'In 1957, when he was just 22, Elvis shelled out $102,500 for Graceland, the Memphis mansion that served as his home base for two decades.', added_by: 'Priscilla')
  Post.create(title: 'Col. Tom Barker', content: "Elvis's future manager immigrated illegally to America as a young man, where he reinvented himself as Tom Parker and claimed to be from West Virginia. He worked as a pitchman for traveling carnivals, followed by stints as dog catcher and pet cemetery founder, among other occupations, then managed the careers of several country music singers.", added_by: 'Elvis Himself')
  Post.create(title: 'Military Service', content: "In December 1957, Elvis, by then a major star, was drafted into the U.S. military. After receiving a short deferment so he could wrap up production on his film 'King Creole,' the 23-year-old was inducted into the Army as a private on March 24, 1958, amidst major media coverage.", added_by: 'Adoring Fan')
  Post.create(title: 'North America', content: "An estimated 40 percent of Elvis' music sales have been outside the United States; however, with the exception a handful of concerts he gave in Canada in 1957, he never performed on foreign soil.", added_by: 'Tom Barker')
  Post.create(title: "FDR's yacht", content: "In 1964, Elvis paid $55,000 for the Potomac, the 165-foot-long vessel that served as FDR's 'floating White House' from 1936 to 1945.", added_by: 'Eleanor Roosevelt')
  Post.create(title: 'Amazing Hair', content: "Elvis' famous black hair was dyed - his natural color was brown.", added_by: "Mike")
  Post.create(title: 'Elvis the Pelvis', content: "When performing on TV in 1956, host Milton Berle advised Elvis to perform without his guitar, reportedly saying, 'Let em see you, son.'  Elvis' gyrating hips caused outrage across the U.S. and within days he was nicknamed Elvis the Pelvis.", added_by: "Milton Berle")
  Post.create(title: 'Famous relatives', content: "Elvis was distantly related to former U.S. Presidents Abraham Lincoln and Jimmy Carter.", added_by: 'Thomas Jefferson, probably')
  Post.create(title: 'Not a songwriter', content: "Elvis recorded more than 600 songs, but did not write any of them.", added_by: "A jaded songwriter")
end
