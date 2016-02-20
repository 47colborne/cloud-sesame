require 'ruby-prof'
require 'benchmark'

module BenchmarkHelper

	def profile(n, &block)
		result = RubyProf.profile { n.times(&block) }
		printer = RubyProf::FlatPrinter.new(result)
		printer.print(STDOUT, {})
	end

end
