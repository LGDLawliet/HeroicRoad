item_hd_sea_freedom_effects = class({})
LinkLuaModifier("modifier_item_hd_sea_freedom_effects", "player_artifact/item_hd_sea_freedom_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sea_freedom_effects_lv10", "player_artifact/item_hd_sea_freedom_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sea_freedom_effects_lv20", "player_artifact/item_hd_sea_freedom_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sea_freedom_effects_check", "player_artifact/item_hd_sea_freedom_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_sea_freedom_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_sea_freedom_effects"
end
function item_hd_sea_freedom_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush1.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context )
end
modifier_item_hd_sea_freedom_effects = advanced_modifier({})

function modifier_item_hd_sea_freedom_effects:IsDebuff() return false end
function modifier_item_hd_sea_freedom_effects:IsHidden() return true end
function modifier_item_hd_sea_freedom_effects:IsPurgable() return false end
function modifier_item_hd_sea_freedom_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.apply = false
    self.count = 1
    self.bonus_full_damage = self.ability:GetArtifactSpecialValueFor("bonus_full_damage")
    self.attack_speed = self.ability:GetArtifactSpecialValueFor("attack_speed")
	self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.index = self.ability:GetArtifactSpecialValueFor("index")-100
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
	self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
	self.outgoing_2 = self.ability:GetArtifactSpecialValueFor("outgoing_2")
	self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
	self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
	self.index_3 = self.ability:GetArtifactSpecialValueFor("index_3")-100
	self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
	self.heal_4 = self.ability:GetArtifactSpecialValueFor("heal_4")*0.01
	self.count_7 = self.ability:GetArtifactSpecialValueFor("count_7")
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_sea_freedom_effects")
	
    if self.level >= 30 then
        self.duration_1 = self.duration_3
    end
    if self.level >= 40 then
        self.apply = true
    end
    if self.level >= 70 then
        self.count = self.count + self.count_7
        self.outgoing_2 = self.outgoing_7
    end

    if IsServer() then
        self.damage_source = nil
        self.damage_time = 0
    end
end
function modifier_item_hd_sea_freedom_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.apply = false
    self.count = 1
    self.bonus_full_damage = self.ability:GetArtifactSpecialValueFor("bonus_full_damage")
    self.attack_speed = self.ability:GetArtifactSpecialValueFor("attack_speed")
	self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.index = self.ability:GetArtifactSpecialValueFor("index")-100
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
	self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
	self.outgoing_2 = self.ability:GetArtifactSpecialValueFor("outgoing_2")
	self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
	self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
	self.index_3 = self.ability:GetArtifactSpecialValueFor("index_3")-100
	self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
	self.heal_4 = self.ability:GetArtifactSpecialValueFor("heal_4")*0.01
	self.count_7 = self.ability:GetArtifactSpecialValueFor("count_7")
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")
	self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_sea_freedom_effects")
	
    if self.level >= 30 then
        self.duration_1 = self.duration_3
    end
    if self.level >= 40 then
        self.apply = true
    end
    if self.level >= 70 then
        self.count = self.count + self.count_7
        self.outgoing_2 = self.outgoing_7
    end

    if IsServer() then
        self.damage_source = nil
        self.damage_time = 0
    end
end
function modifier_item_hd_sea_freedom_effects:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_item_hd_sea_freedom_effects:Advanced_GetModifierAttackSpeedPercentage()
	return -self.attack_speed
