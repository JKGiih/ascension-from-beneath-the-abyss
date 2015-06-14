player = {}

function player.initialize()
   playerWidth = 2
   playerHeight = 4
   playerX = screenWidth / 2 - playerWidth / 2
   if state == "splash" then
      playerY = screenHeight - playerHeight
   else
      playerY = 0
      playerHealth = 255
   end
end    

function player.incrementMuchHealth(dt)
   playerHealth = playerHealth + dt * 30 + love.math.random(10)
   if playerHealth > 255 then playerHealth = 255 end
end

function player.incrementHealth(dt)
   playerHealth = playerHealth + dt * 10
   if playerHealth > 255 then playerHealth = 255 end
end

function player.decrementHealth(dt)
   playerHealth = playerHealth - dt * 5
   if playerHealth < 0 then playerHealth = 0 end 
end

function player.update(dt)
   if state == "splash" then
      playerY = playerY + dt
      if playerY > screenHeight then playerY = screenHeight end
   elseif state == "game" then
      local isDown = love.keyboard.isDown
      local horizontalDirection = nil
      local verticalDirection = nil
      if table.getn(gamepads) >= 1 then
         for i = 1, table.getn(gamepads) do
            if gamepads[i]:isGamepadDown("dpleft") then
               horizontalDirection = "left"
            elseif gamepads[i]:isGamepadDown("dpright") then
               horizontalDirection = "right"
            end
            if gamepads[i]:isGamepadDown("dpup") then
               verticalDirection = "up"
            elseif gamepads[i]:isGamepadDown("dpdown") then
               verticalDirection = "down"
            end
         end
      end
      if isDown("left") or isDown("a") or horizontalDirection == "left" then
         playerX = playerX - dt * 10
      end
      if isDown("right") or isDown("d") or horizontalDirection == "right" then
         playerX = playerX + dt * 10
      end
      if isDown("up") or isDown("w") or verticalDirection == "up" then
         playerY = playerY - dt * (playerY / screenHeight)^2
      end
      if isDown("down") or isDown("s") or verticalDirection == "down" then
         playerY = playerY + dt
         player.incrementMuchHealth(dt)
         for i = 1, table.getn(enemies) do
            enemy.decrementHealth(i, dt)
         end
      end
      if playerX < 2 then playerX = 2 end
      if playerX > screenWidth - playerWidth - 2 then
         playerX = screenWidth - playerWidth - 2
      end
      if playerY < 1 then
         playerY = 1
         gamewon.initialize()
         state = "gamewon"
      end
      if playerY > screenHeight - playerHeight then
         playerY = screenHeight - playerHeight
      end
      depth = 255 - 5 * playerY^1.45
      if playerHealth <= 0 then
         playerHealth = 0
         gameover.initialize()
         state = "gameover"
      end 
   end
end
