module ClockWindow
  module Refinements
    module AddIf
      refine Array do
        def add_if(expr)
          self.insert(-1, *Array(yield)) if expr
          self
        end
      end
    end
  end
end
