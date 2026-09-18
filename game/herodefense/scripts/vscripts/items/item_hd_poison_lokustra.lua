LinkLuaModifier( "modifier_item_hd_poison_lokustra", "items/item_hd_poison_lokustra.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_poison_lokustra_active", "items/item_hd_poison_lokustra.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_poison_lokustra_spell", "items/item_hd_poison_lokustra.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if item_hd_poison_lokustra == nil then
	item_hd_poison_lokustra = class({})
end

function item_hd_poison_lokustra:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
end

function item_hd_poison_lokustra:GetIntrinsicModifierName()
	return "modifier_item_hd_poison_lokustra"
end

function item_hd_poison_lokustra:GetCastRange()
	return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus()
end

function item_hd_poison_lokustra:OnSpellStart()
	if not IsServer() then
		return
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_poison_lokustra_spell", {duration = self:GetSpecialValueFor("duration")})
end
---------------------------------------------------------------------
--Modifiers
modifier_item_hd_poison_lokustra = advanced_modifier({})
function modifier_item_hd_poison_lokustra:IsDebuff() return false end
function modifier_item_hd_poison_lokustra:IsHidden() return true end
function modifier_item_hd_poison_lokustra:IsPurgable() return false end
function modifier_item_hd_poison_lokustra:IsPurgeException() 	return false end

function modifier_item_hd_poison_lokustra:IsAura() return true end
function modifier_item_hd_poison_lokustra:GetAuraDuration() return 0.5 end
function modifier_item_hd_poison_lokustra:GetModifierAura() return "modifier_item_hd_poison_lokustra_active" end
function modifier_item_hd_poison_lokustra:GetAuraRadius() return  self.radius end
function modifier_item_hd_poison_lokustra:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_item_hd_poison_lokustra:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_poison_lokustra:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_item_hd_poison_lokustra:OnCreated(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_damage_topoison = self:GetAbility():GetSpecialValueFor("bonus_damage_topoison")
	self.lifesteal_topoison = self:GetAbility():GetSpecialValueFor("lifesteal_topoison")*0.01
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
end

function modifier_item_hd_poison_lokustra:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
	}
end

function modifier_item_hd_poison_lokustra:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then
			local poison = keys.target:FindModifierByName("modifier_hd_poison")
			if poison then
				return	self.bonus_damage_topoison
			end
		end
	end
	return 0
end

function modifier_item_hd_poison_lokustra:OnTakeDamage(keys)
    if IsServer() then   
		local unit = self:GetParent()
        if keys.attacker==unit and 
			not unit:IsIllusion() and 
			keys.inflictor~=nil and 
			bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and  
			bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 
				
			local poison = keys.unit:FindModifierByName("modifier_hd_poison")
			if not poison then
				return
			end

            local life_steal_gain = unit:GetModifierLifeStealGain(1)
            local recover = keys.damage * self.lifesteal_topoison * life_steal_gain

            if recover<=0 then return end   --没有吸血效果了就不执行了
            unit:Heal(recover, self:GetAbility())
        end 
    end 
end

-----------------------
modifier_item_hd_poison_lokustra_active = advanced_modifier({})
function modifier_item_hd_poison_lokustra_active:IsDebuff() return true end
function modifier_item_hd_poison_lokustra_active:IsHidden() return false end
function modifier_item_hd_poison_lokustra_active:IsPurgable() return false end


function modifier_item_hd_poison_lokustra_active:OnCreated(params)
	self.poison_interval_up = self:GetAbility():GetSpecialValueFor("poison_interval_up")
	self.poison_res_down = self:GetAbility():GetSpecialValueFor("poison_res_down")
end

function modifier_item_hd_poison_lokustra_active:OnRefresh(params)
	self.poison_interval_up = self:GetAbility():GetSpecialValueFor("poison_interval_up")
	self.poison_res_down = self:GetAbility():GetSpecialValueFor("poison_res_down")
end

function modifier_item_hd_poison_lokustra_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_POISON_TICKTIME_PERCENTAGE,
	}
end

function modifier_item_hd_poison_lokustra_active:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self.poison_res_down
end
function modifier_item_hd_poison_lokustra_active:Advanced_GetModifierPoisonTicktimePercentage()
	return self.poison_interval_up
end
---------------------------------------------------------------------
modifier_item_hd_poison_lokustra_spell = advanced_modifier({})
function modifier_item_hd_poison_lokustra_spell:IsDebuff() return false end
function modifier_item_hd_poison_lokustra_spell:IsHidden() return false end
function modifier_item_hd_poison_lokustra_spell:IsPurgable() return false end
function modifier_item_hd_poison_lokustra_spell:IsPurgeException() 	return false end