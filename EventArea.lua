function CreateEventArea(world, x, y, width, height)
    local eventarea = {}
    eventarea.body = love.physics.newBody(world, x, y, "static")
    eventarea.shape = love.physics.newRectangleShape(width, height)
    eventarea.fixture = love.physics.newFixture(eventarea.body, eventarea.shape, 1)
    eventarea.fixture:setUserData("endlevel")
    eventarea.fixture:setSensor(true)
    return eventarea
end

function DrawEventArea(eventarea)
    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", eventarea.body:getWorldPoints(eventarea.shape:getPoints()))  
end