def super_print(to_print, options = {})
  defaults = {
    :times => 1,
    :upcase => false,
    :reverse => false
  }
  
  options = defaults.merge(options)
  
  to_print = to_print * options[:times]
  to_print = to_print.upcase if options[:upcase]
  to_print = to_print.reverse if options[:reverse]
  p to_print
end

super_print("Hello")                                    #=> "Hello"
super_print("Hello", :times => 3)                       #=> "Hello" 3x
super_print("Hello", :upcase => true)                   #=> "HELLO"
super_print("Hello", :upcase => true, :reverse => true) #=> "OLLEH"

options = {}
super_print("hello", options)
# options shouldn't change.


