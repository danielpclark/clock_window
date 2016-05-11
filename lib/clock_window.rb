require "clock_window/version"
require "clock_window/refinements"
require "clock_window/filters"
require "clock_window/oscommand"

module ClockWindow
  class ClockIt
    # As this will get more sophisticated this class is the UI
    def initialize(**kwargs)
      @os_cmd = OScommand.new(**kwargs)
    end

    def active_window
      exe, format = @os_cmd.active_window
      format.call(`#{exe}`)
    end
  end
end
