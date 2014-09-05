require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # I am paranoid about the ordering of params.values.
    # So I collect the values as I iterate through
    # params the first time.
    values = []
    question_marks = params.map do |key, value|
      values << value
      "#{key} = ?"
    end.join(' AND ')
    parse_all(DBConnection.execute(<<-SQL, *values)
    SELECT *
    FROM   #{table_name}
    WHERE  #{question_marks}
    SQL
    )
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
