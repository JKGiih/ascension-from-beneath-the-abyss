graphics = {}

function graphics.initialize()
   screenWidth, screenHeight = 64, 48
   defaultWidth, defaultHeight = love.window.getDimensions()
   local full = false
   if love.filesystem.exists("config.cfg") then
      for line in love.filesystem.lines("config.cfg") do
         if string.find(line, "resolution") then
            defaultWidth, defaultHeight = string.match(line, "(%d+)%D+(%d+)")
            if defaultWidth / defaultHeight ~= 64 / 48 then
               defaultWidth = 64 * defaultHeight / 48
            end
            love.window.setMode(defaultWidth, defaultHeight)
         elseif string.find(line, "music") then
            if (string.find(line, "on") or string.find(line, "true")) then musicOn = true else musicOn = false end 
         elseif string.find(line, "sound") then
            if (string.find(line, "on") or string.find(line, "true")) then soundOn = true else soundOn = false end
         end
      end
   end
   graphics.calculateScale()
   canvasScale = 16
end

function graphics.toggleFullscreen()
   love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
   graphics.calculateScale()
end

function graphics.loadFonts()
   font1 = love.graphics.newFont("fonts/EBGaramond.ttf", 12 * scale)
   font2 = love.graphics.newFont("fonts/EBGaramond.ttf", 8 * scale)
end

function graphics.calculateScale()
   if love.window.getFullscreen() then
      scale = love.window.getHeight() / screenHeight
      widescreenOffset = (love.window.getWidth() / scale - screenWidth) / 2
   else
      scale = defaultHeight / screenHeight
      widescreenOffset = 0
   end
   halfScale = scale / 2
   graphics.loadFonts()
end

function graphics.lockToGrid(coordinate)
   local correction = coordinate % 1
   if correction < 0.5 then
      return coordinate - correction
   else
      return coordinate - correction + 1
   end 
end

function graphics.lockToGridRoundUp(coordinate)
   return coordinate - coordinate % 1
end
