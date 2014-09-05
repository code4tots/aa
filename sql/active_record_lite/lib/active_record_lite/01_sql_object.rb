require_relative 'db_connection'
require 'active_support/inflector'
#NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
#    of this project. It was only a warm up.

class SQLObject
  
  def self.columns
    DBConnection.execute2("SELECT * FROM #{table_name}")[0].
    map { |name| name.intern }
  end

  def self.finalize!
    # take advantage of closures ...
    columns.each do |name|
      define_method(name) do
        @attributes[name]
      end
      define_method(name.to_s+'=') do |val|
        @attributes[name] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name.nil?
      @table_name = self.name.tableize
    end
    @table_name
  end

  def self.all
    parse_all(DBConnection.execute(<<-SQL)
    SELECT *
    FROM   #{table_name}
    SQL
    )
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    new(DBConnection.execute(<<-SQL, id)[0])
    SELECT  *
    FROM    #{table_name}
    WHERE   id = ?
    SQL
  end

  def attributes
    @attributes
  end

  def insert
    @attributes[:id] = DBConnection.last_insert_row_id if id.nil?
    
    col_names = self.class.columns.join(', ')
    question_marks = (['?'] * self.class.columns.size).join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO #{self.class.table_name} (#{col_names})
    VALUES      (#{question_marks})
    SQL
  end

  def initialize(options={})
    unknown_keys = options.keys.map(&:intern) - self.class.columns
    unless unknown_keys.empty?
      raise "unknown attribute '#{unknown_keys.pop}'"
    end
    @attributes = Hash.new
    options.each do |key, val|
      @attributes[key.intern] = val
    end
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end

  def update
    question_marks = self.class.columns.map do |name|
      "#{name} = ?"
    end.join(', ')
    
    DBConnection.execute(<<-SQL, *(attribute_values << id))
    UPDATE #{self.class.table_name}
    SET    #{question_marks}
    WHERE  id = ?
    SQL
  end

  def attribute_values
    self.class.columns.map { |name| send(name) }
  end
end
