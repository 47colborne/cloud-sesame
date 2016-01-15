module CloudSesame
	module Query
		module DSL
			module Value

				# VALUE DSL
        # =======================================

				# DATE
        # =======================================
				def date(date)
					AST::DateValue.new date
				end

				alias_method :d, :date

        # RANGE
        # =======================================
				def range(range = nil)
					AST::RangeValue.new range
				end

				alias_method :r, :range

			end
		end
	end
end
