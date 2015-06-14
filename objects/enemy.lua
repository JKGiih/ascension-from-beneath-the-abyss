enemy = {}

function enemy.initialize()
   enemies = {}
   enemyWidth = 6
   enemyHeight = 6
   spawnCounter = 10
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
   local enemyMoveSound = 0
   local enemyDieSound = 0
   if soundAvailable then
      enemyMoveSound = Move:clone()
      audio.randomizePitch(enemyMoveSound)
      enemyDieSound = Die:clone()
      audio.randomizePitch(enemyDieSound)
   end
   table.insert(enemies, {enemyX, enemyY, enemyHealth, enemyMoveSound, enemyDieSound})
   if soundAvailable and soundOn then audio.playEffect(enemies[table.getn(enemies)][4]) end
   spawnCounter = 10
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
   local rectangle = love.graphics.rectangle
   local setColor = love.graphics.setColor
   for i = 1, table.getn(enemies) do
      setColor(enemies[i][3], 0, 0, 255)
      rectangle("fill", (lockToGrid(enemies[i][1]) + widescreenOffset) * scale, lockToGrid(enemies[i][2]) * scale, scale, scale)
   end
end
