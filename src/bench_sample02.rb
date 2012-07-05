## gem install rbench
require 'rbench'

# Choose how many times you want to repeat each benchmark.
# This can be overridden on specific reports, if needed.
TIMES = 100_000

# Now onto a benchmark that utilizes a some more stiff.
RBench.run(TIMES) do

  format :width => 65

  column :times
  column :one,  :title => "#1"
  column :two,  :title => "#2"
  column :diff, :title => "#1/#2", :compare => [:one,:two]

  group "Squeezing" do
    report "with #squeeze" do
      one { "abc//def//ghi//jkl".squeeze("/") }
      two { "abc///def///ghi///jkl".squeeze("/") }
    end
    report "with #gsub" do
      one { "abc//def//ghi//jkl".gsub(/\/+/, "/") }
      two { "abc///def///ghi///jkl".gsub(/\/+/, "/") }
    end
    
    summary "all methods (totals)"
  end
 
  group "Splitting" do
    report "with #split" do
      one { "aaa/aaa/aaa.bbb.ccc.ddd".split(".") }
      two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".split(".") }
    end
    report "with #match", TIMES / 100 do
      one { "aaa/aaa/aaa.bbb.ccc.ddd".match(/\.([^\.]*)$/) }
      two { "aaa//aaa//aaa.bbb.ccc.ddd.eee".match(/\.([^\.]*)$/) }
    end
  end
  
end
