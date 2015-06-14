config = {}

function config.load()
   if love.filesystem.exists("config.cfg") then
      for line in love.filesystem.lines("config.cfg") do
         if string.find(line, "resolution") then
            defaultWidth, defaultHeight = string.match(line, "(%d+)%D+(%d+)")
            if defaultWidth / defaultHeight ~= 64 / 48 then
               defaultWidth = 64 * defaultHeight / 48
            end
            love.window.setMode(defaultWidth, defaultHeight)
         elseif string.find(line, "music") then
            if string.find(line, "Volume") then
               musicVolume = string.match(line, "%d+") / 100
               if musicVolume < 0 or musicVolume > 1 then musicVolume = 0.75 end
            elseif (string.find(line, "on") or string.find(line, "true")) then musicOn = true else musicOn = false end 
         elseif string.find(line, "sound") then
            if string.find(line, "Volume") then
                soundVolume = string.match(line, "%d+") / 100
                if soundVolume < 0 or soundVolume > 1 then soundVolume = 0.75 end
            elseif (string.find(line, "on") or string.find(line, "true")) then soundOn = true else soundOn = false end
         end
      end
   end
end
