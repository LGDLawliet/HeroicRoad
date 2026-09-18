heroTalent_npc_dota_hero_pugna = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pugna", "heroTalent/heroTalent_npc_dota_hero_pugna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pugna_triger", "heroTalent/heroTalent_npc_dota_hero_pugna", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_pugna:GetCastRange()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_Advanced_Decrepify_unlock3") then
		return 800 - caster:GetCastRangeBonus()
	end
	return radius - caster:GetCastRangeBonus()

end
function heroTalent_npc_dota_hero_pugna:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_pugna:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_pugna:IsStealable() 				return true end
function heroTalent_npc_dota_hero_pugna:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_pugna:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_pugna" end
-- function heroTalent_npc_dota_hero_pugna:OnSpellStart()

--     self:GetCaster():AddNewModifier(
--         self:GetCaster(),
--         self,
--         "modifier_heroTalent_npc_dota_hero_pugna_triger",
--         {	duration = 0.5})
-- end




modifier_heroTalent_npc_dota_hero_pugna = class({})

function modifier_heroTalent_npc_dota_hero_pugna:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_pugna:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_pugna:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_pugna:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pugna:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_pugna:DeclareFunctions() return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ABILITY_START

} 
end



function modifier_heroTalent_npc_dota_hero_pugna:OnTakeDamage(keys)
	if IsServer() and keys.attacker==self:GetParent() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if keys.damage>=10  then
			if keys.damage_category ==DOTA_DAMAGE_CATEGORY_ATTACK  then
				return
			end
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
				return 0
			end
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then
				return 0
			end
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT  ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT  then
				return 0
			end
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS   ) == DOTA_DAMAGE_FLAG_HPLOSS   then
				return 0
			end

			self:SetStackCount(self:GetStackCount()+keys.damage)

		end
	end
end


function modifier_heroTalent_npc_dota_hero_pugna:OnAbilityStart(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end
	local stack = self:GetStackCount()
	local caster = self:GetCaster()
	local need = self:GetAbility():GetSpecialValueFor("int_need")
	local index = self:GetAbility():GetSpecialValueFor("damage_index")*0.01
	if stack>=caster:GetIntellect(false)*need then
		local damage =  stack*index
		if caster:HasModifier("modifier_Advanced_Decrepify_unlock3") then
			damage = damage * 5
		end
		self:SetStackCount(0)
		self:Trigger(damage)
	end








end












function modifier_heroTalent_npc_dota_hero_pugna:Trigger(dam)
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	if caster:HasModifier("modifier_Advanced_Decrepify_unlock3") then
		radius = 800
	end
	local delay = 0.7
	local pfx_pre_name = "particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast_pre.vpcf"
	local pfx_main_name = "particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast.vpcf"
	local pfx_min = ParticleManager:CreateParticle(pfx_pre_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_min, 0, Vector(pos.x, pos.y, pos.z + 128))
	ParticleManager:SetParticleControl(pfx_min, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx_min)
	Timers:CreateTimer(delay, function()
		local pfx_main = ParticleManager:CreateParticle(pfx_main_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_main, 0, Vector(pos.x, pos.y, pos.z + 128))
		ParticleManager:SetParticleControl(pfx_main, 1, Vector(radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(pfx_main)
		caster:EmitSound("Hero_Pugna.NetherBlast")
		local enemies_balst = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local damageTable = {
			attacker =caster,
			damage = dam,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION , --Optional.
			ability = self:GetAbility(), --Optional.
			hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
			}
		for _, ememy_balst in pairs(enemies_balst) do
		
			damageTable.victim = ememy_balst
			ApplyDamage(damageTable)
			


		end
		return nil
	end
	)
end
