require "vector2"
require "enemy"

function CreatePlayer(world, x, y)
    local player = {}
    player.body = love.physics.newBody(world, x, y, "dynamic")
    player.shape = love.physics.newRectangleShape(70, 70)
    player.body:setFixedRotation(true)
    player.fixture = love.physics.newFixture(player.body, player.shape, 500)
    player.fixture:setUserData("player")
    player.dashspeed = 1.8
    player.dashduration = 0.6
    player.dashing = false
    player.canDash = true
    player.cooldowntime = 3
    player.completedlevel = false
    player.gettingattacked = false
    player.attackedCooldown = 0
    player.attackedcooldowntime = 0.5
    player.resetstate = false
    player.canGetDamaged = false
    player.damaged = false
    player.gameover = false
    return player
end

function CreateHearts (world, x, y)
    local hearts = {}
    hearts.heart5 = true
    hearts.heart4 = true
    hearts.heart3 = true
    hearts.heart2 = true
    hearts.heart1 = true
    hearts.potion = false
    hearts.potioncooldowntime = 19
    hearts.potionCooldown = 0
    return hearts
end

function CreateMouse(world, mx, my)
    local mouse = {}
    mouse.mouseposition = vector2.new(mx, my)
    return mouse
end

function CheckEnemyContacts(player)
    local contacts = player.body:getContacts()
    if #contacts == 0 then
        player.gettingattacked = false
    else
        local contactwithenemy = false 
        for i = 1, #contacts, 1 do
           local fixtureA, fixtureB = contacts[i]:getFixtures()
           if (fixtureA:getUserData() == "player" and fixtureB:getUserData() == "enemy") or(fixtureA:getUserData() == "enemy" and fixtureB:getUserData() == "player") then
            local normal = vector2.new(contacts[i]:getNormal())
            io.write(normal.x)
                if normal.x == 0 or normal.x == 1 or normal.x == -1 then 
                    contactwithenemy = true
                    io.write("contact \n") 
                end

            end
        end
        player.gettingattacked = contactwithenemy
    end
end

function UpdateMouse(mouse)
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    mouse.mouseposition = vector2.new(mx, my)
end

function UpdatePlayer(player, mouse, hearts, dt)
    local xVel = 0
    local yVel = 0

    CheckEnemyContacts(player)

    if player.gettingattacked == true then -- cooldown to check if player can be attacked
        player.attackedCooldown = player.attackedCooldown + dt
        if player.attackedCooldown >= player.attackedcooldowntime then
            player.canGetDamaged = true 
            io.write("atack \n")
        else
            player.canGetDamaged = false
        end
    end

    if player.gettingattacked == true and player.canGetDamaged == true then -- tells that player is getting attacked
        player.damaged = true
        player.attackedCooldown = 0
    else
        player.damaged = false
    end

    if player.damaged == true and hearts.heart1 == true then -- player taking damage
        hearts.heart1 = false
    elseif player.damaged == true and hearts.heart1 == false and hearts.heart2 == true then
        hearts.heart2 = false
    elseif player.damaged == true and hearts.heart1 == false and hearts.heart2 == false and hearts.heart3 == true then
        hearts.heart3 = false
    elseif player.damaged == true and hearts.heart1 == false and hearts.heart2 == false and hearts.heart3 == false and hearts.heart4 == true then
        hearts.heart4 = false
    elseif player.damaged == true and hearts.heart1 == false and hearts.heart2 == false and hearts.heart3 == false and hearts.heart4 == false and hearts.heart5 == true then
        hearts.heart5 = false
    end

    if hearts.potionCooldown and hearts.potion == false then
        hearts.potionCooldown = hearts.potionCooldown + dt
        if hearts.potionCooldown >= hearts.potioncooldowntime then
            hearts.potion = true
        end
    end

    if love.keyboard.isDown("o") and love.keyboard.isDown("p")then --activate cheats
        hearts.potioncooldowntime = 1
        player.cooldowntime = 0.1
    end

    if love.keyboard.isDown("i") and love.keyboard.isDown("p")then --deactivate cheats
        hearts.potioncooldowntime = 19
        player.cooldowntime = 3
    end

    if love.keyboard.isDown("e") and hearts.potion == true then --using the potion
        hearts.potionCooldown = 0
        hearts.potion = false
        hearts.potionuse = true
        hearts.heart1 = true
        hearts.heart2 = true
        hearts.heart3 = true
        hearts.heart4 = true
        hearts.heart5 = true
    end

    if hearts.heart5 == false then
        player.gameover = true
    end

    if player.dashingCooldown then
        player.dashingCooldown = player.dashingCooldown + dt
        if player.dashingCooldown >= player.cooldowntime then
            player.canDash = true
        end
    end

    if player.dashing then
        player.dashingTime = player.dashingTime + dt
        if player.dashingTime >= player.dashduration then
            player.dashing = false
        end
        return
    elseif love.keyboard.isDown("space") and player.canDash == true then
        player.dashing = true
        player.dashingTime = 0
        player.canDash = false
        player.dashingCooldown = 0

        local centerOfScreen = vector2.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
        local dashinglocation = vector2.sub(mouse.mouseposition, centerOfScreen)
        vector2.normalize(dashinglocation)
        local myVec = vector2.new(dashinglocation.x, dashinglocation.y)
        xVel = player.dashspeed * myVec.x
        yVel = player.dashspeed * myVec.y
    end

    if not player.dashing then
        if love.keyboard.isDown("d") then
            xVel = 300
        end
        if love.keyboard.isDown("a") then
            xVel = -300
        end
        if love.keyboard.isDown("w") then
            yVel = -300
        end
        if love.keyboard.isDown("s") then
            yVel = 300
        end      
    end

    if xVel ~= 0 and yVel ~= 0 then
        xVel = xVel * 0.85
        yVel = yVel * 0.85
    end

    player.body:setLinearVelocity(xVel, yVel)
