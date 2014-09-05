
def measure n = 1
  times = []
  n.times do
    start = Time.now
    yield
    finish = Time.now
    times.push(finish-start)
  end
  times.inject(&:+) / times.size
end

