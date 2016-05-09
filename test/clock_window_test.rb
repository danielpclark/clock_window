require 'test_helper'

class ClockWindowTest < Minitest::Test
  describe "Active Window Test" do
    let(:linux) {
      osc = ClockWindow::ClockIt.new.instance_eval { @os_cmd }
      osc.instance_eval { @os = "linux-gnu" }
      osc
    }
    it "is not empty" do
      _(ClockWindow::ClockIt.new.active_window).wont_be :empty?
    end

    it "returns the correct string for the Linux OS" do
      exe, format = linux.active_window
      _(exe).must_equal "xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME"
      _(format.call("_NET_WM_NAME(UTF8_STRING) = \"user@computer: ~\"\n")).must_equal "user@computer: ~"
    end
  end
end
