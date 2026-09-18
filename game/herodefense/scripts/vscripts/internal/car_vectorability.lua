print("VectorAbility loaded")

if IsServer() then
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(function(context, event)
		local ability = EntIndexToHScript(event.entindex_ability)
		if ability and ability.__vectorability then
			if event.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
				print(Vector(event.position_x, event.position_y, event.position_z))
				ability.__vtarget = Vector(event.position_x, event.position_y, event.position_z)
			end
		end
		return true
	end, GameRules:GetGameModeEntity())
end
---
---@type fun(initializer:fun(ability:CAR_VectorAbility):void):CAR_VectorAbility
VectorAbility = setmetatable({
	---@available:client
	GetClickBehaviors = function(self)
		if not IsClient() then return -1 end
		local player = Entities:GetLocalPlayer()
		return player:GetClickBehaviors()
	end,
	GetVectorIndicator = function(self)
		return "particles/ui_mouseactions/range_finder_cone.vpcf"
	end,
	UpdateIndicator = function(self, location, indicator, isvectorcast)
		ParticleManager:SetParticleControl(self.__indicator, 1, self.__target)
		ParticleManager:SetParticleControl(self.__indicator, 2, location)
		ParticleManager:SetParticleControl(self.__indicator, 3, Vector(128, 128, 0))
		ParticleManager:SetParticleControl(self.__indicator, 4, Vector(100, 255, 0))
		ParticleManager:SetParticleControl(self.__indicator, 6, Vector(1, 0, 0))
	end
}, {
	__call = function(class, initializer)
		local ability = {}
		if type(initializer) == 'function' then
			initializer(ability)
		else
			error("initializer must be a function")
		end
		---
		local interface = IsServer()
			and
			{
				__vectorability = true,
				__vtarget = Vector(0, 0, 0),
				OnSpellStart = function(self)
					if type(self.__OnSpellStart) == 'function' then
						self:__OnSpellStart()
					end
					self.__vtarget = Vector(0, 0, 0)
				end,
				GetVectorCastPosition = function(self)
					return self.__vtarget
				end
			}
			or
			{
				__vectorability = true,
				__target = Vector(0, 0, 0),
				__indicator = -1,
				__lastframe = -1,

				GetVectorLocator = function(self)
					return self.__target
				end,
				CastFilterResultLocation = function(self, location)
					self.__lastframe = GetFrameCount()
					local behavior = class:GetClickBehaviors()
					local isvectorcast = behavior == DOTA_CLICK_BEHAVIOR_VECTOR_CAST
					--
					if not isvectorcast then
						self.__target = location
					end
					if self.__indicator == -1 then
						local particlename, preindicator = (self.GetVectorIndicator and self:GetVectorIndicator() or class.GetVectorIndicator(self))
						if isvectorcast or preindicator then
							local particle = ParticleManager:CreateParticle(particlename, PATTACH_WORLDORIGIN, nil)
							ParticleManager:SetParticleShouldCheckFoW(particle, false)
							self.__indicator = particle
						end
					end
					if self.__indicator ~= -1 then
						if self.UpdateIndicator then
							self:UpdateIndicator(location, self.__indicator, isvectorcast)
						else
							class.UpdateIndicator(self, location, self.__indicator, isvectorcast)
						end
					end

					--
					if type(self.__CastFilterResultLocation) == 'function' then
						return self:__CastFilterResultLocation(location)
					end
				end,
				GetBehavior = function(self)
					if GetFrameCount() > self.__lastframe + 1 then
						ParticleManager:DestroyParticle(self.__indicator, true)
						self.__indicator = -1
						self.__target = Vector(0, 0, 0)
					end
					return self.BaseClass.GetBehavior(self)
				end,
			}
		for i, f in pairs(interface) do
			if not ability[i] or type(ability[i]) == type(f) then
				if type(ability[i]) == 'function' then
					ability['__' .. i] = ability[i]
					ability[i] = f
				else
					ability[i] = f
				end
			end
		end
		return ability
	end
})

-----------------某插件
print("运行到这里了")
---@class ModelFunctionList
---@field list table
---@field set table
---@field insert function
---@field remove function
---@field iterate function
local function createModelFunctionList()
    local list = {}
    local set = {}
    return {
        list = list,
        set = set,
        insert = function(self, func)
            if not self.set[func] then
                table.insert(self.list, func)
                self.set[func] = true
            end
        end,
        remove = function(self, func)
            if self.set[func] then
                for i, v in ipairs(self.list) do
                    if v == func then
                        table.remove(self.list, i)
                        self.set[func] = nil
                        break
                    end
                end
            end
        end,
        iterate = function(self)
            return ipairs(self.list)
        end
    }
end
function InsertModelModify(ability, time, Modelfunction)
    ability.modelFunctionTable = ability.modelFunctionTable or {}
    if not ability.modelFunctionTable[time] then
        ability.modelFunctionTable[time] = createModelFunctionList()
    end
    
    ability.modelFunctionTable[time]:insert(Modelfunction)
end

function RunModelModify(ability, time)
    local modelFunctionTimeTable = (ability.modelFunctionTable and ability.modelFunctionTable[time]) or createModelFunctionList()
    if modelFunctionTimeTable then
        for _, v in modelFunctionTimeTable:iterate() do
            if v then
                v(ability)
            end
        end
    end
	-- -- 输出 list 和 set 的长度
    -- print("list 长度为 " .. #modelFunctionTimeTable.list)

    -- -- 使用 pairs 遍历 set 表
    -- local setCount = 0
    -- for _ in pairs(modelFunctionTimeTable.set) do
    --     setCount = setCount + 1
    -- end
    -- print("set 长度为 " .. setCount)

    -- -- 打印 set 表中的所有键（即函数引用）
    -- for func, _ in pairs(modelFunctionTimeTable.set) do
    --     print("set 中的函数引用: " .. tostring(func))
    -- end
end

function RemoveModelModify(ability, time, Modelfunction)
    if not ability.modelFunctionTable then
        return
    end
    local modelFunctionTimeTable = ability.modelFunctionTable[time]
    if modelFunctionTimeTable then
        modelFunctionTimeTable:remove(Modelfunction)
    end
end

----------------------------------------------
