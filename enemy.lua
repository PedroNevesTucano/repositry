local enemyimage = love.graphics.newImage("Enemy3.png")

function CreateEnemy(world, x, y)
    local enemy = {}
    enemy.sprite = enemyimage
    enemy.body = love.physics.newBody(world, x, y, "dynamic")
    enemy.shape = love.physics.newRectangleShape(50, 50)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
    enemy.fixture:setUserData("enemy")
    enemy.body:setFixedRotation(true)
    enemy.viewangle = 360
    enemy.viewrange = 650
    enemy.speedFactor = 280
    enemy.state = "idle"
    return enemy
end

function UpdateEnemies(player, enemies, dt)
    for i = 1, #enemies, 1 do
        local playerposition = vector2.new(player.body:getPosition())
        local enemyposition = vector2.new(enemies[i].body:getPosition())
        local playerdirection = vector2.sub(playerposition, enemyposition)
        local distance = vector2.magnitude(playerdirection)
        local normalizeddirection = vector2.normalize(playerdirection)
        if enemies[i].state ~= "attacking" then
                if distance < enemies[i].viewrange then
                    enemies[i].state = "chase"
                else
                    enemies[i].state = "idle"
                end
                if enemies[i].state == "chase" then
                    local engineforce = vector2.mult(normalizeddirection, enemies[i].speedFactor)
                    enemies[i].body:setLinearVelocity(engineforce.x, engineforce.y)
                elseif enemies[i].state == "attacking" then
                    enemies[i].body:setLinearVelocity(0, 0)
                end
        end
    end
end

function DrawEnemies(enemies)
    for i = 1, #enemies, 1 do
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.draw(enemies[i].sprite, enemies[i].body:getX(), enemies[i].body:getY(),
        enemies[i].body:getAngle(), 0.3, 0.3,
        enemies[i].sprite:getWidth()/2,
        enemies[i].sprite:getHeight()/2)
    end
end

function EnemyTouchedPlayer(enemy)
    enemy.state = "attacking"
end
function EnemyTouchedPlayerStop(enemy)
    enemy.state = "chase"
end