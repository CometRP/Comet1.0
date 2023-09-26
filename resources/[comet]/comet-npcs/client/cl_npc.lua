_npcNPC = {}

DecorRegister('NPC', 2)
DecorRegister('NPC_ID', 3)

function _npcNPC:new(id, pedType, model, position, appearance, animation, networked, settings, flags, scenario, blip, target)
    local this = {}

    this.id = id
    this.type = pedType
    this.model = GetHashKey(model)
    this.position = position
    this.appearance = appearance
    this.animation = animation
    this.networked = networked
    this.settings = settings
    this.flags = flags
    this.scenario = scenario
    this.blip = blip
    this.target = target

    this.entity = nil
    this.spawned = false
    this.disabled = false
    this.tasks = {}

    self.__index = self

    return setmetatable(this, self)
end

function _npcNPC:spawn()
    if self.spawned then return end

    LoadEntityModel(self.model)

    local ped = CreatePed(self.type, self.model, self.position.coords, self.position.heading + 0.0, self.networked, false)
    print(ped)
    Citizen.Wait(0)

    SetPedDefaultComponentVariation(ped)

    if DoesEntityExist(ped) then
        self.entity, self.spawned = ped, true

        DecorSetInt(self.entity, 'NPC_ID', GetHashKey(self.id))

        if self.target then 
            self:setTarget(self.entity, self.target)
        end

        if self.settings then
            self:setSettings()
        end

        if self.appearance then
            self:setAppearance()
        end

        if self.animation then
            self:setAnimation(self.animation.testdic, self.animation.testanim)
        end

        if self.scenario then
            self:setScenario()
        end
    end

    SetModelAsNoLongerNeeded(self.model)
end

function _npcNPC:delete()
    if not self.spawned then return end

    self.spawned = false

    if DoesEntityExist(self.entity) then
        DeleteEntity(self.entity)
    end
end

function _npcNPC:enable()
    self.disabled = false
end

function _npcNPC:disable()
    self.disabled = true
end

function _npcNPC:setSettings(settings)
    if settings then self.settings = settings end

    for _, flag in ipairs(self.settings) do
        self:setSetting(flag.mode, flag.active, self.settings)
    end
end

function _npcNPC:setTarget(ped, target)
    if ped then self.entity = ped end
    if target then self.target = target end
    exports['comet-target']:AddTargetEntity(self.entity, self.target)
end

function _npcNPC:setSetting(mode, active, settings)
    if mode == 'invincible' then
        SetEntityInvincible(self.entity, active)
    elseif mode == 'freeze' then
        FreezeEntityPosition(self.entity, active)
    elseif mode == 'ignore' then
        SetBlockingOfNonTemporaryEvents(self.entity, active)
    elseif mode == 'collision' then
        SetEntityCompletelyDisableCollision(self.entity, false, false)
        SetEntityCoordsNoOffset(self.entity, self.position.coords, false, false, false)
    elseif mode == 'casino' and active then
        math.randomseed(GetGameTimer())
        math.random() math.random() math.random()
        local isMale = false
        for _, v in pairs(settings) do
          if v.mode == 'casinoMale' then
            isMale = v.active
          end
        end
    end
end

function _npcNPC:setAppearance(appearance)
    if appearance then self.appearance = appearance end

    for _, component in pairs(self.appearance) do
        self:setComponent(component.mode, table.unpack(component.params))
    end
end

function _npcNPC:setComponent(mode, ...)
    if mode == 'component' then
        SetPedComponentVariation(self.entity, ...)
    elseif mode == 'prop' then
        SetPedPropIndex(self.entity, ...)
    elseif mode == 'blend' then
        SetPedHeadBlendData(self.entity, ...)
    elseif mode == 'overlay' then
        SetPedHeadOverlay(self.entity, ...)
    elseif mode == 'overlaycolor' then
        SetPedHeadOverlayColor(self.entity, ...)
    elseif mode == 'haircolor' then
        SetPedHairColor(self.entity, ...)
    elseif mode == 'eyecolor' then
        SetPedEyeColor(self.entity, ...)
    end
end

function _npcNPC:addTask(id, task)
    if self.tasks[id] then self:removeTask(id) end

    self.tasks[id] = {id = id, active = false, task = task}
end

function _npcNPC:removeTask(id)
    if not self.tasks[id] then return end

    self.tasks[id]['active'] = false
    self.tasks[id] = nil
end

function _npcNPC:startTask(id)
    if not self.tasks[id] or self.tasks[id]['active'] then return end

    self.tasks[id]['active'] = true
    self.tasks[id]:task(self.tasks[id])
end

function _npcNPC:stopTask(id)
    if not self.tasks[id] or not self.tasks[id]['active'] then return end

    self.tasks[id]['active'] = false
end

function _npcNPC:setScenario()
    TaskStartScenarioInPlace(self.entity, self.scenario, 0, true)
end

function _npcNPC:setAnimation(animDic, animIdx)

    RequestAnimDict(animDic)
    while not HasAnimDictLoaded(animDic) do
        Citizen.Wait(0)
    end

    if IsEntityPlayingAnim(self.entity, animDic, animIdx, 3) then
        ClearPedSecondaryTask(self.entity)
    else
        local animLength = GetAnimDuration(animDic, animIdx)
        TaskPlayAnim(self.entity, animDic, animIdx, 1.0, 1.0, -1, 1, -1, 0, 0, 0)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function LoadEntityModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)

        while not HasModelLoaded do
            Citizen.Wait(0)
        end
    end
end