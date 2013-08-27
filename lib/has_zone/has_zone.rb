module HasZone
  extend ActiveSupport::Concern

  included do

    # This allows the model has the ability to store TimeZone.
    # Usage:
    # has_zone with: :time_zone
    #
    # It defines the following methods:
    #
    # :zone
    # Public: Returns the Rails Time Zone.
    #
    #
    # :zone=(identifier)
    # Public: Sets the TimeZone by TZinfo identifier.
    #
    # identifier - Time Zone identifier
    #
    def self.has_zone(options = { with: :time_zone })
      define_method(:zone) do
        return nil if send(options[:with]).nil?
        @zone ||= ::ActiveSupport::TimeZone.tzids_map[send(options[:with])].try(:name)
      end

      define_method(:zone=) do |tz|
        zone = tz.is_a?(String) ? ::ActiveSupport::TimeZone.new(tz) : tz
        send "#{options[:with]}=".to_sym, zone.try(:identifier)
      end

      define_method("#{options[:with]}=".to_sym) do |tz|
        # Since we memoize the time zone, we need to reset it if the time zone has changed
        @zone = nil
        write_attribute(options[:with], tz)
      end

      define_method(:alias_time_zone) do
        if send(options[:with]) == "UTC"
          send "#{options[:with]}=".to_sym, "Etc/UTC"
        elsif ::ActiveSupport::TimeZone.tzids_map.keys.exclude? send(options[:with])
          Rails.logger.warn("Time zone #{send(options[:with])} is not a valid time zone.") if defined? Rails
        end
      end

      before_validation :alias_time_zone

    end
  end

end
