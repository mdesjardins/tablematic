# Tablematic

## Introduction
There are a bunch of other Rails table generators out there. This is mine.

Tabletastic is a gem to help quickly emit tabular data in a Rails web
view. I created it because 1) I found myself doing this all the time, and
it seemed like I could make it generic and package it as a gem, and 2)
companies always want to see open source code samples when you apply
for jobs, so it made sense to create some!

## Installation
(Eventually, when I put this on rubygems) in your Rails project, Gemfile:
  gem "tablematic"

## Usage
The simplest use of tablematic is to invoke the helper method with a
variable that contains a collection of ActiveRecord objects, thusly:

```erb
<%= table_for(@posts) %>
```

Let's say you have a table named posts, and it contains the following
data:


|id |created_at|updated_at|added_by     |title          |content|
|---|----------|----------|-------------|---------------|-------|
|  1|2015-08-06|2015-08-06|Lisa Marie   |Elvis had a Twin|On January 8, 1935, Elvis Aron (later spelled Aaron) Presley was born at his parents' two-room house in East Tupelo, Mississippi, about 35 minutes after his identical twin brother, Jesse Garon, who was stillborn.|
|  2|2015-08-06|2015-08-06|Priscilla    |Graceland       |In 1957, when he was just 22, Elvis shelled out $102,500 for Graceland, the Memphis mansion that served as his home base for two decades.|
|  3|2015-08-06|2015-08-06|Elvis Himself|Col. Tom Barker |Elvis's future manager immigrated illegally to America as a young man, where he reinvented himself as Tom Parker and claimed to be from West Virginia. He worked as a pitchman for traveling carnivals, followed by stints as dog catcher and pet cemetery founder, among other occupations, then managed the careers of several country music singers.|

_Note: Check the unit tests for more Elvis Facts(tm)_

Calling table_for on the table above would generate a table that looks like this:

```html
<table class=' tablematic'>
  <thead>
    <tr>
      <th class='id integer'>Id</th>
      <th class='created_at datetime'>Created at</th>
      <th class='updated_at datetime'>Updated at</th>
      <th class='added_by string'>Added by</th>
      <th class='title string'>Title</th>
      <th class='content text'>Content</th>
    </tr>
  </thead>
  <tbody>
    <tr class='even'>
      <td class='id integer'>1</td>
      <td class='created_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='updated_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='added_by string'>Lisa Marie</td>
      <td class='title string'>Elvis had a Twin</td>
      <td class='content text'>On January 8, 1935, Elvis Aron (later spelled Aaron) Presley was born at his parents’ two-room house in East Tupelo, Mississippi, about 35 minutes after his identical twin brother, Jesse Garon, who was stillborn.</td>
    </tr>
    <tr class='odd'>
      <td class='id integer'>2</td>
      <td class='created_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='updated_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='added_by string'>Priscilla</td>
      <td class='title string'>Graceland</td>
      <td class='content text'>In 1957, when he was just 22, Elvis shelled out $102,500 for Graceland, the Memphis mansion that served as his home base for two decades.</td>
    </tr>
    <tr class='even'>
      <td class='id integer'>3</td>
      <td class='created_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='updated_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='added_by string'>Elvis Himself</td>
      <td class='title string'>Col. Tom Barker</td>
      <td class='content text'>Elvis’s future manager immigrated illegally to America as a young man, where he reinvented himself as Tom Parker and claimed to be from West Virginia. He worked as a pitchman for traveling carnivals, followed by stints as dog catcher and pet cemetery founder, among other occupations, then managed the careers of several country music singers.</td>
    </tr>
  </tbody>
</table>
```

Interesting stuff above:
* It auto-generates odd/even classes on the rows in case you want to use them for styling
* It also includes the parameter name and datatype on each column in case that's useful for styling (e.g., you might want to make integers align right).
* Tables have the tablematic class by default.

### Customizing output
The defaults are probably not exactly what you need, so you can tweak things as needed by
supplying options in an hash as the second parameter to table_for. Here are some of the
supported options:

#### table_class:
A string or array of strings to use as class name(s) on the table. This is handy if you're
using a CSS framework like bootstrap:

```erb
<%= table_for(@posts, table_class: 'table table-condensed') %>
```

yields

```html
<table class="tablematic table table-condensed">
...
```

#### attributes:
Limits the output to only those attributes included in the array. E.g.,

```erb
<%= table_for(@posts, attributes: [:title, :content]) %>
```

You can also specify the column header names this way by making the
array elements into hashes where the key is the attribute name and
the value is the title:

```erb
<%= table_for(@posts, attributes: [{title: 'A cool title'}, {content: 'Awesome content'}]) %>
```

### Code Blocks for additional per-row output
Let's say you want to include links to Edit or Delete actions on each row along
with the table values. Anything that is supplied in a block to the table_for
method will be appended to the end of each row that is generated. For example,

```erb
<% table_for(@posts) do |post| %>
  <td><%= link_to "Edit", edit_post_path(post) %></td>
<% end %>
```

will generate the following:

```html
<table class=' tablematic'>
  <thead>
    <tr>
      <th class='id integer'>Id</th>
      <th class='created_at datetime'>Created at</th>
      <th class='updated_at datetime'>Updated at</th>
      <th class='added_by string'>Added by</th>
      <th class='title string'>Title</th>
      <th class='content text'>Content</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr class='even'>
      <td class='id integer'>1</td>
      <td class='created_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='updated_at datetime'>2015-08-06 12:04:05 UTC</td>
      <td class='added_by string'>Lisa Marie</td>
      <td class='title string'>Elvis had a Twin</td>
      <td class='content text'>On January 8, 1935, Elvis Aron (later spelled Aaron) Presley was born at his parents’ two-room house in East Tupelo, Mississippi, about 35 minutes after his identical twin brother, Jesse Garon, who was stillborn.</td>
      <td><a href="/posts/1/edit">Edit</a></td>
    </tr>
...
```

### Global Configuration
Right now there's only one option you can configure globally - I'm working
on that. Here's how you do it - in an initializer, plop the following code:

```ruby
Tablematic.configure do |config|
  config.table_class = 'table table-condensed'    
end
```

This will make the default CSS classes on every generated table include the
table and table-condensed classes, so you don't have to specify it explicitly
everywhere you use the helper.

## TODO
* Change string additions to use << instead because string addition is expensive (or better yet use content_tag).
* Setup TravisCI.
* An exclude option to easily exclude columns, including at the global level.
* Integration specs for better testing w/ Rails.
* A way to specify that generate class names should use hyphens instead of underscores.
* Configurable class namespaces, some of that stuff is already there just haven't finished it.
* Make it work w/ regular old arrays of hashes as well as AR.
* Maybe it'd be cool to have optional footers with totals? Might be wonky w/ pagination.
* A way to specify column headings when you're including additional stuff in a block.

## Note on Patches/Pull Requests
* Fork the project.
* Make your feature addition or bug fix.
* Add specs for it.
* Commit.
* Send me a pull request. Bonus points for topic branches.

## Copyright
Copyright 2015 Mike Desjardins. See MIT-LICENSE for details.
