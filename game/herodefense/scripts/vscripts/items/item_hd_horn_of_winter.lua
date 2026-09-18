item_hd_horn_of_winter =  item_hd_horn_of_winter or class({})

LinkLuaModifier("modifier_item_hd_horn_of_winter", "items/item_hd_horn_of_winter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_horn_of_winter_buff", "items/item_hd_horn_of_winter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_horn_of_winter_debuff", "items/item_hd_horn_of_winter", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_horn_of_winter:GetIntrinsicModifierName()
	return "modifier_item_hd_horn_of_winter"
end



function item_hd_horn_of_winter:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_self_dmg.vpcf", context )

end


modifier_item_hd_horn_of_winter = modifier_item_hd_horn_of_winter or advanced_modifier({})

function modifier_item_hd_horn_of_winter:IsDebuff() return false end
function modifier_item_hd_horn_of_winter:IsHidden() return true end
function modifier_item_hd_horn_of_winter:IsPurgable() return false end
function modifier_item_hd_horn_of_winter:IsPurgeException() return false end
function modifier_item_hd_horn_of_winter:RemoveOnDeath() return false end


function modifier_item_hd_horn_of_winter:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_summon_intensity =ability:GetSpecialValueFor("summon_intensity")
	self.bonus_health =ability:GetSpecialValueFor("bonus_health")

end



function modifier_item_hd_horn_of_winter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE

	}
end

function modifier_item_hd_horn_of_winter:GetModifierHealthBonus() return self.bonus_health end
function modifier_item_hd_horn_of_winter:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_horn_of_winter_buff", {})

		local pfx = ParticleManager:CreateParticle("particles/creatures/aghanim/aghanim_self_dmg.vpcf", PATTACH_ABSORIGIN, unit)
		local pos = unit:GetOrigin()
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 1, pos)
		DestroyParticleByDelay(pfx,2)
		unit:EmitSound("Hero_Lich.SinisterGaze.Target")

		caster:EmitSound("Hero_Crystal.CrystalNova")
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
		)
	

		for i,unit in pairs(enemies) do
			unit:AddNewModifier(caster, self, "modifier_item_hd_horn_of_winter_debuff", {duration = 6})
		end
	end
end

-- advanced_modifier
function modifier_item_hd_horn_of_winter:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_horn_of_winter:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end




modifier_item_hd_horn_of_winter_buff = advanced_modifier({})

function modifier_item_hd_horn_of_winter_buff:IsDebuff() return false end
function modifier_item_hd_horn_of_winter_buff:IsHidden() return false end
function modifier_item_hd_horn_of_winter_buff:IsPurgable() return false end

function modifier_item_hd_horn_of_winter_buff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		

	}
end


function modifier_item_hd_horn_of_winter_buff:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_item_hd_horn_of_winter_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_item_hd_horn_of_winter_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -15
end





modifier_item_hd_horn_of_winter_debuff = modifier_item_hd_horn_of_winter_debuff or advanced_modifier({})

function modifier_item_hd_horn_of_winter_debuff:IsDebuff()return true end
function modifier_item_hd_horn_of_winter_debuff:IsPurgable()return true end
function modifier_item_hd_horn_of_winter_debuff:GetTexture() return "item_horn_of_winter" end
function modifier_item_hd_horn_of_winter_debuff:OnCreated()
	self.frozen = true
	self:StartIntervalThink(0.5)

end

function modifier_item_hd_horn_of_winter_debuff:OnRefresh(keys)

	self.frozen = true
	self:StartIntervalThink(0.5)
end


function modifier_item_hd_horn_of_winter_debuff:OnIntervalThink()
	self.frozen  = false
end

function modifier_item_hd_horn_of_winter_debuff:CheckState()
	local state = {}
	if self.frozen then  
		state = {
			[MODIFIER_STATE_FROZEN] = true,
			[MODIFIER_STATE_STUNNED] = true
		}
	end

	return state
end



function modifier_item_hd_horn_of_winter_debuff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		

	}
end


function modifier_item_hd_horn_of_winter_debuff:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_item_hd_horn_of_winter_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_item_hd_horn_of_winter_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return 50
end
