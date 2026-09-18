item_hd_siren_clothing = class({})

LinkLuaModifier("modifier_item_hd_siren_clothing", "items/item_hd_siren_clothing", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_siren_clothing_debuff", "items/item_hd_siren_clothing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_siren_clothing_caster_debuff", "items/item_hd_siren_clothing", LUA_MODIFIER_MOTION_NONE)





function item_hd_siren_clothing:GetIntrinsicModifierName()
	return "modifier_item_hd_siren_clothing"
end
function item_hd_siren_clothing:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", context )
end

modifier_item_hd_siren_clothing = class({})

function modifier_item_hd_siren_clothing:IsDebuff() return false end
function modifier_item_hd_siren_clothing:IsHidden() return true end
function modifier_item_hd_siren_clothing:IsPurgable() return false end
function modifier_item_hd_siren_clothing:IsPurgeException() return false end
function modifier_item_hd_siren_clothing:RemoveOnDeath() return false end


function modifier_item_hd_siren_clothing:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	if IsServer() then
		local units = GetAllRealHeroes()
		local parent = self:GetParent()
		local debuff_add = false
		if not parent:IsNaga() then
			for  _, hero in pairs(units) do
				if hero~=parent then
					if hero:IsNaga() then
						local gameEvent = {}
						gameEvent["player_id"] = hero:GetPlayerOwnerID()
						gameEvent["teamnumber"] = -1
						gameEvent["message"] = "#DOTA_HUD_siren_clothing_info"..RandomInt(1, 4)
						FireGameEvent( "dota_combat_event_message", gameEvent )
						debuff_add = true
					end
				end
			end
		end
		if debuff_add then
			parent:AddNewModifier(parent, self.ability, "modifier_item_hd_siren_clothing_caster_debuff", {}) 
		end

	end
end
function modifier_item_hd_siren_clothing:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_hd_siren_clothing_caster_debuff")
	end
end
function modifier_item_hd_siren_clothing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	if not self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_naga_siren_2") then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end
	return funcs
end

function modifier_item_hd_siren_clothing:GetModifierBonusStats_Agility() return self.bonus_agi end
function modifier_item_hd_siren_clothing:GetModifierHealthBonus() return self.bonus_health end


function modifier_item_hd_siren_clothing:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	
	self:IncrementStackCount()
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	if 10>=RandomInt(1, 100) then
		local caster = self:GetCaster()
		if not caster:IsApplyModifier() then
			return
		end

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin())
		ParticleManager:SetParticleControl(effect_cast,1,Vector(300,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- caster:EmitSound("Hero_NagaSiren.RipTide.Precast")
		caster:EmitSound("Hero_NagaSiren.Riptide.Cast")
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units<=0 then
			return
		end
	
		local damageTable = {
			-- victim =keys.target,
			attacker = caster,
			damage =caster:GetAverageTrueAttackDamage(nil)*0.3,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = ability, 
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, 
		}
	
		
		for i, unit in ipairs(units) do
			damageTable.victim = unit
			ApplyDamage( damageTable )
			unit:AddNewModifier(caster, ability, "modifier_item_hd_siren_clothing_debuff", {duration=4}) 
			if i>=5 then
				break
			end
		end
		ability:UseResources(true, true, true, true)

	end

	
end




modifier_item_hd_siren_clothing_debuff = advanced_modifier({})

function modifier_item_hd_siren_clothing_debuff:IsHidden()	return false end
function modifier_item_hd_siren_clothing_debuff:IsDebuff()	return true end
function modifier_item_hd_siren_clothing_debuff:IsPurgable()	return true end
function modifier_item_hd_siren_clothing_debuff:GetTexture() return "item_siren_clothing" end

function modifier_item_hd_siren_clothing_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_item_hd_siren_clothing_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_item_hd_siren_clothing_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_siren_clothing_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -10
end







modifier_item_hd_siren_clothing_caster_debuff = advanced_modifier({})

function modifier_item_hd_siren_clothing_caster_debuff:IsDebuff() return true end
function modifier_item_hd_siren_clothing_caster_debuff:IsHidden() return false end
function modifier_item_hd_siren_clothing_caster_debuff:IsPurgable() return false end
function modifier_item_hd_siren_clothing_caster_debuff:IsPurgeException() return false end
function modifier_item_hd_siren_clothing_caster_debuff:RemoveOnDeath() return false end
function modifier_item_hd_siren_clothing_caster_debuff:GetTexture() return "item_siren_clothing" end
function modifier_item_hd_siren_clothing_caster_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,         
	}
end
function modifier_item_hd_siren_clothing_caster_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return 25
end

function modifier_item_hd_siren_clothing_caster_debuff:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end


function modifier_item_hd_siren_clothing_caster_debuff:OnTooltip()
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end



