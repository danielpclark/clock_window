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

  class Filters
    def initialize(**kwargs)
      @title_range = kwargs.fetch(:title_range)   { 0..60 }
      @lazy_matchers = kwargs.fetch(:lazy_matchers) { true }

      # These are destructive matchers.  String will conform to match data.
      @matches = Array(kwargs.fetch(:matches)           { [] }) # [/(thing)/, /(in)/] # each match will be indexed to first match so use parenthesis
      @substitutions = Array(kwargs.fetch(:substitutions) { [] }) # [[//,'']]
    end

    def call(source)
      apply_filters(source)
    end

    private
    def apply_filters(target)
      target = matchers(target)
      @substitutions.each do |a,b|
        target = target.gsub(a,b)
      end
      target[@title_range]
    end

    def matchers(target)
      @matches.each do |fltr|
        if @lazy_matchers
          tmp = target.match( Regexp.new(fltr) )
          tmp = tmp[1] || tmp[0] if tmp.is_a? MatchData
          target = tmp || target 
        else
          target = target[Regexp.new(fltr)].to_s
        end
      end
      target
    end
  end

  class OScommand
    # As this will get more sophisticated this class is the Back End
    def initialize(**kwargs)
      @window_title_length = kwargs.fetch(:title_range) { 0..60 }

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
          title_range: @window_title_length,
          matches: [ Regexp.new(/.*\"(.*)\"\n\z/) ]
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