end

function BeginContactPlayer(fixtureA, fixtureB, player)
    if (fixtureA:getUserData() == "player" and fixtureB:getUserData() == "endlevel") or 
    (fixtureA:getUserData() == "endlevel" and fixtureB:getUserData() == "player") then
        player.completedlevel = true
    end
end

function DrawPlayer(player, menus)
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill",  player.body:getWorldPoints(player.shape:getPoints())) 
end

function DrawMouse(mouse)
    love.graphics.line(mouse.mouseposition.x, mouse.mouseposition.y, mouse.mouseposition.x + 10, mouse.mouseposition.y + 10)
    love.graphics.line(mouse.mouseposition.x, mouse.mouseposition.y, mouse.mouseposition.x + 10, mouse.mouseposition.y - 10)
    love.graphics.line(mouse.mouseposition.x, mouse.mouseposition.y, mouse.mouseposition.x - 10, mouse.mouseposition.y - 10)
    love.graphics.line(mouse.mouseposition.x, mouse.mouseposition.y, mouse.mouseposition.x - 10, mouse.mouseposition.y + 10)
end

function DrawHearts(hearts)
    if hearts.heart5 == true then
        love.graphics.setColor(0.7, 0, 0)
        love.graphics.rectangle("fill", 20, 20, 40, 40)  
    end
    if hearts.heart5 == false then
        love.graphics.setColor(2, 0.7, 0.7)
        love.graphics.rectangle("fill", 20, 20, 40, 40)  
    end
    if hearts.heart4 == true then
        love.graphics.setColor(0.7, 0, 0)
        love.graphics.rectangle("fill", 70, 20, 40, 40)  
    end
    if hearts.heart4 == false then
        love.graphics.setColor(2, 0.7, 0.7)
        love.graphics.rectangle("fill", 70, 20, 40, 40)  
    end
    if hearts.heart3 == true then
        love.graphics.setColor(0.7, 0, 0)
        love.graphics.rectangle("fill", 120, 20, 40, 40)  
    end
    if hearts.heart3 == false then
        love.graphics.setColor(2, 0.7, 0.7)
        love.graphics.rectangle("fill", 120, 20, 40, 40)  
    end
    if hearts.heart2 == true then
        love.graphics.setColor(0.7, 0, 0)
        love.graphics.rectangle("fill", 170, 20, 40, 40)  
    end
    if hearts.heart2 == false then
        love.graphics.setColor(2, 0.7, 0.7)
        love.graphics.rectangle("fill", 170, 20, 40, 40)  
    end
    if hearts.heart1 == true then
        love.graphics.setColor(0.7, 0, 0)
        love.graphics.rectangle("fill", 220, 20, 40, 40)  
    end
    if hearts.heart1 == false then
        love.graphics.setColor(2, 0.7, 0.7)
        love.graphics.rectangle("fill", 220, 20, 40, 40)  
    end
    if hearts.potion == true then
        love.graphics.setColor(0.4, 0, 0)
        love.graphics.rectangle("fill", 170, 80, 40, 40)  
    end
    if hearts.potion == false then
        love.graphics.setColor(2, 0.9, 0.9)
        love.graphics.rectangle("fill", 170, 80, 40, 40)  
    end
end