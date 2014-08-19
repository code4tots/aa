require_relative '03_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    # if we place through_options inside the method as well,
    # we may declare belongs_to and has_one_through out of order
    # and still be ok.
    assoc_options = self.assoc_options
    
    define_method(name) do
      through_options = assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      # STDOUT.puts " ------------------------------------------ hello"
      # STDOUT.puts " #{self.inspect}"
      # STDOUT.puts " #{Human.all[0].inspect}"
      # STDOUT.puts " ------------------------------------------ hello"
      
      
      source_options.model_class.new(DBConnection.execute(<<-SQL)[0])
      SELECT  s.*
      FROM    #{source_options.table_name} s  /* table with our target */
      JOIN    #{through_options.table_name} t  /* join table -- not really see below */
      ON      t.#{source_options.foreign_key} = s.#{source_options.primary_key}
      WHERE   t.#{through_options.primary_key} = #{send(through_options.foreign_key)}
      LIMIT   1
      SQL
      
      #######################################
      # It looks as though "through" is not a join-table as I had first
      # thought. "self" carries an entry pointing to "through",
      # which is a surprise for me.
      # 
      # However, looking up guides.rubyonrails.org/association_basics.html
      # it looks as though this is how "has_one :through" works.
      # Huh...
      
    end
  end
end
