require 'test_helper'

class ClockWindow::FiltersTest < Minitest::Test
  describe "Active Window Filters Test" do
    it "chops off Twitter notifications" do
      mac = ClockWindow::ClockIt.new(filter_opts: {no_notify: true}).instance_eval { @os_cmd }
      mac.instance_eval { @os = "darwin" }
      _, format = mac.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "Twitter - Firefox"

      linux = ClockWindow::ClockIt.new(filter_opts: {no_notify: true}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "Twitter - Firefox"
    end

    it "tests additional filters and substitutions" do
      mac = ClockWindow::ClockIt.new(filter_opts: {substitutions: [[/wit/,'zzz']]}).instance_eval { @os_cmd }
      mac.instance_eval { @os = "darwin" }
      _, format = mac.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "(1337) Tzzzter - Firefox"

      linux = ClockWindow::ClockIt.new(filter_opts: {matches: [/\A.../]}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "(13"

      linux = ClockWindow::ClockIt.new(filter_opts: {matches: [/(Firefox)/, /(Fire)/]}).instance_eval { @os_cmd }
      linux.instance_eval { @os = "linux-gnu" }
      _, format = linux.active_window
      _(format.call("(1337) Twitter - Firefox")).must_equal "Fire"
    end

    it "filters a custom range" do
      osc = ClockWindow::ClockIt.new(filter_opts: {title_range: 0..4}).instance_eval { @os_cmd }
      osc.instance_eval { @os = "linux-gnu" }
      _(osc.active_window.last.call("1234567890")).must_equal "12345"
    end
  end
end
