#/usr/bin/env ruby -W
require 'net/http'
require 'Date'

class CruiseStatCollector

  def build_list
    body = String.new
    Net::HTTP.start('medhq-devbox-2', '8880') do | http |
      body = (http.get('/buildresults/Alineo').body)
    end

    build_list = Array.new
    body.each do | line |
      if line.match("<option value=\"log[0-9]{14}.+")
        build_list.insert(0, line)
      end
    end
    return build_list
  end

  def collect_stats(days_back)
    passed, failed = Array.new, Array.new
    start_date = Date.today - days_back

    build_list().each do | result |
      build_date = result.match('\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}')[0]
      if DateTime.parse(build_date) < start_date
        next
      end

      if result.match("\(build\.[0-9]+\)")
        passed.insert(-1, result)
      else
        failed.insert(-1, result)
      end
    end

    puts "#{passed.size} passed."
    puts "#{failed.size} failed."
    percentage_passed = (passed.size.to_f / (passed.size.to_f + failed.size.to_f)) * 100.0
    puts "#{percentage_passed.round}% of builds passed for last #{days_back} days."
  end
end

CruiseStatCollector.new.collect_stats(ARGV[0].to_i)
