local pausedimage = love.graphics.newImage("Menu_Pause.png")
local mainmenuimage = love.graphics.newImage("Menu.png")
local mainmenucommandsscreenimage = love.graphics.newImage("Commands.png")
local mainmenuplayimage = love.graphics.newImage("MenuPlay.png")
local mainmenuexitimage = love.graphics.newImage("MenuExit.png")
local mainmenucommandsmenuimage = love.graphics.newImage("CommandsMenu.png")
local mainmenucommandsimage = love.graphics.newImage("MenuCommands.png")
local mainmenuareyousureimage = love.graphics.newImage("MenuAreYouSure.png")
local mainmenuareyousureyesimage = love.graphics.newImage("MenuAreYouSureYes.png")
local mainmenuareyousurenoimage = love.graphics.newImage("MenuAreYouSureNo.png")

function CreateMenus(world)
    local menus = {}
    menus.paused = {}
    menus.paused.state = false
    menus.paused.image = pausedimage
    menus.mainmenu = {}
    menus.mainmenu.image = mainmenuimage
    menus.mainmenu.playimage = mainmenuplayimage
    menus.mainmenu.exitimage = mainmenuexitimage
    menus.mainmenu.commandsimage = mainmenucommandsimage
    menus.mainmenu.commandsmenuimage = mainmenucommandsmenuimage
    menus.mainmenu.commandsscreenimage = mainmenucommandsscreenimage
    menus.mainmenu.areyousurescreenimage = mainmenuareyousureimage
    menus.mainmenu.areyousureyesimage = mainmenuareyousureyesimage
    menus.mainmenu.areyousurenoimage = mainmenuareyousurenoimage
    menus.areyousureyes = false
    menus.areyousureno = false
    menus.play = false
    menus.commandsmenu = false
    menus.mainmenu.state = true
    menus.mainmenu.commandsstate = false
    menus.mainmenu.areyousurestate = false
    menus.exit = false
    menus.commands = false
    menus.gameover = {}
    menus.gameover.state = false
    return menus
end

