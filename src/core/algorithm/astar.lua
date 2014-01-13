AStar = class("AStar")

function AStar:__init()
end

function AStar:find(start, goal)
    self.openlist = {}
    self.closedlist = {}
    self.openlist[start.index] = start
    start.g = 0
    start.f = start.g + distanceBetweenEntities(start.entity , goal.entity)

    while table.count(self.openlist) ~= 0 do
        local active = self:getLowestF()

        for index, child in pairs(active.child) do
            if not child.entity:getComponent("Collidable") then
                local reactivated = false
                local notcontained = false
                local alreadyopen = false
                if self.closedlist[child.index] then
                    if child.g + distanceBetweenEntities(child.entity, active.entity) < active.g and active.parent ~= child then
                        self.closedlist[child.index] = nil
                        reactivated = true
                    end
                elseif self.openlist[child.index] then
                    if child.g + distanceBetweenEntities(child.entity, active.entity) < active.g and active.parent ~= child then
                        alreadyopen = true
                    end
                else
                    notcontained = true
                end
                if notcontained or reactivated or alreadyopen then
                    child.g = active.g + distanceBetweenEntities(child.entity, active.entity)
                    child.f = child.g + distanceBetweenEntities(child.entity, goal.entity)
                    child.parent = active
                    child.entity:getComponent("TileComponent").active = true
                    if child == goal then
                        return self:getPath(child)                        
                    elseif not alreadyopen then
                        self.openlist[child.index] = child
                    end
                end
            end
            self.openlist[active.index] = nil
            self.closedlist[active.index] = active
        end
    end
end

function AStar:getLowestF()
    local lowest = table.firstElement(self.openlist)
    for index, value in pairs(self.openlist) do
        if value.f < lowest.f then
            lowest = value
        end
    end
    return lowest
end

function AStar:getPath(element)
    local path = {}
    local tile = element
    local time = os.time()
    while tile do
        local elapsed = os.time() - time
        if elapsed > 1 then
            break
        end  
        table.insert(path, tile)
        if tile.parent then
            tile = tile.parent
        else
            tile = nil
        end
    end
    local correctPath = {}
    for i = #path, 1, -1 do
        table.insert(correctPath, path[i])
    end
    return correctPath 
end