end
function modifier_item_hd_sea_freedom_effects:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.bonus_full_damage
end
function modifier_item_hd_sea_freedom_effects:OnAttackLanded(keys)
	if not IsServer() then
        return 
	end
    local target = keys.target
    local attacker = keys.attacker
    if attacker ~= self.parent or not attacker:IsAlive() then return end
    if not attacker:IsApplyModifier() or attacker:IsInSpecialAttack() then return end
    if not target then return end

    if self.level >= 40 and IsValid(self.damage_source) and (GameRules:GetGameTime() - self.damage_time) <= self.duration_4 then
        if self.damage_source:IsAlive() then
            if target == self.damage_source then
                local heal_amount = self.last_damage * self.heal_4
                attacker:Heal(heal_amount, self.ability)
                attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_sea_freedom_effects_lv10", {duration = self.duration_1})
                self.damage_source = nil
            end
        end
    end
	
	if target:GetTeamNumber() ~= attacker:GetTeamNumber() and not keys.no_attack_cooldown and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
		local target_number = 0
        local apply = self.apply
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 1,
			iDisableCleave =1,
			iDisableSplit = 1,
		}
		if apply then
            modifier_keys.iDisableApplyModifier = 0
        end
		local attackEffectRecord = attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)

        if #enemies <= 0 then
            if self.level >= 20 then
                local modifier = attacker:FindModifierByName("modifier_item_hd_sea_freedom_effects_lv20")
                if not modifier then
                    attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_sea_freedom_effects_lv20", {duration = self.duration_2, outgoing = self.outgoing_2})
                else
                    modifier:SetDuration(self.duration_2, true)
                end
            end
        end

		for _, enemy in pairs(enemies) do
			if enemy ~= target then
                self:PlayEffects(enemy)
                attacker:EmitSoundParams("Ability.GushCast",0,0.4,0)
				attacker.freedom_shoot_target = true
				attacker:PerformAttack(enemy, apply, apply, true, false, false, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
				attacker.freedom_shoot_target = false
                if self.level >= 10 and IsValid(enemy) then
                    if not enemy:IsAlive() then
                        attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_sea_freedom_effects_lv10", {duration = self.duration_1})
                    end
                end
				target_number = target_number + 1
				if target_number >= self.count then
					break
				end
			end
		end
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		return
	end
end
function modifier_item_hd_sea_freedom_effects:PlayEffects(target)
    if not IsServer() then return end
    if not target or not target:IsAlive() then return end
    local parent = self:GetParent()
    local particle = ParticleManager:CreateParticle("particles/rebuild/items/shisui/water_gush1.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, Vector(3000,0,0))
    DestroyParticleByDelay(particle, 0.3)
end
function modifier_item_hd_sea_freedom_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if not IsServer() then return end
    local index = self.index
    if self.level >= 30 and self.parent:HasModifier("modifier_item_hd_sea_freedom_effects_lv10") then
        index = self.index_3
    end
	if self.parent.freedom_shoot_target then
		return index
	end
    return 0
end

-- 记录受到的伤害用于莫比乌斯流
function modifier_item_hd_sea_freedom_effects:OnTakeDamage(keys)
	if not IsServer() then return end
	if self.level < 40 then return end

	local unit = keys.unit
	local attacker = keys.attacker
	local damage = keys.damage
	
	if unit == self:GetParent() and attacker and attacker:IsAlive() then
		self.damage_source = attacker
		self.last_damage = damage
		self.damage_time = GameRules:GetGameTime()
	end
end
-- check modifier
modifier_item_hd_sea_freedom_effects_check = advanced_modifier({})
function modifier_item_hd_sea_freedom_effects_check:IsDebuff() return false end
function modifier_item_hd_sea_freedom_effects_check:IsHidden() return true end
function modifier_item_hd_sea_freedom_effects_check:IsPurgable() return false end
-- 水流环 modifier
modifier_item_hd_sea_freedom_effects_lv10 = advanced_modifier({})

function modifier_item_hd_sea_freedom_effects_lv10:IsDebuff() return false end
function modifier_item_hd_sea_freedom_effects_lv10:IsHidden() return false end
function modifier_item_hd_sea_freedom_effects_lv10:IsPurgable() return false end
function modifier_item_hd_sea_freedom_effects_lv10:GetTexture() return "item_artifact_71" end

function modifier_item_hd_sea_freedom_effects_lv10:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_item_hd_sea_freedom_effects_lv10:OnCreated(keys)
	local ability = self:GetAbility()
	self.incoming_1 = ability:GetArtifactSpecialValueFor("incoming_1")	
    if IsServer() then
        local parent = self:GetParent()
        EmitSoundOn("Hero_Morphling.Waveform", parent)	
        local unit_pos = parent:GetAbsOrigin()
        local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
        for i = 1, 3, 1 do
            local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
            local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
            local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, parent)
            ParticleManager:SetParticleControl(pfx, 0, new_pos)
            ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
            parent:GameTimer(1.3, function()
                ParticleManager:DestroyParticle(pfx, false)
                ParticleManager:ReleaseParticleIndex( pfx )
            end)	
        end
    end
end
function modifier_item_hd_sea_freedom_effects_lv10:OnRefresh(keys)
	local ability = self:GetAbility()
	self.incoming_1 = ability:GetArtifactSpecialValueFor("incoming_1")	
    if IsServer() then
        local parent = self:GetParent()
        EmitSoundOn("Hero_Morphling.Waveform", parent)	
        local unit_pos = parent:GetAbsOrigin()
        local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
        for i = 1, 3, 1 do
            local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
            local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
            local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, parent)
            ParticleManager:SetParticleControl(pfx, 0, new_pos)
            ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
            parent:GameTimer(1.3, function()
                ParticleManager:DestroyParticle(pfx, false)
                ParticleManager:ReleaseParticleIndex( pfx )
            end)	
        end
    end
end
function modifier_item_hd_sea_freedom_effects_lv10:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
	return -self.incoming_1
end

-- 汇聚 modifier
modifier_item_hd_sea_freedom_effects_lv20 = advanced_modifier({})
function modifier_item_hd_sea_freedom_effects_lv20:IsDebuff() return false end
function modifier_item_hd_sea_freedom_effects_lv20:IsHidden() return false end
function modifier_item_hd_sea_freedom_effects_lv20:IsPurgable() return false end
function modifier_item_hd_sea_freedom_effects_lv20:GetTexture() return "item_artifact_71" end
function modifier_item_hd_sea_freedom_effects_lv20:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_item_hd_sea_freedom_effects_lv20:OnCreated(keys)
	if IsServer() then
		self.outgoing = keys.outgoing
        self:SetStackCount(self.outgoing)
	end
end
function modifier_item_hd_sea_freedom_effects_lv20:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not self:GetAbility() then self:Destroy() return end
    if keys.damage_category == "DOTA_DAMAGE_CATEGORY_ATTACK" then
        print("生效")
        return self:GetStackCount()
    end
	return 0
end