function UpdateMenus(menus, mouse, player)
    if love.keyboard.isDown("escape") and player.gameover == false and menus.mainmenu.state == false and player.completedlevel == false then
        menus.paused.state = true
    end
  	if menus.paused.state == true and love.mouse.isDown(1) and mouse.mouseposition.x >= 645 and mouse.mouseposition.x <= 895 and mouse.mouseposition.y >= 650 and mouse.mouseposition.y <= 800 then
        menus.paused.state = false
  	end
    if menus.paused.state == true and love.mouse.isDown(1) and mouse.mouseposition.x >= 645 and mouse.mouseposition.x <= 895 and mouse.mouseposition.y >= 350 and mouse.mouseposition.y <= 500 then
        menus.mainmenu.state = true
  	end
    if menus.mainmenu.state == true and love.mouse.isDown(1) and menus.mainmenu.areyousurestate == false and menus.mainmenu.commandsstate == false and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 670 and mouse.mouseposition.y <= 795 then
        menus.mainmenu.areyousurestate = true
  	end
    if menus.mainmenu.state == true and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 670 and mouse.mouseposition.y <= 795 then
        menus.exit = true
    else
        menus.exit = false
  	end
      if menus.mainmenu.state == true and love.mouse.isDown(1) and menus.mainmenu.areyousurestate == true and menus.mainmenu.commandsstate == false and mouse.mouseposition.x >= 1030 and mouse.mouseposition.x <= 1530 and mouse.mouseposition.y >= 560 and mouse.mouseposition.y <= 685 then
        love.event.quit("")
    end
    if menus.mainmenu.state == true and menus.mainmenu.areyousurestate == true and mouse.mouseposition.x >= 1030 and mouse.mouseposition.x <= 1530 and mouse.mouseposition.y >= 560 and mouse.mouseposition.y <= 685 then
        menus.areyousureyes = true
    else
        menus.areyousureyes = false
    end
    if menus.mainmenu.state == true and love.mouse.isDown(1) and menus.mainmenu.areyousurestate == true and menus.mainmenu.commandsstate == false and mouse.mouseposition.x >= 1030 and mouse.mouseposition.x <= 1530 and mouse.mouseposition.y >= 700 and mouse.mouseposition.y <= 825 then
        menus.mainmenu.areyousurestate = false
    end
    if menus.mainmenu.state == true and menus.mainmenu.areyousurestate == true and mouse.mouseposition.x >= 1030 and mouse.mouseposition.x <= 1530 and mouse.mouseposition.y >= 700 and mouse.mouseposition.y <= 825 then
        menus.areyousureno = true
    else
        menus.areyousureno = false
    end
    if menus.mainmenu.state == true and love.mouse.isDown(1) and menus.mainmenu.areyousurestate == false and menus.mainmenu.commandsstate == false and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 390 and mouse.mouseposition.y <= 515 then
        menus.mainmenu.state = false
        menus.paused.state = false
  	end
    if menus.mainmenu.state == true and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 390 and mouse.mouseposition.y <= 515 then
        menus.play = true
    else
        menus.play = false
  	end
    if menus.mainmenu.state == true and love.mouse.isDown(1) and menus.mainmenu.areyousurestate == false and menus.mainmenu.commandsstate == false and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 530 and mouse.mouseposition.y <= 655 then
       menus.mainmenu.commandsstate = true
    end
    if menus.mainmenu.state == true and mouse.mouseposition.x >= 30 and mouse.mouseposition.x <= 500 and mouse.mouseposition.y >= 530 and mouse.mouseposition.y <= 655 then
        menus.commands = true
    else
        menus.commands = false
    end
    if menus.mainmenu.state == true and menus.mainmenu.areyousurestate == false and menus.mainmenu.commandsstate == true and mouse.mouseposition.x >= 1060 and mouse.mouseposition.x <= 1560 and mouse.mouseposition.y >= 730 and mouse.mouseposition.y <= 875 then
        menus.commandsmenu = true
    else
        menus.commandsmenu = false
    end
    if menus.mainmenu.state == true and menus.mainmenu.areyousurestate == false and love.mouse.isDown(1) and menus.mainmenu.commandsstate == true and mouse.mouseposition.x >= 1060 and mouse.mouseposition.x <= 1560 and mouse.mouseposition.y >= 730 and mouse.mouseposition.y <= 875 then
        menus.mainmenu.commandsstate = false
    end
    if love.keyboard.isDown("r") then 
        menus.gameover.state = true
    end
    if menus.gameover.state == true then
        player.body:destroy()
        player.shape:release()
        player.fixture:destroy()
        CreatePlayer(world, 750, 500)
        menus.gameover.state = false
    end
end

function DrawMenus(menus)
    if menus.paused.state == true then
        love.graphics.draw(menus.paused.image, 0, -85)
    end
    if menus.mainmenu.state == true and menus.play == false and menus.exit == false then
        love.graphics.draw(menus.mainmenu.image, 0, 0, 0, 1.8)
    end
    if menus.play == true then
        love.graphics.draw(menus.mainmenu.playimage, 0, 0, 0, 1.8)
    end
    if menus.exit == true then
        love.graphics.draw(menus.mainmenu.exitimage, 0, 0, 0, 1.8)
    end
    if menus.commands == true then
        love.graphics.draw(menus.mainmenu.commandsimage, 0, 0, 0, 1.8)
    end
    if menus.mainmenu.commandsstate == true then
        love.graphics.draw(menus.mainmenu.commandsscreenimage, 0, 0, 0, 1.8)
    end
    if menus.commandsmenu == true then
        love.graphics.draw(menus.mainmenu.commandsmenuimage, 0, 0, 0, 1.8)
    end
    if menus.mainmenu.areyousurestate == true then
        love.graphics.draw(menus.mainmenu.areyousurescreenimage, 0, 0, 0, 1.8)
    end
    if menus.areyousureyes == true then
        love.graphics.draw(menus.mainmenu.areyousureyesimage, 0, 0, 0, 1.8)
    end
    if menus.areyousureno == true then
        love.graphics.draw(menus.mainmenu.areyousurenoimage, 0, 0, 0, 1.8)
    end
    --[[if menus.mainmenu.areyousurestate == true then
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", 1030, 700, 500, 125)
    end]]
end
