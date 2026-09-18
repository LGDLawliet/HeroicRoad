heroTalent_npc_dota_hero_morphling_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_morphling_3", "heroTalent/heroTalent_npc_dota_hero_morphling_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_morphling_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_morphling_3"
end




modifier_heroTalent_npc_dota_hero_morphling_3 = class({})

function modifier_heroTalent_npc_dota_hero_morphling_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_morphling_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_morphling_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_morphling_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_morphling_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_morphling_3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_heroTalent_npc_dota_hero_morphling_3:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		return
	end
	local attribute = (caster:GetStrength() + caster:GetIntellect(false))*0.75
	self:SetStackCount(math.min(2000,attribute))
	
end

function modifier_heroTalent_npc_dota_hero_morphling_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end




function modifier_heroTalent_npc_dota_hero_morphling_3:GetModifierBaseAttack_BonusDamage() 
	return self:GetStackCount()
end