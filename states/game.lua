game = {}

function game.initialize()
   player.initialize()
   enemy.initialize()
   paused = false
   alpha = 255
end

function game.update(dt)
   player.update(dt)
   enemy.update(dt)
end

function game.draw()
   local random = love.math.random
   local setColor = love.graphics.setColor
   local rectangle = love.graphics.rectangle
   local widescreenOffset = widescreenOffset
   for i = 1, 64 do
      for j = 1, 48 do
         c = depth - depth % 1
         if i < 32 then
            c = c + (i^2 / j) / (64 / 48)
         else
            c = c + ((64 - i)^2 / j) / (64 / 48)
         end
         --[[if i > playerX then
         c = c + i - playerX
         else
         c = c + playerX - i
         end ]]--
         if c > 250 then c = 250 elseif c < 0 then c = 0 end
         c = c + random(5)
         r = c + (255 - playerHealth)
         if r > 255 then r = 255 end
         setColor(r, c, c, alpha)
         rectangle("fill", (i - 1 + widescreenOffset) * scale, (j -1) * scale, scale, scale)
      end
   end
   enemy.draw()
end

function game.gamepadpressed(joystick, button)
   if button == "start" then
      paused = not paused
      if audioAvailable and audioOn then
         audio.randomizePitch(sf1)
         if paused then audio.pauseEffect(sf1) else audio.resumeEffect(sf1) end
      end
   elseif button == "back" and not paused then
      splash.initialize()
      state = "splash"
   elseif (button == "dpleft" or button == "dpright" or button == "dpup" or button == "dpdown") then
      gamepadDirectionDown = true
      if soundAvailable and soundOn then
         audio.randomizePitch(sf1)
         audio.playEffect(sf1)
      end
   end
end

function game.gamepadreleased(joystick, button)
   local isDown = love.keyboard.isDown
   if button == "dpleft" or button == "dpright" or button == "dpup" or button == "dpdown" then
      if not (joystick:isGamepadDown("dpleft") or joystick:isGamepadDown("dpright") or joystick:isGamepadDown("dpup") or joystick:isGamepadDown("dpdown")) then
         gamepadDirectionDown = false
         if not (isDown("left") or isDown("right") or isDown("up") or isDown("down") or isDown("a") or isDown("d") or isDown("w") or isDown("s")) and soundAvailable and soundOn then
            audio.stopEffect(sf1)
         end
      end
   end
end

function game.keypressed(key)
   if key == "f11" then
      graphics.toggleFullscreen()
   elseif key == " " then
      paused = not paused
      if audioAvailable and audioOn then
         if paused then audio.pauseEffect(sf1) else audio.resumeEffect(sf1) end
      end
   elseif key == "escape" and not paused then
      splash.initialize()
      state = "splash"
   elseif (key == "left" or key == "right" or key == "up" or key == "down" or key == "a" or key == "d" or key == "w" or key == "s") and soundAvailable and soundOn then
      audio.randomizePitch(sf1)
      audio.playEffect(sf1)
   end
end

function game.keyreleased(key)
   local isDown = love.keyboard.isDown
   if (key == "left" or key == "right" or key == "up" or key == "down" or key == "a" or key == "d" or key == "w" or key == "s") and soundAvailable then
      if not (isDown("left") or isDown("right") or isDown("up") or isDown("down") or isDown("a") or isDown("d") or isDown("w") or isDown("s") or gamepadDirectionDown) and soundAvailable and soundOn then
         audio.stopEffect(sf1)
      end
   end 
end

function game.focus(f)
   if not f then paused = true else paused = false end
end
