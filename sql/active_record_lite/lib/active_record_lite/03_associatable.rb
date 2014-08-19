require_relative '02_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    table_name.singularize.camelcase.constantize
  end

  def table_name
    name = @name.underscore
    # handle special weird case ....
    if name == 'human'
      'humans'
    else
      name.pluralize
    end
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    name = name.to_s
    @name = name
    {
      foreign_key: (name + '_id').intern,
      class_name:  name.camelcase,
      primary_key: :id
    }.merge(options).each do |key, val|
      instance_variable_set('@'+key.to_s, val)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s
    @name = name
    @self_class_name = self_class_name
    {
      foreign_key: (self_class_name.underscore + '_id').intern,
      class_name:  name.singularize.camelcase,
      primary_key: :id
    }.merge(options).each do |key, val|
      instance_variable_set('@'+key.to_s, val)
    end
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    
    define_method(name) do
      options.class_name.constantize.new(DBConnection.execute(<<-SQL)[0])
      SELECT *
      FROM   #{options.table_name}
      WHERE  #{options.primary_key} = #{send(options.foreign_key)}
      SQL
    end
    
    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)
    
    define_method(name) do
      options.class_name.constantize.parse_all(DBConnection.execute(<<-SQL))
      SELECT *
      FROM   #{options.table_name}
      WHERE  #{options.foreign_key} = #{send(options.primary_key)}
      SQL
    end
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
    @assoc_options = Hash.new if @assoc_options.nil?
    @assoc_options
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end


