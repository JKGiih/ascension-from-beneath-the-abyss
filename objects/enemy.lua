enemy = {}

function enemy.initialize()
   enemies = nil
   enemies = {}
   enemyWidth = 6
   enemyHeight = 6
   spawnCounter = screenHeight
end    

function enemy.move(dt)
   local random = love.math.random
   for i = 1, table.getn(enemies) do
      enemies[i][1] = enemies[i][1] + (random(3) - 2) * 10 * dt
      if enemies[i][1] < 1 then
         enemies[i][1] = 1
      elseif enemies[i][1] > screenWidth - enemyWidth - 1 then
         enemies[i][1] = screenWidth - enemyWidth - 1
      end
      enemies[i][2] = enemies[i][2] + (random(3) - 2) * 10 * dt
      if enemies[i][2] < 1 then
         enemies[i][2] = 1
      elseif enemies[i][2] > screenHeight - enemyHeight - 1 then
         enemies[i][2] = screenHeight - enemyHeight - 1
      end
   end
end

function enemy.spawn(dt)
   local random = love.math.random
   local enemyX = 1 + (random(screenWidth) - enemyWidth - 1)
   local enemyY = 1 + (random(screenHeight) - enemyHeight - 1)
   local enemyHealth = 255
   local enemyMoveSound = nil
   local enemyDieSound = nil
   if soundAvailable then
      enemyMoveSound = sf3:clone()
      audio.randomizePitch(enemyMoveSound)
      enemyDieSound = sf4:clone()
      audio.randomizePitch(enemyDieSound)
   end
   table.insert(enemies, {enemyX, enemyY, enemyHealth, enemyMoveSound, enemyDieSound})
   if soundAvailable and soundOn then audio.playEffect(enemies[table.getn(enemies)][4]) end
   spawnCounter = playerY
end

function enemy.silence()
   for i = 1, table.getn(enemies) do
      audio.stopEffect(enemies[i][4])
      enemies[i][4] = nil
      enemies[i][5] = nil
   end
end

function enemy.clear()
   local getn = table.getn
   local insert = table.insert
   local remove = table.remove
   local enemiesToRemove = {}
   if next(enemies) then
      for i = 1, getn(enemies) do
         if enemies[i][3] <= 0 then
            insert(enemiesToRemove, i)
         end
      end
      for i = 1, getn(enemiesToRemove) do
         if soundAvailable and soundOn then
            audio.playEffect(enemies[i][5])
            audio.stopEffect(enemies[i][4])
         end
         remove(enemies, enemiesToRemove[i])
      end
   end
end

function enemy.drainHealth(dt)
   for i = 1, table.getn(enemies) do
      if enemies[i][1] + enemyWidth / 2 > playerX + playerWidth / 2 then
         if enemies[i][1] + enemyWidth / 2 - playerX + playerWidth / 2 < screenWidth / 2 - 4 then
            enemy.incrementHealth(i, dt)
            player.decrementHealth(dt)
         else
            enemy.decrementHealth(i, dt)
            player.incrementHealth(dt)
         end
      else
         if playerX + playerWidth / 2 - enemies[i][1] + enemyWidth / 2 < screenWidth / 2 - 4 then
            enemy.incrementHealth(i, dt)
            player.decrementHealth(dt)
         else
            enemy.decrementHealth(i, dt)
            player.incrementHealth(dt)
         end
      end
   end
end

function enemy.incrementHealth(e, dt)
   enemies[e][3] = enemies[e][3] + dt * 10
   if enemies[e][3] > 255 then enemies[e][3] = 255 end 
end

function enemy.decrementHealth(e, dt)
   enemies[e][3] = enemies[e][3] - dt * 10
   if enemies[e][3] < 0 then enemies[e][3] = 0 end 
end

function enemy.update(dt)
   enemy.move(dt)
   enemy.drainHealth(dt)
   enemy.clear()
   if spawnCounter <= 0 then
      enemy.spawn(dt)
   else
      spawnCounter = spawnCounter - dt
   end
end

function enemy.draw()
   local lockToGrid = graphics.lockToGrid
   local screenHeight = screenHeight
   local canvasScale = canvasScale
   local widescreenOffset = widescreenOffset
   local random = love.math.random
   local rectangle = love.graphics.rectangle
   local setColor = love.graphics.setColor
   local a = random(32) + 16
   for n = 1, table.getn(enemies) do
      for i = 1, enemyWidth do
         for j = 1, enemyHeight do
            local c = random(25)
            local offsetX = random(9) - 5
            local offsetY = random(13) - 7
            local x = lockToGrid(enemies[n][1] + i - 1 + offsetX + widescreenOffset)
            local y = lockToGrid(enemies[n][2] + j - 1 + offsetY)
            if x >= widescreenOffset and x < screenWidth + widescreenOffset and y >= 0 and y < screenHeight then
               setColor(enemies[n][3], c, c, a)
               rectangle("fill", x * scale, y * scale, scale, scale)
            end
         end
      end 
   end
end
