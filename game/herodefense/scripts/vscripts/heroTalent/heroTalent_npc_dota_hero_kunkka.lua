heroTalent_npc_dota_hero_kunkka = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka", "heroTalent/heroTalent_npc_dota_hero_kunkka", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_kunkka:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_kunkka"
end



modifier_heroTalent_npc_dota_hero_kunkka = class({})

function modifier_heroTalent_npc_dota_hero_kunkka:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_kunkka:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_kunkka:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_kunkka:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_kunkka:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/kunkka_talent/kunkka_talent_ghost_ship_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		local pos = self:GetCaster():GetAbsOrigin()
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", pos, true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.3)
	end
end


function modifier_heroTalent_npc_dota_hero_kunkka:OnIntervalThink()

	if self:GetParent():PassivesDisabled() or not self:GetParent():IsAlive() or not self:GetAbility():IsCooldownReady() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
			return
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/kunkka_talent/kunkka_talent_ghost_ship_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			local pos = self:GetCaster():GetAbsOrigin()
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", pos, true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end
end

function modifier_heroTalent_npc_dota_hero_kunkka:DeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_heroTalent_npc_dota_hero_kunkka:OnAttackLanded(keys)
	
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and  not self:GetParent():PassivesDisabled() then	

		local caster = self:GetCaster()
		local ability = self:GetAbility()
		ability:UseResources(true, true, true, true)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
		

		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, keys.target:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 3, keys.target:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		caster:EmitSound("Ability.Ghostship.crash")
		self.str_index = ability:GetSpecialValueFor("str_index")
		local units = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			damage = caster:GetStrength()*self.str_index,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
		}
		caster:EmitSound("Hero_ShadowDemon.Soul_Catcher")
		--local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		self.stun_duration = ability:GetSpecialValueFor("stun_duration")
	
		for _, enemy in ipairs(units) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			--local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = self.stun_duration})
				
			
		end
		
	end
end
