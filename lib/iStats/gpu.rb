# GPU Stats
# Extend GPU_STATS C module (ext/osx_stats/smc.c)
#
module IStats
  class Gpu
    extend GPU_STATS
    class << self

      # Delegate CLI command to function
      #
      def delegate(stat)
        case stat
        when 'all'
          all
        when 'temp', 'temperature'
          gpu_temperature
        else
          Command.help "Unknown stat for GPU: #{stat}"
        end
      end

      # Call all functions (stats)
      #
      def all
        gpu_temperature
      end

      # Print GPU temperature with sparkline
      #
      def gpu_temperature
        t = get_gpu_temp
        thresholds = [50, 68, 80, 90]
        value, scale = Printer.parse_temperature(t)
        if Printer.get_temperature_scale == 'fahrenheit'
          thresholds.map! { |t| Utils.to_fahrenheit(t) }
        end
        Printer.print_item_line("GPU temp", value, scale, thresholds)
      end
    end
  end
end
