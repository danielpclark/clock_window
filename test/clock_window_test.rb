require 'test_helper'

class ClockWindowTest < Minitest::Test
  describe "Active Window Test" do
    let(:linux) {
      osc = ClockWindow::ClockIt.new.instance_eval { @os_cmd }
      osc.instance_eval { @os = "linux-gnu" }; osc
    }

    let(:linux_no_notify) {
        }

    let(:mac) {
      osc = ClockWindow::ClockIt.new.instance_eval { @os_cmd }
      osc.instance_eval { @os = "darwin" }; osc
    }

    it "is not empty" do
      _(ClockWindow::ClockIt.new.active_window).wont_be :empty?
    end

    it "returns the correct string for the Linux OS" do
      exe, format = linux.active_window
      _(exe).must_equal "xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME"
      _(format.call("_NET_WM_NAME(UTF8_STRING) = \"user@computer: ~\"\n")).must_equal "user@computer: ~"
    end

    it "formats correctly for Mac OS" do
      _, format = mac.active_window
      _(format.call("Firefox, (1337) Twitter")).must_equal "(1337) Twitter - Firefox"
    end

    it "chops off Twitter notifications" do
      mac = ClockWindow::ClockIt.new(filter_opts: {no_notify: true}).instance_eval { @os_cmd }
      mac.instance_eval { @os = "darwin" }
      _, format = mac.active_window
      _(format.call("Firefox, (1337) Twitter")).must_equal "Twitter - Firefox"

      linux = ClockWindow::ClockIt.new(filter_opts: {no_notify: true}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "Twitter - Firefox"
    end

    it "tests additional filters and substitutions" do
      mac = ClockWindow::ClockIt.new(filter_opts: {substitutions: [[/wit/,'zzz']]}).instance_eval { @os_cmd }
      mac.instance_eval { @os = "darwin" }
      _, format = mac.active_window
      _(format.call("Firefox, (1337) Twitter")).must_equal "(1337) Tzzzter - Firefox"

      linux = ClockWindow::ClockIt.new(filter_opts: {matches: [/\A.../]}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "(13"

      linux = ClockWindow::ClockIt.new(filter_opts: {matches: [/(Firefox)/, /(Fire)/]}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "Fire"
    end
  end
end
