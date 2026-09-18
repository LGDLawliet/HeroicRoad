heroTalent_npc_dota_hero_undying_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_2", "heroTalent/heroTalent_npc_dota_hero_undying_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_2_buff", "heroTalent/heroTalent_npc_dota_hero_undying_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_2_debuff", "heroTalent/heroTalent_npc_dota_hero_undying_2", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_undying_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_undying_2"
end

function heroTalent_npc_dota_hero_undying_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_strength_xfer.vpcf", context )

end

modifier_heroTalent_npc_dota_hero_undying_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_undying_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_undying_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_undying_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_undying_2:OnWaveEnd()
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	for _, unit in ipairs(heroes) do
		if unit~=caster then
			local str = unit:GetStrength()
			local stack = 1
			if str>=150 then
				stack = 2
			end
			if unit:IsAlive() then
				unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_undying_2_debuff", {stack=stack}) 
				local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex(nFXIndex)
				unit:EmitSound("Hero_Undying.Decay.Cast")
			else
				Timers:CreateTimer(1, function()
					if unit:IsAlive() then
						unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_undying_2_debuff", {stack=stack}) 
						local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_strength_xfer.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
						ParticleManager:ReleaseParticleIndex(nFXIndex)
						unit:EmitSound("Hero_Undying.Decay.Cast")

					else
						return 1 
					end
				end)
			end
			if caster:IsAlive() then
				caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_undying_2_buff", {stack=stack}) 
			else
				Timers:CreateTimer(1, function()
					if unit:IsAlive() then
						caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_undying_2_buff", {stack=stack}) 
					else
						return 1 
					end
				end)
			end
		
	
		end
	end
end


function modifier_heroTalent_npc_dota_hero_undying_2:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end




modifier_heroTalent_npc_dota_hero_undying_2_buff = class({})

function modifier_heroTalent_npc_dota_hero_undying_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_undying_2_buff:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_undying_2_buff:OnCreated(keys)
	if IsClient() then
		return
	end
	self:SetStackCount(keys.stack)
end
function modifier_heroTalent_npc_dota_hero_undying_2_buff:OnRefresh(keys)
	if IsClient() then
		return
	end
	self:SetStackCount(self:GetStackCount() + keys.stack)
end



function modifier_heroTalent_npc_dota_hero_undying_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_heroTalent_npc_dota_hero_undying_2_buff:GetModifierBonusStats_Strength() return self:GetStackCount()*1.5 end




modifier_heroTalent_npc_dota_hero_undying_2_debuff = class({})

function modifier_heroTalent_npc_dota_hero_undying_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_undying_2_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_undying_2_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_undying_2_debuff:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_undying_2_debuff:OnCreated(keys)
	if IsClient() then
		return
	end
	self:SetStackCount(keys.stack)
end
function modifier_heroTalent_npc_dota_hero_undying_2_debuff:OnRefresh(keys)
	if IsClient() then
		return
	end
	self:SetStackCount(self:GetStackCount() + keys.stack)
end



function modifier_heroTalent_npc_dota_hero_undying_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_heroTalent_npc_dota_hero_undying_2_debuff:GetModifierBonusStats_Strength() return -self:GetStackCount() end
