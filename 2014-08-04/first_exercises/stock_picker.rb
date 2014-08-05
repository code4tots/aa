def stock_picker prices
  n = prices.size
  (0...n).map do |buy|
    ((buy + 1)...n).map do |sell|
      [[buy, sell], prices[sell] - prices[buy]]
    end
  end.flat_map{|i| i }.max_by{|range, cost| cost}[0]
end
