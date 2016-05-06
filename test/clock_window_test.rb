require 'test_helper'

class ClockWindowTest < Minitest::Test
  describe "Active Window Test" do
    it "is not empty" do
      _(ClockWindow::ClockIt.new.active_window).wont_be :empty?
    end
  end
end
