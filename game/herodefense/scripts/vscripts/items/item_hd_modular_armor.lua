item_hd_modular_armor = class({})
-- LinkLuaModifier("modifier_item_hd_modular_armor_arua", "items/item_hd_modular_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_armor_arua_effect", "items/item_hd_modular_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_modular_armor", "items/item_hd_modular_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_armor_buff", "items/item_hd_modular_armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_armor_debuff", "items/item_hd_modular_armor", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_modular_armor:GetIntrinsicModifierName()
	return "modifier_item_hd_modular_armor"
end





function item_hd_modular_armor:Precache( context )
	PrecacheResource( "particle", "models/items/razor/razor_arcana/debut/particles/razor_arcana_debut_strike_top_sword.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )
end



modifier_item_hd_modular_armor = modifier_item_hd_modular_armor or advanced_modifier({})

function modifier_item_hd_modular_armor:IsDebuff() return false end
function modifier_item_hd_modular_armor:IsHidden() return false end
function modifier_item_hd_modular_armor:IsPurgable() return false end
function modifier_item_hd_modular_armor:OnCreated(keys)
    local parent = self:GetParent()

	local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor =ability:GetSpecialValueFor( "bonus_armor" ) 
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_item_hd_modular_armor:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_HEALTH_BONUS,

		MODIFIER_EVENT_ON_ATTACK_LANDED

	}
end


function modifier_item_hd_modular_armor:GetModifierHealthBonus() return self.bonus_health*(1+self:GetStackCount()*0.25) end

function modifier_item_hd_modular_armor:OnIntervalThink()
	local parent = self:GetParent()
	local stackCount = 0
	for i=0, 8 do
		local Ability = parent:GetItemInSlot(i)
		if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  then
			if Ability:GetItemType()=="armor" then
				stackCount = stackCount + 1
			end
		end
	end
	self:SetStackCount(stackCount)
end




function modifier_item_hd_modular_armor:OnAttackLanded(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

			if self:GetStackCount()>=3 then
				local caster = self:GetParent()
				if caster:RollRandom(20,1) then
					local damage = caster:GetMaxHealth()*0.1
					local particle = ParticleManager:CreateParticle("models/items/razor/razor_arcana/debut/particles/razor_arcana_debut_strike_top_sword.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(particle, 0, keys.attacker:GetOrigin())
					ParticleManager:SetParticleControl(particle, 1, caster:GetOrigin()+Vector(0,0,600))
					DestroyParticleByDelay(particle,2)
			
					EmitSoundOnLocationWithCaster(keys.attacker:GetOrigin(), "Ability.PlasmaFieldImpact", caster)

					local damageTable = {
						victim = keys.attacker,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
						ability = self:GetAbility(), --Optional.
					}
					ApplyDamage(damageTable)


					
				end
			end
	
		end
	end
end

function modifier_item_hd_modular_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_modular_armor:Advanced_GetModifierPhysicalArmorBonus()
    return  self.bonus_armor*(1+self:GetStackCount()*0.25)
end