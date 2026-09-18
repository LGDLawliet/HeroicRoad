Primary_infernal_blade = Primary_infernal_blade or class({})

LinkLuaModifier("modifier_Primary_infernal_blade_debuff", "skills/Primary_infernal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_infernal_blade_orb", "skills/Primary_infernal_blade", LUA_MODIFIER_MOTION_NONE)
function Primary_infernal_blade:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )

end
function Primary_infernal_blade:GetIntrinsicModifierName()
	return "modifier_Primary_infernal_blade_orb"
end

function Primary_infernal_blade:OnSpellStart()
	self:OnOrbImpact( self:GetCaster():GetCursorCastTarget() )
end

function Primary_infernal_blade:OnOrbImpact( target )
	-- get reference
	local duration = self:GetSpecialValueFor( "burn_duration" )
	local bash = self:GetSpecialValueFor( "stun_duration" )

	local caster = self:GetCaster()

	local NegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance =target:GetHDStatusResistanceIndex()
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_infernal_blade_debuff", -- modifier name
		{ duration = duration*NegativeGain } -- kv
	)

	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = bash*StatusResistance*NegativeGain } -- kv
	)
end





modifier_Primary_infernal_blade_orb = modifier_Primary_infernal_blade_orb or class({})

function modifier_Primary_infernal_blade_orb:IsDebuff()			return false end
function modifier_Primary_infernal_blade_orb:IsHidden() 			return true end
function modifier_Primary_infernal_blade_orb:IsPurgable() 		return false end
function modifier_Primary_infernal_blade_orb:IsPurgeException() 	return false end
function modifier_Primary_infernal_blade_orb:OnCreated()
	if IsServer() then
		self.attack_record = {}
		-- self.record_ok = false
	end
end

-- function modifier_Primary_infernal_blade_orb:OnDestroy()
-- 	if IsServer() and self.pfx then
-- 		self.pfx = nil
-- 	end
-- end
function modifier_Primary_infernal_blade_orb:DeclareFunctions()
	 return 
	 {
		MODIFIER_EVENT_ON_ATTACK,
	 	MODIFIER_EVENT_ON_ATTACK_LANDED,
	} 
	end
function modifier_Primary_infernal_blade_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion()
	 or not ability:IsFullyCastable() or not ability:GetAutoCastState() then
		return
	end
	if not IsEnemy(keys.target,parent) then
		return
	end
	if not parent:IsApplyModifier() then
		return
	end
	self.attack_record[keys.record] = true
end
function modifier_Primary_infernal_blade_orb:OnAttackLanded(keys)
	if IsClient() then
		return
	end
	if self.attack_record[keys.record] then
		self.attack_record[keys.record] = nil
		local ability = self:GetAbility()
		if not ability:IsFullyCastable() then
			return
		end
		if keys.fail_type==DOTA_ATTACK_RECORD_FAIL_NO  then
			ability:UseResources(true, true, true, true)
			ability:OnOrbImpact(keys.target)
		end
	end
end







modifier_Primary_infernal_blade_debuff = modifier_Primary_infernal_blade_debuff or class({})
function modifier_Primary_infernal_blade_debuff:IsHidden()	return false end
function modifier_Primary_infernal_blade_debuff:IsDebuff()	return true end
function modifier_Primary_infernal_blade_debuff:IsStunDebuff()	return false end
function modifier_Primary_infernal_blade_debuff:IsPurgable()	return true end
function modifier_Primary_infernal_blade_debuff:OnCreated( keys )
	if not IsServer() then return end

	local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor( "damage" )
	self.damage_pct = ability:GetSpecialValueFor( "bonus_damage" )*0.01
	self.bonus_damage_max = ability:GetSpecialValueFor("bonus_damage_max")
	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type =ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}

	self:StartIntervalThink( interval )
	self:PlayEffects()
end

function modifier_Primary_infernal_blade_debuff:OnRefresh( keys )
	if not IsServer() then return end
	self:OnCreated( keys )
end



function modifier_Primary_infernal_blade_debuff:OnIntervalThink()
	-- print("aaaaa")
	local damage =  self:GetParent():GetMaxHealth()*self.damage_pct
	-- print("damage1="..damage)
	damage = math.min(damage,self:GetCaster():GetAverageTrueAttackDamage(nil)*self.bonus_damage_max)
	damage = math.max(damage,0)
	self.damageTable.damage = self.damage + damage
	ApplyDamage( self.damageTable )
end

function modifier_Primary_infernal_blade_debuff:GetEffectName()	return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf" end
function modifier_Primary_infernal_blade_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_infernal_blade_debuff:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf"
	local sound_cast = "Hero_DoomBringer.InfernalBlade.Target"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end