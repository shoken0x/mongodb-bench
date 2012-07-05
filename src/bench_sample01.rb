## gem install rbench
require 'rbench'

# Choose how many times you want to repeat each benchmark.
# This can be overridden on specific reports, if needed.
TIMES = 100_000

# A relatively simple benchmark:
RBench.run(TIMES) do
  
  column :one
  column :two

  report "Squeezing with #squeeze" do
    one { "abc//def//ghi//jkl".squeeze("/") }
    two { "abc///def///ghi///jkl".squeeze("/") }
  end

  report "Squeezing with #gsub" do
    one { "abc//def//ghi//jkl".gsub(/\/+/, "/") }
    two { "abc///def///ghi///jkl".gsub(/\/+/, "/") }
  end

  report "Splitting with #split" do
    one { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
    two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
  end

  report "Splitting with #match" do
    one { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
    two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
  end
  
end 
