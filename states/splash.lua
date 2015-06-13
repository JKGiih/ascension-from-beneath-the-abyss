splash = {}

function splash.initialize()
   playerWidth = 2
   playerHeight = 4
   playerX = screenWidth / 2 - playerWidth / 2
   playerY = 0
   health = 255
   depth = 0
   alpha = 1
end

function splash.update(dt)
   playerY = playerY + dt
   if playerY > screenHeight then playerY = screenHeight end
   depth = 255 - 5 * playerY^1.45
   alpha = alpha + dt * (dt + 6)
   if alpha > 255 then alpha = 255 end
end

function splash.draw()
   game.draw()
   local setFont = love.graphics.setFont
   local setColor = love.graphics.setColor
   local print = love.graphics.print
   setFont(font1)
   setColor(64, 64, 64, alpha)
   print("Ascension", (widescreenOffset + 10) * scale, 5 * scale)
   setFont(font2)
   setColor(128, 128, 128, alpha)
   print("from Beneath", (widescreenOffset + 6) * scale, 18 * scale)
   setFont(font1)
   setColor(192, 192, 192, alpha)
   print("the Abyss", (widescreenOffset + 10) * scale, 27 * scale)
end

function splash.gamepadpressed(joystick, button)
   if button == "a" or button == "start" or button == "back" then
      game.initialize()
      state = "game"
   end
end

function splash.keypressed(key)
   if key == "return" or key == " " or key == "escape" then
      game.initialize()
      state = "game"
   elseif key == "f11" then
      graphics.toggleFullscreen()
   end
end
