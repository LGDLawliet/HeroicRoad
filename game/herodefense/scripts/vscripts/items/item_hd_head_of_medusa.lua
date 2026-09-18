item_hd_head_of_medusa =  item_hd_head_of_medusa or class({})

LinkLuaModifier("modifier_item_hd_head_of_medusa", "items/item_hd_head_of_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_head_of_medusa_active", "items/item_hd_head_of_medusa", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function item_hd_head_of_medusa:GetIntrinsicModifierName()
	return "modifier_item_hd_head_of_medusa"
end


function item_hd_head_of_medusa:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/head_of_medusa/cast_effect_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context )



	

end

function item_hd_head_of_medusa:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Medusa.StoneGaze.Stun")
	local caster_pos = caster:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/rebuild/items/head_of_medusa/cast_effect_debuff.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster_pos)
	ParticleManager:SetParticleControl(particle, 1, caster_pos)
	DestroyParticleByDelay(particle,2)
	

	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster_pos,
		nil,
		800,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	for _, unit in pairs(units) do
		local StatusResistance = unit:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
		local duration = math.min(10,5*StatusResistance)
		duration = math.max(3.5,duration)
		unit:AddNewModifier(caster, self, "modifier_item_hd_head_of_medusa_active", {duration = duration})
		-- unit:EmitSound("Hero_Medusa.StoneGaze.Stun")
	end

end





modifier_item_hd_head_of_medusa = class({})

function modifier_item_hd_head_of_medusa:IsDebuff() return false end
function modifier_item_hd_head_of_medusa:IsHidden() return true end
function modifier_item_hd_head_of_medusa:IsPurgable() return false end



function modifier_item_hd_head_of_medusa:OnCreated(keys)

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")

	if IsServer() then
		local parent = self:GetParent()
		if  parent:GetUnitName()~="npc_dota_hero_medusa" then
		
			local units = GetAllRealHeroes()
			for  _, hero in pairs(units) do
				if hero~=parent then
					
					if hero:GetUnitName()=="npc_dota_hero_medusa" then

						Say(hero, "?", true)
						break
					end
				end
			end
		end
	end
end


function modifier_item_hd_head_of_medusa:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,  
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}
end


function modifier_item_hd_head_of_medusa:GetModifierPreAttack_BonusDamage()	return self.bonus_damage end
function modifier_item_hd_head_of_medusa:GetModifierBonusStats_Agility()	return self.bonus_agi end
-- function modifier_item_hd_head_of_medusa:GetModifierPercentageManacost()	return -35 end
-- function modifier_item_hd_head_of_medusa:GetModifierPercentageManacostStacking()	return -35 end

modifier_item_hd_head_of_medusa_active = class({})

function modifier_item_hd_head_of_medusa_active:IsDebuff() return true end
function modifier_item_hd_head_of_medusa_active:IsHidden() return false end
function modifier_item_hd_head_of_medusa_active:IsPurgable() return false end
function modifier_item_hd_head_of_medusa_active:GetTexture()return "item_head_of_medusa" end
function modifier_item_hd_head_of_medusa_active:GetStatusEffectName() return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf" end
-- function modifier_item_hd_head_of_medusa_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_head_of_medusa_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	}
end


function modifier_item_hd_head_of_medusa_active:GetModifierIncomingPhysicalDamage_Percentage()	return 60 end

function modifier_item_hd_head_of_medusa_active:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	

	return state
end
