function CreateWall(world, x, y, width, height)
    local wall = {}
    wall.body = love.physics.newBody(world, x, y, "static")
    wall.shape = love.physics.newRectangleShape(width, height)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape, 1)
    return wall
end

function DrawWalls(walls)
    love.graphics.setColor(0.6, 0.6, 0.6)
    for i = 1, #walls, 1 do
        love.graphics.polygon("fill", walls[i].body:getWorldPoints(walls[i].shape:getPoints()))
    end
end
