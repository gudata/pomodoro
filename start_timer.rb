#!/usr/bin/env ruby

class Mplayer
  def self.play_file(file)
    run = "mplayer #{file} -ao sdl -vo x11 -framedrop -cache 16384 -cache-min 20/100 -really-quiet"
    system(run)
  end
end

class Pomodore
  WORK = {:kind => :work, :time  => 25, :message => "Work", :sound_before => "startup1.wav"}
  BREAK = {:kind => :break, :time => 5, :message => "Have a break", :sound_after => "break.wav"}
  BIG_BREAK = {:kind => :big_break, :time => 15, :message => "Have a BIIIIIIG break", :sound_after => "big_break.wav"}

  WORK_CYCLES_PER_DAY = 16


  def initialize
   work_cycle = []
   4.times{work_cycle << WORK <<  BREAK}
   work_cycle << BIG_BREAK

   @work_day = []
   WORK_CYCLES_PER_DAY.times{ @work_day << work_cycle}
   @work_day.flatten!
   @current = 0
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
      sleep(25*60);

      if interval[:sound_after]
        mp3 = File.join(File.dirname(__FILE__), "sounds", interval[:sound_after])
        Mplayer.play_file(mp3)
      end
    end
  end

end

Pomodore.new.run
