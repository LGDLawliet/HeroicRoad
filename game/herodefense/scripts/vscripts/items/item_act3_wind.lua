
LinkLuaModifier("modifier_item_act3_wind", "items/item_act3_wind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_wind_1", "items/item_act3_wind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_wind_3", "items/item_act3_wind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_wind_charge_cd", "items/item_act3_wind.lua", LUA_MODIFIER_MOTION_NONE)
item_act3_wind = class({})
function item_act3_wind:Precache(context)
    --PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", context)
end
function item_act3_wind:Spawn()
    if IsServer() then
		self:SetCurrentCharges(0)
        if IsInToolsMode() then
            self:SetCurrentCharges(90)
        end
	end
end
function item_act3_wind:GetIntrinsicModifierName()
    return "modifier_item_act3_wind"
end
----
modifier_item_act3_wind = advanced_modifier({})

function modifier_item_act3_wind:IsHidden() return true end
function modifier_item_act3_wind:IsDebuff() return false end
function modifier_item_act3_wind:IsPurgable() return false end
function modifier_item_act3_wind:RemoveOnDeath() return false end

function modifier_item_act3_wind:GrowEvent()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.ability:SetCurrentCharges(math.max(math.min(self.ability:GetCurrentCharges()+1, GetWave()*5), 1))
end

function modifier_item_act3_wind:OnCreated()    
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.point_move = self.ability:GetSpecialValueFor("point_move")
    self.need = self.ability:GetSpecialValueFor("need")
    self.need_1 = self.ability:GetSpecialValueFor("need_1")
    self.outgoing_1 = self.ability:GetSpecialValueFor("outgoing_1")
    self.duration_1 = self.ability:GetSpecialValueFor("duration_1")
    self.check2 = self.ability:GetSpecialValueFor("check2")
    self.incoming_2 = self.ability:GetSpecialValueFor("incoming_2")
    self.need_2 = self.ability:GetSpecialValueFor("need_2")
    self.check3 = self.ability:GetSpecialValueFor("check3")
    self.damage_3 = self.ability:GetSpecialValueFor("damage_3")*0.01
    self.check4 = self.ability:GetSpecialValueFor("check4")
    self.evasion_4 = self.ability:GetSpecialValueFor("evasion_4")
    self.chance_4 = self.ability:GetSpecialValueFor("chance_4")
    self.max_4 = self.ability:GetSpecialValueFor("max_4")
    -- 伤害和射程参数
    self.damage_atk_index = 0.5
    self.damage_atb_index = 2.4
    self.base_damage = 100
    self.bonus_damage_pct = 0.05
    self.duration = 0.4
    self.length = 700
    self.bonus_length = 8
    
    self.cd = 1

    -- 同一个modifier下的damagetable要在oncreate的时候就创立，随后进行补充以节省性能
    if IsServer() then
        self.prevLoc = self.parent:GetAbsOrigin()

        -- 初始化各级距离事件的独立计数器
        self.move_dis_2 = 0
        self.move_dis_1 = 0
        self.move_dis_grow = 0
        
        self:StartIntervalThink(0.03)
    end
end

function modifier_item_act3_wind:OnIntervalThink()
    if not self.parent:IsAlive() then return end
    if not self:GetAbility() then return end

    local caster = self:GetCaster()
    local dis = CalculateDistance(self.prevLoc, self.parent)
    self.prevLoc = self:GetParent():GetAbsOrigin()
    self.move_dis_2 = self.move_dis_2 + dis
    self.move_dis_1 = self.move_dis_1 + dis
    self.move_dis_grow = self.move_dis_grow + dis

    if self.move_dis_1 >= self.need_1 then
        self:MoveEvent_1()
        self.move_dis_1 = self.move_dis_1 - self.need_1
    end
    if self.move_dis_2 >= self.need_2 then
        local cd = self.parent:HasModifier("modifier_item_act3_wind_charge_cd")
        if not cd then
            self.radius = self.length + self.ability:GetCurrentCharges()*self.bonus_length
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            if #enemies >= 1 then
                local target = enemies[1]
                local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin())
                direction.z = 0
                direction = direction:Normalized()
                self:MoveEvent_2(direction, caster:GetAbsOrigin())
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act3_wind_charge_cd", {duration = self.cd})
            end
        end
        self.prevLoc = self:GetParent():GetAbsOrigin()
        
        self.move_dis_2 = self.move_dis_2 - self.need_2
    end
    if self.move_dis_grow >= self.need then
        self:GrowEvent()
        self.move_dis_grow = self.move_dis_grow - self.need
    end
end
function modifier_item_act3_wind:CheckState()
    if self.ability:GetCurrentCharges() >= self.check4 then
        return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
    end
end
function modifier_item_act3_wind:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_item_act3_wind:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_item_act3_wind:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if self.ability:GetCurrentCharges() >= self.check2 and keys.damage_type == DAMAGE_TYPE_PHYSICAL then
        return -self.incoming_2
    end
end
function modifier_item_act3_wind:GetModifierEvasion_Constant()
    if self.ability:GetCurrentCharges() >= self.check4 and self.parent:IsMoving() then
        return self.evasion_4
    end
