creeps_spell_Thorns2 = class({})

LinkLuaModifier("modifier_creeps_spell_Thorns2_passive", "creeps_spell/creeps_spell_Thorns2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_Thorns2_reflection", "creeps_spell/creeps_spell_Thorns2", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function creeps_spell_Thorns2:GetIntrinsicModifierName()return "modifier_creeps_spell_Thorns2_passive" end






-- Unique passive
modifier_creeps_spell_Thorns2_passive = advanced_modifier({})

function modifier_creeps_spell_Thorns2_passive:IsDebuff() return false end
function modifier_creeps_spell_Thorns2_passive:IsHidden() return true end
function modifier_creeps_spell_Thorns2_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Thorns2_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Thorns2_passive:RemoveOnDeath()  return false end





function modifier_creeps_spell_Thorns2_passive:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_creeps_spell_Thorns2_passive:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return 0
	end
	--低难度没用
	if _G.GAME_DIFFICULTY<4 then
		return 0
	end
	local health = self:GetParent():GetMaxHealth()


	--过滤低伤害
	if keys.damage<=health*0.02  then
		return 0
	end

	local block = 0
	if keys.damage>=health*0.2 then
		return 0
	end
	block = (keys.damage - health*0.02)*0.8
	return block

end