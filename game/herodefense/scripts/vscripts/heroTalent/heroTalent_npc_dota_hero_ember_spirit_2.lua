heroTalent_npc_dota_hero_ember_spirit_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_ember_spirit_2", "heroTalent/heroTalent_npc_dota_hero_ember_spirit_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker", "heroTalent/heroTalent_npc_dota_hero_ember_spirit_2", LUA_MODIFIER_MOTION_NONE)



function heroTalent_npc_dota_hero_ember_spirit_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_ember_spirit_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_ember_spirit_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_ember_spirit_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_ember_spirit_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_ember_spirit_2" end

function heroTalent_npc_dota_hero_ember_spirit_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", context )


end





modifier_heroTalent_npc_dota_hero_ember_spirit_2 = class({})

function modifier_heroTalent_npc_dota_hero_ember_spirit_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_ember_spirit_2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	local caster = self:GetParent()
	if caster.ember_spirit_2_attack then
		return
	end

	if self:GetCaster():GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() then
			return
		end
		if caster:PassivesDisabled() then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end

	
		-- ability:UseResources(true,true,true,true)
		ability:StartCooldown(5)

		CreateModifierThinker(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker", {}, keys.target:GetOrigin(), caster:GetTeamNumber(), false)
				
		
	end

	
end



modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker = class({})

function modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker:IsAura()return true end
function modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker:OnCreated(keys)
	if IsServer() then

		self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self.effect, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControlEnt( self.effect, 1,  self:GetCaster(), PATTACH_POINT_FOLLOW, nil,  self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlForward(self.effect, 0,self:GetCaster():GetForwardVector())




		-- self:AddParticle( effect, false, false, -1, true, false )

		self.bonus_count = 3
		self:StartIntervalThink(0.5)
	end
end

function modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect, false)
		ParticleManager:ReleaseParticleIndex(self.effect)
		UTIL_Remove(self:GetParent())
	end
end


function modifier_heroTalent_npc_dota_hero_ember_spirit_2_thinker:OnIntervalThink()
	self:StartIntervalThink(0.1)
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_ANY_ORDER,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #enemies>0 and not enemies[1]:IsNull() then
		
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 0,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		caster.ember_spirit_2_attack = true
		caster:PerformAttack(enemies[1], false, true, true, true, false, false, true)--对一单位执行攻击。
		
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		caster.ember_spirit_2_attack  = nil

		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( effect, 0, enemies[1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[1]:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(effect)

		local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( effect, 0, enemies[1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[1]:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(effect)
		
	end
	if self.bonus_count>0 then
		self.bonus_count = self.bonus_count - 1
		return
	end

	if 20>=RandomInt(1, 100) then
		self:SafeDestroy()
		return
	end

end

