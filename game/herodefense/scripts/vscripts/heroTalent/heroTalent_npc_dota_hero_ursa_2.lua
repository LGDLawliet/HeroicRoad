heroTalent_npc_dota_hero_ursa_2 = heroTalent_npc_dota_hero_ursa_2 or  class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ursa_2", "heroTalent/heroTalent_npc_dota_hero_ursa_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ursa_2_buff", "heroTalent/heroTalent_npc_dota_hero_ursa_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_ursa_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ursa_2"
end

function heroTalent_npc_dota_hero_ursa_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/ursa_2/effect_cross.vpcf" , context )

end

modifier_heroTalent_npc_dota_hero_ursa_2 =modifier_heroTalent_npc_dota_hero_ursa_2 or class({})

function modifier_heroTalent_npc_dota_hero_ursa_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_ursa_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ursa_2:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_ursa_2:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_ursa_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_ursa_2:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:GetParent():IsInSpecialAttack() then
			return
		end
		if not self:GetAbility():IsCooldownReady() then
			local cooldown = self:GetAbility():GetCooldownTimeRemaining()
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(cooldown*0.92)
		end
	end
end

function modifier_heroTalent_npc_dota_hero_ursa_2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_heroTalent_npc_dota_hero_ursa_2:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		local caster = self:GetCaster()
		if caster:IsAlive() then
			caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_ursa_2_buff", {})
		end
		
	end
end



modifier_heroTalent_npc_dota_hero_ursa_2_buff =modifier_heroTalent_npc_dota_hero_ursa_2_buff or  class({})

function modifier_heroTalent_npc_dota_hero_ursa_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ursa_2_buff:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(10)
	end
end
function modifier_heroTalent_npc_dota_hero_ursa_2_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():UseResources(true, true, true,true)
	end
end

function modifier_heroTalent_npc_dota_hero_ursa_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_heroTalent_npc_dota_hero_ursa_2_buff:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
			return 0
		end


		local bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)
		self:PlayeEffect()
		self:DecrementStackCount()

		return bonus_damage
	end
end


function modifier_heroTalent_npc_dota_hero_ursa_2_buff:PlayeEffect()
	
	local caster = self:GetCaster()
	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/ursa_2/effect_cross.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(0,65,90) )
	-- ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	DestroyParticleByDelay(nFXIndex,1)
	-- self:AddParticle( nFXIndex, false, false, -1, true, false )
end