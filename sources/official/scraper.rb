#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      tds[1].text.tidy
    end

    def position
      return "State Minister: #{portfolio}" if section.include? 'State Minister'
      return ['Prime Minister'] + portfolio.split(', ').map { |posn| "Minister of #{posn}" } if section.include? 'Prime Minister'
      return "Minister of #{portfolio}" if section == 'Hon’ble Minister'

      raise "Unknown section (#{section}) for #{portfolio}"
    end

    private

    def tds
      noko.css('td')
    end

    def portfolio
      tds[2].text.tidy
    end

    def section
      noko.xpath('preceding-sibling::tr[not(.//a)]').last.text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.wpb_wrapper table').xpath('.//tr[.//a]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
