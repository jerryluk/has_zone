require 'tzinfo'

module TZInfoExtension
  module ClassMethods
    def abbreviations_map
      @abbreviations_map ||= begin
        (abbreviations_map = {}).tap do |am|
          all.each do |tz|
            tz.abbreviations.each do |abb|
              if am[abb].present?
                am[abb] << tz
              else
                am[abb] = [tz]
              end
            end
          end
        end
      end
    end
  end
  module InstanceMethods
    def next_period(period)
      period_end = period.utc_end
      period_end ? period_for_utc(period_end + 1.day) : nil
    end

    def abbreviations
      date = Time.now.utc.beginning_of_year
      abbreviations = []
      period = period_for_local(date)
      while not(abbreviations.include? period.abbreviation)
        abbreviations << period.abbreviation
        break unless (period = next_period(period))
      end
      abbreviations
    end
  end
end

class TZInfo::Timezone
  extend TZInfoExtension::ClassMethods
  include TZInfoExtension::InstanceMethods
end

class ActiveSupport::TimeZone
  extend TZInfoExtension::ClassMethods
  include TZInfoExtension::InstanceMethods

  def self.tzids_map
    @tzids_map ||= begin
      (tzids_map = {}).tap do |tm|
        zones_map.each_pair { |n, z| tm[z.identifier] ||= z }
      end
    end
  end

  def identifier
    self.tzinfo.try(:identifier)
  end
end
