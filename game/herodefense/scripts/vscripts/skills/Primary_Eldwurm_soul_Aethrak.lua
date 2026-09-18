
Primary_Eldwurm_soul_Aethrak = class({})


LinkLuaModifier("modifier_Primary_Eldwurm_soul_Aethrak", "skills/Primary_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Eldwurm_soul_Aethrak_effect", "skills/Primary_Eldwurm_soul_Aethrak", LUA_MODIFIER_MOTION_NONE)


function Primary_Eldwurm_soul_Aethrak:GetIntrinsicModifierName() return "modifier_Primary_Eldwurm_soul_Aethrak" end
function Primary_Eldwurm_soul_Aethrak:IsHiddenWhenStolen() 		return false end
function Primary_Eldwurm_soul_Aethrak:IsRefreshable() 			return true  end




modifier_Primary_Eldwurm_soul_Aethrak= class({})

function modifier_Primary_Eldwurm_soul_Aethrak:IsDebuff()			return false end
function modifier_Primary_Eldwurm_soul_Aethrak:IsHidden() 			return true end
function modifier_Primary_Eldwurm_soul_Aethrak:IsPurgable() 		return false end
function modifier_Primary_Eldwurm_soul_Aethrak:IsPurgeException() 	return false end


function modifier_Primary_Eldwurm_soul_Aethrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Primary_Eldwurm_soul_Aethrak_effect", {})


	end
end










modifier_Primary_Eldwurm_soul_Aethrak_effect = class({})

function modifier_Primary_Eldwurm_soul_Aethrak_effect:IsDebuff() return false end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:IsHidden() return false end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:IsPurgable() return false end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:IsPurgeException() return false end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed")
end


function modifier_Primary_Eldwurm_soul_Aethrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		
		

	}
end


function modifier_Primary_Eldwurm_soul_Aethrak_effect:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_Primary_Eldwurm_soul_Aethrak_effect:GetModifierMoveSpeedBonus_Constant()	return self.bonus_move_speed end