creeps_spell_crab_shell = class({})

LinkLuaModifier("modifier_creeps_spell_crab_shell", "creeps_spell/creeps_spell_crab_shell", LUA_MODIFIER_MOTION_NONE)

require("internal/timers")

function creeps_spell_crab_shell:GetIntrinsicModifierName()
	return "modifier_creeps_spell_crab_shell"
end


modifier_creeps_spell_crab_shell = advanced_modifier({})

function modifier_creeps_spell_crab_shell:IsDebuff() return false end
function modifier_creeps_spell_crab_shell:IsHidden() return true end
function modifier_creeps_spell_crab_shell:IsPurgable() 		return false end
function modifier_creeps_spell_crab_shell:IsPurgeException() 	return false end
function modifier_creeps_spell_crab_shell:RemoveOnDeath()  return false end
function modifier_creeps_spell_crab_shell:OnCreated(table)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if IsServer() then
		Timers:CreateTimer(0.05, function()
			if not self.parent or self.parent:IsNull() then
				return
			end
			
			if self.parent:GetUnitName()=="npc_monster_king_crab" then
				self:GetParent():SetSkin(1)
			else
				self:GetParent():SetSkin(2)
			end
			
		end)
	end
end


-- function modifier_creeps_spell_crab_shell:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
-- 	}
-- end




--物理伤害阻挡
-- function modifier_creeps_spell_crab_shell:GetModifierPhysical_ConstantBlock(keys)  
-- 	if self.parent:PassivesDisabled() then
-- 		return
-- 	end

-- 	local block = self.parent:GetDamageMax()*self.ability:GetSpecialValueFor("block_index")
-- 	block = math.min(block,keys.damage*0.95)

-- 	return block 
-- end



function modifier_creeps_spell_crab_shell:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_creeps_spell_crab_shell:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if self.parent:PassivesDisabled() then
		return 0
	end
	if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then
		return 0
	end

	local block = self.parent:GetDamageMax()*self.ability:GetSpecialValueFor("block_index")
	block = math.min(block,keys.damage*0.95)

	return block 

end