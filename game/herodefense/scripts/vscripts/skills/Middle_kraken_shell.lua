Middle_kraken_shell = class({})
-- LinkLuaModifier("modifier_Middle_kraken_shell_arua", "items/Middle_kraken_shell", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_kraken_shell_arua_effect", "items/Middle_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_kraken_shell", "skills/Middle_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_kraken_shell_active", "skills/Middle_kraken_shell", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function Middle_kraken_shell:GetIntrinsicModifierName()
	return "modifier_Middle_kraken_shell"
end




modifier_Middle_kraken_shell = advanced_modifier({})

function modifier_Middle_kraken_shell:IsDebuff() return false end
function modifier_Middle_kraken_shell:IsHidden() return false end
function modifier_Middle_kraken_shell:IsPurgable() 		return false end
function modifier_Middle_kraken_shell:IsPurgeException() 	return false end
function modifier_Middle_kraken_shell:RemoveOnDeath()  return false end
function modifier_Middle_kraken_shell:OnCreated(table)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end


function modifier_Middle_kraken_shell:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
end


function modifier_Middle_kraken_shell:OnTakeDamage(keys)
	if IsServer() then

		if keys.unit==self.parent then

			self:SetStackCount(self:GetStackCount()+keys.damage)
			if self:GetStackCount()>=self.parent:GetMaxHealth()*self.ability:GetSpecialValueFor("purge_damage")*0.01 then
				self.parent:Purge(false, true, false, false, true) --强驱散
				local ModifierStatusGain = self.parent:GetModifierDurationGainIndex(1)
				self.parent:AddNewModifier(self.parent, self.ability, "modifier_Middle_kraken_shell_active", {duration = 4*ModifierStatusGain})

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_POINT_FOLLOW, self.parent)
				ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				self.parent:EmitSound("Hero_Tidehunter.KrakenShell")
				self:SetStackCount(0)
			end
		end
		
	end
end


--物理伤害阻挡
-- function modifier_Middle_kraken_shell:GetModifierPhysical_ConstantBlock(keys)  
-- 	if self.parent:PassivesDisabled() then
-- 		if not self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") then
-- 			return
-- 		end
-- 	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

-- 	local block = self.parent:GetStrength()*self.ability:GetSpecialValueFor("bonus_block")+self.ability:GetSpecialValueFor("damage_block")
-- 	if self.parent:HasModifier("modifier_Middle_kraken_shell_active") then
-- 		block = block *2
-- 	end
-- 	if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") and self.parent:HasModifier("modifier_generic_water_zoom_buff") then
-- 		block = math.min(block*1.7,keys.damage)
-- 	else
-- 		block = math.min(block,keys.damage*0.95)
-- 	end
-- 	return block 
-- end



function modifier_Middle_kraken_shell:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Middle_kraken_shell:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end
	if self.parent:PassivesDisabled() then
		if not self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") then
			return
		end
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

	local block = self.parent:GetStrength()*self.ability:GetSpecialValueFor("bonus_block")+self.ability:GetSpecialValueFor("damage_block")
	if self.parent:HasModifier("modifier_Middle_kraken_shell_active") then
		block = block *2
	end
	if self.parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") and self.parent:HasModifier("modifier_generic_water_zoom_buff") then
		block = math.min(block*1.7,keys.damage)
	else
		block = math.min(block,keys.damage*0.95)
	end
	return block 
end









modifier_Middle_kraken_shell_active = class({})

function modifier_Middle_kraken_shell_active:IsDebuff() return false end
function modifier_Middle_kraken_shell_active:IsHidden() return false end
function modifier_Middle_kraken_shell_active:IsPurgable() return false end
