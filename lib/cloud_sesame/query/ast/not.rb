module CloudSesame
  module Query
    module AST
      class Not < SingleBranch

      	def compile
				"(not #{ child.compile })"
      	end

      end
    end
  end
end
