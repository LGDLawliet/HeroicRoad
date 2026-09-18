heroTalent_npc_dota_hero_rattletrap = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_rattletrap", "heroTalent/heroTalent_npc_dota_hero_rattletrap", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_rattletrap:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_rattletrap:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_rattletrap:IsStealable() 				return true end
function heroTalent_npc_dota_hero_rattletrap:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_rattletrap:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_rattletrap" end
-- function heroTalent_npc_dota_hero_rattletrap:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_rattletrap")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end


modifier_heroTalent_npc_dota_hero_rattletrap = class({})

function modifier_heroTalent_npc_dota_hero_rattletrap:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_rattletrap:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_rattletrap:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_rattletrap:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_rattletrap:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_rattletrap:OnCreated(keys)
	if IsServer() then

		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.3)
	end
end


function modifier_heroTalent_npc_dota_hero_rattletrap:OnIntervalThink()

	if not self:GetParent():IsAlive() or not self:GetAbility():IsCooldownReady() or not self:GetAbility():GetAutoCastState() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			return
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_rattletrap/clock_overclock_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			local pos = self:GetCaster():GetAbsOrigin()
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end




function modifier_heroTalent_npc_dota_hero_rattletrap:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,            --技能魔法消耗

    }
 end
function modifier_heroTalent_npc_dota_hero_rattletrap:GetModifierPercentageCooldown(keys)
	if IsServer() then
		local ability = keys.ability
		if not ability or ability:IsNull() then
			return
		end
		if ability:IsRefreshable() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() then
			if ability:GetCooldown(ability:GetLevel()) <= 2 then
				return 0
			end
			self:GetAbility():StartCooldown(10)
			return 40
		end 
	end
	
	return 0
end



function modifier_heroTalent_npc_dota_hero_rattletrap:GetModifierPercentageManacostStacking(keys)
	if IsServer() then
		local ability = keys.ability
		if not ability or ability:IsNull() then
			return 0
		end
		if ability:IsRefreshable() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() then
			return -200
		end 
	end
	
	return 0
end