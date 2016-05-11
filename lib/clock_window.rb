require "clock_window/version"

module ClockWindow
  class ClockIt
    # As this will get more sophisticated this class is the UI
    def initialize
      @os_cmd = OScommand.new
    end

    def active_window
      exe, format = @os_cmd.active_window
      format.call(`#{exe}`)
    end
  end

  class OScommand
    # As this will get more sophisticated this class is the Back End
    def initialize
      # Detect operating system
      @os = RbConfig::CONFIG['host_os']
      @window_title_length = 0..60
    end

    # output will be a two parameter array
    # the first will be an OS specific executable string
    # the second will be formatting the return value from the executables output
    def active_window
      # Choose script to execute and format output to just window name
      case @os
      when /linux/i
        exe = "xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME"
        format = ->str{ str.match(/.*\"(.*)\"\n\z/)[1][@window_title_length] }
        [exe, format]
      when /darwin/i
        exe = <<-SCRIPT
          osascript -e '
            global frontApp, frontAppName, windowTitle

            set windowTitle to ""
            tell application "System Events"
              set frontApp to first application process whose frontmost is true
              set frontAppName to name of frontApp
              tell process frontAppName
                  tell (1st window whose value of attribute "AXMain" is true)
                      set windowTitle to value of attribute "AXTitle"
                  end tell
              end tell
            end tell

            return {frontAppName, windowTitle}
          '
        SCRIPT

        format = ->str {
          app, window = str.split(',')
          "#{window.strip} - #{app.strip}"[@window_title_length]
        }
        [exe, format]
      else
        raise "Not implemented for #{@os}"
      end
    end
  end
  private_constant :OScommand
end
