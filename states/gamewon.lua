gamewon = {}

function gamewon.initialize()
   if soundAvailable then
      -- stop any looping sound effects
   end
   alpha2 = 1
end

function gamewon.update(dt)
   alpha2 = alpha2 + dt * (dt + 6)
   if alpha2 > 255 then alpha2 = 255 end
end

function gamewon.draw()
   game.draw()
   local setFont = love.graphics.setFont
   local setColor = love.graphics.setColor
   local print = love.graphics.print
   setFont(font2)
   setColor(64, 64, 64, alpha2)
   print("You have", (widescreenOffset + 4) * scale, 3 * scale)
   setFont(font1)
   setColor(192, 192, 192, alpha2)
   print("ascended", (widescreenOffset + 12) * scale, 9 * scale)
   setFont(font2)
   setColor(128, 128, 128, alpha2)
   print("from beneath", (widescreenOffset + 8) * scale, 23 * scale)
   setFont(font1)
   setColor(192, 192, 192, alpha2)
   print("the Abyss", (widescreenOffset + 16) * scale, 32 * scale)
end

function gamewon.gamepadpressed(joystick, button)
   if button == "a" or button == "start" or button == "back" then
      splash.initialize()
      state = "splash"
   end
end

function gamewon.keypressed(key)
   if key == "return" or key == " " or key == "escape" then
      splash.initialize()
      state = "splash"
   elseif key == "f11" then
      graphics.toggleFullscreen()
   end
end
