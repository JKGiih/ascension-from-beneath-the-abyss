gameover = {}

function gameover.initialize()
   if soundAvailable then
      audio.stopEffect(sf1)
   end
   alpha2 = 1
end

function gameover.update(dt)
   alpha2 = alpha2 + dt * (dt + 6)
   if alpha2 > 255 then alpha2 = 255 end
end

function gameover.draw()
   game.draw()
   local setFont = love.graphics.setFont
   local setColor = love.graphics.setColor
   local print = love.graphics.print
   setFont(font1)
   setColor(64, 64, 64, alpha2)
   print("You remain", (widescreenOffset + 6) * scale, 5 * scale)
   setFont(font2)
   setColor(128, 128, 128, alpha2)
   print("beneath", (widescreenOffset + 10) * scale, 18 * scale)
   setFont(font1)
   setColor(192, 192, 192, alpha2)
   print("the Abyss", (widescreenOffset + 6) * scale, 27 * scale)
end

function gameover.gamepadpressed(joystick, button)
   if button == "a" or button == "start" or button == "back" then
      enemy.silence()
      splash.initialize()
      state = "splash"
   end
end

function gameover.keypressed(key)
   if key == "return" or key == " " or key == "escape" then
      enemy.silence()
      splash.initialize()
      state = "splash"
   elseif key == "f11" then
      graphics.toggleFullscreen()
   end
end