end
function modifier_item_act3_wind:GetModifierMoveSpeedBonus_Percentage()
    return (self.ability:GetCurrentCharges()*self.point_move) or 0
end
function modifier_item_act3_wind:GetModifierIgnoreMovespeedLimit()
    return 1
end


function modifier_item_act3_wind:MoveEvent_1()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    -- if self.ability:GetCurrentCharges() < self.need_1 then return end
    ProjectileManager:ProjectileDodge(self.parent) --弹道躲闪
    local buff = self.parent:FindModifierByName("modifier_item_act3_wind_1")
    if buff then
        buff:SetStackCount(self.outgoing_1)
        buff:ForceRefresh()
        buff:SetDuration(self.duration_1, true)
    else
        local newbuff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act3_wind_1", {duration = self.duration_1})
        if newbuff then
            newbuff:SetStackCount(self.outgoing_1)
        end
    end
end

function modifier_item_act3_wind:MoveEvent_2(direction, start_position)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if self.ability:GetCurrentCharges() < self.check2 then return end
    if not direction or not start_position then return end
    
    local caster = self.parent
    local ability = self.ability
    local adaptdamagetable = GetAdaptDamage(caster:GetAverageTrueAttackDamage(nil), self.damage_atk_index, caster:HDGetPrimaryStatValue(), self.damage_atb_index)
    local damage = (self.base_damage + adaptdamagetable.damage) * (1+self.ability:GetCurrentCharges()*self.bonus_damage_pct)
    local damage_type = adaptdamagetable.type
	local projectile_name = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
    self.radius = self.length + self.ability:GetCurrentCharges()*self.bonus_length
    local speed = self.radius/self.duration
	local distance = self.radius+30
	local start_radius = 225
	local end_radius = 225

	local spawnPos = start_position
    local target_pos = spawnPos + direction* distance
	local info = {
		Source = caster,
		Ability = ability,
		vSpawnOrigin = spawnPos,

	    bDeleteOnHit = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius =end_radius,
		vVelocity = direction * speed,

		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
        ExtraData = {
            damage = damage,
            damage_type = damage_type,
        }
	}

    if self.ability:GetCurrentCharges() >= self.check3 then
        info.ExtraData.damage = info.ExtraData.damage * (1+self.damage_3)
    end

	local projectile = ProjectileManager:CreateLinearProjectile(info)
    caster:EmitSoundParams("Ability.PowershotPull",0,0.7,0)
    local enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, target_pos,nil, start_radius, info.iUnitTargetTeam, info.iUnitTargetType, info.iUnitTargetFlags)
    for _,enemy in pairs(enemies)do
        local distance = CalculateDistance(enemy,caster)
        local delay = distance/speed
        caster:GameTimer(delay,function()
            if enemy:IsAlive() and IsValid(self) then
                self.ability:OnProjectileHit_Item(enemy, info.ExtraData)
            end
        end)
    end
end
function item_act3_wind:OnProjectileHit_Item(target, extraData)
    if not IsServer() then return end
    if not target then return end
    
    local caster = self:GetCaster()
    local damage = extraData.damage
    local duration_3 = self:GetSpecialValueFor("duration_3")
    local check3 = self:GetSpecialValueFor("check3")
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = extraData.damage_type,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self,
        -- hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
    }
    ApplyDamage(damageTable)
    
    if self:GetCurrentCharges() >= check3 then
        caster:AddNewModifier(caster, self, "modifier_item_act3_wind_3", {duration = duration_3})
    end
end

-----
modifier_item_act3_wind_charge_cd = advanced_modifier({})

function modifier_item_act3_wind_charge_cd:IsHidden() return true end
function modifier_item_act3_wind_charge_cd:IsDebuff() return false end
function modifier_item_act3_wind_charge_cd:IsPurgable() return false end
function modifier_item_act3_wind_charge_cd:RemoveOnDeath() return false end
function modifier_item_act3_wind_charge_cd:GetTexture() return "item_act3_wind" end

-----
modifier_item_act3_wind_1 = advanced_modifier({})

function modifier_item_act3_wind_1:IsHidden() return false end
function modifier_item_act3_wind_1:IsDebuff() return false end
function modifier_item_act3_wind_1:IsPurgable() return false end
function modifier_item_act3_wind_1:GetTexture() return "item_act3_wind" end
function modifier_item_act3_wind_1:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_item_act3_wind_1:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

----
modifier_item_act3_wind_3 = advanced_modifier({})
function modifier_item_act3_wind_3:IsHidden()	return false end
function modifier_item_act3_wind_3:IsDebuff()	return false end
function modifier_item_act3_wind_3:IsPurgable()	return false end

function modifier_item_act3_wind_3:OnCreated(params)
	self.ability = self:GetAbility()
	self.bonus_3 = self.ability:GetSpecialValueFor("bonus_3")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_act3_wind_3:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		if self:GetStackCount()>= 1000 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_item_act3_wind_3:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_item_act3_wind_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end
function modifier_item_act3_wind_3:GetModifierMoveSpeedBonus_Constant()
    if not self:GetAbility() then return end
    return self:GetStackCount()*self.bonus_3
end