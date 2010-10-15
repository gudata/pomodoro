#!/usr/bin/env ruby
require 'optparse'

class Mplayer
  def self.play_file(file)
    run = "mplayer #{file} -ao sdl -vo x11 -framedrop -cache 16384 -cache-min 20/100 -really-quiet"
    system(run)
  end
end

class Pomodoro
  WORK = {:kind => :work, :time  => 25, :message => "Work", :sound_before => "startup1.wav"}
  BREAK = {:kind => :break, :time => 5, :message => "Have a break", :sound_before => "break.wav"}
  BIG_BREAK = {:kind => :big_break, :time => 15, :message => "Have a BIIIIIIG break", :sound_before => "big_break.wav"}

  WORK_CYCLES_PER_DAY = 16


  def initialize options
   @options = options
   work_cycle = []
   4.times{work_cycle << WORK <<  BREAK}
   work_cycle << BIG_BREAK

   @work_day = []
   WORK_CYCLES_PER_DAY.times{ @work_day << work_cycle}
   @work_day.flatten!
   @current = 0
   
   @work_day.shift if options[:break]
  end


  def run
    @work_day.each do |interval|
      if interval[:sound_before]
        mp3 = File.join(File.dirname(__FILE__), "sounds", interval[:sound_before])
        Mplayer.play_file(mp3)
      end

      now = Time.now
      alarm_at = now + interval[:time]*60
      puts "#{interval[:message]} till #{alarm_at}"
      sleep(interval[:time]*60);

      if interval[:sound_after]
        mp3 = File.join(File.dirname(__FILE__), "sounds", interval[:sound_after])
        Mplayer.play_file(mp3)
      end
    end
  end

end

options = {}

optparse = OptionParser.new do|opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: start_timer.rb [options]"
 
   # Define the options, and what they do
   options[:break] = false
   opts.on('-b', '--break', 'Start with a break' ) do
     options[:break] = true
   end

   options[:big_break] = false
   opts.on('-B', '--big_break', 'Start with the big break (not supported)' ) do
     options[:break] = true
   end
 
   opts.on('-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
 end
 
optparse.parse!
 
Pomodoro.new(options).run
