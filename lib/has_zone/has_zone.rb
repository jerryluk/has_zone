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

      define_method(:set_utc_time_zone) do
        send "#{options[:with]}=".to_sym, "Etc/UTC" if send(options[:with]) == "UTC"
      end

      before_validation :set_utc_time_zone
      validates_inclusion_of options[:with], in: ::ActiveSupport::TimeZone.tzids_map.keys, allow_blank: true

    end
  end

end
