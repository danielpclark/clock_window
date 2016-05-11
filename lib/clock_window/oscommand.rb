module ClockWindow
  class OScommand
    # As this will get more sophisticated this class is the Back End
    def initialize(**kwargs)
      @filter_opts = kwargs.fetch(:filter_opts) { {} }

      # Detect operating system
      @os = RbConfig::CONFIG['host_os']
    end

    # output will be a two parameter array
    # the first will be an OS specific executable string
    # the second will be formatting the return value from the executables output
    def active_window
      # Choose script to execute and format output to just window name
      case @os
      when /linux/i
        # Linux command to execute
        exe = "xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME"

        # Filters for resulting string
        format = Filters.new(
          matches: [ Regexp.new(/.*\"(.*)\"\n\z/) ].tap {|arr|
            arr.insert(-1, *@filter_opts.delete(:matches)) if @filter_opts.has_key? :matches
          },
          **@filter_opts
        )
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

        format = Filters.new(
          substitutions: [ [Regexp.new(/([^,]*)[, ]{1,3}(.*)/), '\2 - \1'] ].tap {|arr|
            arr.insert(-1, *Array(@filter_opts.delete(:substitutions))) if @filter_opts.has_key? :substitutions
          },
          **@filter_opts
        )
        [exe, format]
      else
        raise "Not implemented for #{@os}"
      end
    end
  end
  private_constant :OScommand
end
