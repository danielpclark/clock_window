module ClockWindow
  class Filters
    def initialize(**kwargs)
      @title_range = kwargs.fetch(:title_range)     { 0..60 }
      @lazy_matchers = kwargs.fetch(:lazy_matchers) { true  }
      @no_notify = kwargs.fetch(:no_notify)         { false }

      # These are destructive matchers.  String will conform to match data.
      @matches = Array(kwargs.fetch(:matches)           { [] }) # [/(thing)/, /(in)/] # parenthesis takes priority
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
      target = no_notify(target)
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

    def no_notify(target)
      # Remove Twitter notifications (must be last)
      # Other sites may follow same notification pattern
      target = target.gsub(Regexp.new(/\A ?\(\d+\) ?/), '') if @no_notify
      target
    end
  end

end
