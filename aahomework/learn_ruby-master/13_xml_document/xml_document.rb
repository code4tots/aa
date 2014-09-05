class XmlDocument
  def initialize indent = false
    @indent = indent
  end
  
  def method_missing meth, options={}, &block
    '<' + meth.to_s + options.collect{|k,v|" #{k}='#{v}'"}.join('') + if block == nil
      # No block was given. Self closing tag.
      '/'
    else
      # Nested. Fill inside with what block returns.
      '>' + (@indent ? "\n" : '') + block.call.gsub(/^/,(@indent ? "  " : '')) + '</' + meth.to_s
    end + '>' + (@indent ? "\n" : '')
  end
end
