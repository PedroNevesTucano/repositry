require "player"
require "vector2"
require "wall"
require "enemy"
require "EventArea"
require "menus"

local world
local player
local mouse
local walls
local hearts
local enemies
local endlevelarea
local menus
local state = not love.mouse.isVisible() 
love.mouse.setVisible(state)

function love.load()
Initialize()
end

function Initialize()
    world = love.physics.newWorld(0, 0, true)
    player = CreatePlayer(world, 750, 500)
    mouse = CreateMouse(world)
    hearts = CreateHearts(world)
    menus = CreateMenus(world)
    love.window.setFullscreen(true)
    world:setCallbacks(BeginContact, EndContact, nil, nil)

    enemies = {}
    enemies [1] = CreateEnemy(world, 550, 120)
    enemies [2] = CreateEnemy(world, 950, 120)
    enemies [3] = CreateEnemy(world, 950, -600)
    enemies [4] = CreateEnemy(world, 550, -600)
    enemies [5] = CreateEnemy(world, 1300, -1400)
    enemies [6] = CreateEnemy(world, 1100, -1300)
    enemies [7] = CreateEnemy(world, 1400, -1200)
    enemies [8] = CreateEnemy(world, 1200, -1400)
    enemies [9] = CreateEnemy(world, 1200, -1300)
    enemies [10] = CreateEnemy(world, 100, -800)
    enemies [11] = CreateEnemy(world, 200, -850)
    enemies [12] = CreateEnemy(world, 300, -900)
    enemies [13] = CreateEnemy(world, 200, -800)
    enemies [14] = CreateEnemy(world, 300, -1000)
    enemies [15] = CreateEnemy(world, -200, -1600)
    enemies [16] = CreateEnemy(world, 200, -1600)
    enemies [17] = CreateEnemy(world, -200, -1900)
    enemies [18] = CreateEnemy(world, 200, -1900)
    enemies [19] = CreateEnemy(world, -200, -2200)
    enemies [20] = CreateEnemy(world, 200, -2200)
    enemies [21] = CreateEnemy(world, 100, -2600)
    enemies [22] = CreateEnemy(world, 100, -2700)
    enemies [23] = CreateEnemy(world, -200, -3100)
    enemies [24] = CreateEnemy(world, -330, -3000)
    enemies [25] = CreateEnemy(world, -320, -2960)
    enemies [26] = CreateEnemy(world, -400, -2870)
    enemies [27] = CreateEnemy(world, 500, -2870)
    enemies [28] = CreateEnemy(world, 520, -2820)

    walls = {}
    walls[1] = CreateWall(world, 750, 860, 600, 30)
    walls[2] = CreateWall(world, 350, 830, 200, 30)
    walls[3] = CreateWall(world, 1150, 830, 200, 30)
    walls[4] = CreateWall(world, 1265, 715, 30, 200)
    walls[5] = CreateWall(world, 235, 715, 30, 200)
    walls[6] = CreateWall(world, 205, 515, 30, 200)
    walls[7] = CreateWall(world, 1295, 515, 30, 200)
    walls[8] = CreateWall(world, 1265, 315, 30, 200)
    walls[9] = CreateWall(world, 235, 315, 30, 200)
    walls[10] = CreateWall(world, 350, 200, 200, 30)
    walls[11] = CreateWall(world, 1150, 200, 200, 30)
    walls[12] = CreateWall(world, 1035, -215, 30, 800)
    walls[13] = CreateWall(world, 465, -215, 30, 800)
    walls[14] = CreateWall(world, 945, -630, 150, 30)
    walls[15] = CreateWall(world, 555, -630, 150, 30)
    walls[16] = CreateWall(world, -20, -660, 1000, 30)
    walls[17] = CreateWall(world, 1220, -660, 400, 30)
    walls[18] = CreateWall(world, 1435, -1075, 30, 800)
    walls[19] = CreateWall(world, -535, -1075, 30, 800)
    walls[20] = CreateWall(world, -370, -1490, 300, 30)
    walls[21] = CreateWall(world, 820, -1490, 1200, 30)
    walls[22] = CreateWall(world, 235, -1905, 30, 800)
    walls[23] = CreateWall(world, -235, -1905, 30, 800)
    walls[24] = CreateWall(world, -650, -2320, 800, 30)
    walls[25] = CreateWall(world, 650, -2320, 800, 30)
    walls[26] = CreateWall(world, 1065, -2735, 30, 800)
    walls[27] = CreateWall(world, -1065, -2735, 30, 800)
    walls[28] = CreateWall(world, 650, -3150, 800, 30)
    walls[29] = CreateWall(world, -650, -3150, 800, 30)
    walls[30] = CreateWall(world, -265, -3265, 30, 200)
    walls[31] = CreateWall(world, 265, -3265, 30, 200)

    endlevelarea = CreateEventArea(world, -1, -3380, 500, 30)
end

function BeginContact(fixtureA, fixtureB)
    BeginContactPlayer(fixtureA, fixtureB, player)
    if (fixtureA:getUserData() == "player" and fixtureB:getUserData() == "enemy") then
        local enemy = FindEnemy(fixtureB)
        EnemyTouchedPlayer(enemy)
    elseif (fixtureA:getUserData() == "enemy" and fixtureB:getUserData() == "player") then
        local enemy = FindEnemy(fixtureA)
        EnemyTouchedPlayer(enemy)
    end
end

function FindEnemy(enemyFixture)
    for i = 1, #enemies, 1 do
        if enemies[i].fixture == enemyFixture then
            return enemies[i]
        end
    end
    return nil
end

function EndContact(fixtureA, fixtureB)
    if (fixtureA:getUserData() == "player" and fixtureB:getUserData() == "enemy") then
        local enemy = FindEnemy(fixtureB)
        EnemyTouchedPlayerStop(enemy)
    elseif (fixtureA:getUserData() == "enemy" and fixtureB:getUserData() == "player") then
        local enemy = FindEnemy(fixtureA)
        EnemyTouchedPlayerStop(enemy)
    end
end

function love.update(dt)
    UpdateMouse(mouse)
    UpdateMenus(menus, mouse, player)
    if menus.gameover.state == false then
        if player.gameover == false and player.completedlevel == false and menus.paused.state == false and menus.mainmenu.state == false then
            UpdatePlayer(player, mouse, hearts, dt)
            UpdateEnemies(player, enemies, dt)
            world:update(dt)
        end
    end
end

function love.draw()
    love.graphics.push()
    local playerlocation = vector2.new(player.body:getPosition())
    love.graphics.translate(-playerlocation.x + love.graphics.getWidth()/2,-playerlocation.y + love.graphics.getHeight()/2)
    DrawWalls(walls)
    DrawEnemies(enemies)
    love.graphics.setBackgroundColor(1, 1, 1)
    DrawPlayer(player, menus)
    DrawEventArea(endlevelarea)
    love.graphics.pop()
    if player.canDash == true then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 20, 80, 140, 40)
    end
    if player.canDash == false then
        love.graphics.setColor(0.7, 1, 0.7)
        love.graphics.rectangle("fill", 20, 80, 140, 40)  
    end
    if player.gameover == true then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("gameover", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
    DrawHearts(hearts)
    love.graphics.setColor(1, 1, 1)
    DrawMenus(menus, world)
    love.graphics.setColor(0, 0, 0)
    DrawMouse(mouse)
    if player.completedlevel == true then
        love.graphics.print("level completed", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
end