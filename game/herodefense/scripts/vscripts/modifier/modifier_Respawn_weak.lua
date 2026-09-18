

modifier_Respawn_weak = class({})


function modifier_Respawn_weak:IsHidden()return false end
function modifier_Respawn_weak:IsDebuff()return true end
function modifier_Respawn_weak:IsStunDebuff()return false end
function modifier_Respawn_weak:IsPurgable()return false end
function modifier_Respawn_weak:GetTexture() return "ogre_magi/antipodeanabilityicons/ogre_magi_bloodlust" end
function modifier_Respawn_weak:IsPurgeException() 	return false end
function modifier_Respawn_weak:RemoveOnDeath() return false end
function modifier_Respawn_weak:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Respawn_weak:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Respawn_weak:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Respawn_weak:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Respawn_weak:GetModifierBonusStats_Agility()	return self.bonus_agi end


function modifier_Respawn_weak:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.bonus_str =-parent:GetStrength()*0.3
		self.bonus_agi =-parent:GetAgility()*0.3
		self.bonus_int =-parent:GetIntellect(false)*0.3
	end
end

