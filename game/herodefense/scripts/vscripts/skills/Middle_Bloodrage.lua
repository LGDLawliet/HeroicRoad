Middle_Bloodrage = class({})

LinkLuaModifier("modifier_Middle_Bloodrage_buff", "skills/Middle_Bloodrage", LUA_MODIFIER_MOTION_NONE)
function Middle_Bloodrage:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*ModifierStatusGain
	target:AddNewModifier(caster, self, "modifier_Middle_Bloodrage_buff", {duration = duration})
	caster:EmitSound("hero_bloodseeker.bloodRage")
end


function Middle_Bloodrage:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
end




modifier_Middle_Bloodrage_buff = advanced_modifier({})

function modifier_Middle_Bloodrage_buff:IsDebuff() return false end
function modifier_Middle_Bloodrage_buff:IsHidden() return false end
function modifier_Middle_Bloodrage_buff:IsPurgable() return false end
function modifier_Middle_Bloodrage_buff:IsPurgeException() return false end
function modifier_Middle_Bloodrage_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end
function modifier_Middle_Bloodrage_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Bloodrage_buff:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_spell_damage = ability:GetSpecialValueFor("bonus_spell_damage")
	
	if IsServer() then
		self.max_health_as_cost_per_second =ability:GetSpecialValueFor("max_health_as_cost_per_second")*0.01
		self.life_steal = 0
		if ability:GetAutoCastState() then
			self.life_steal = 0.03
			self.max_health_as_cost_per_second  = self.max_health_as_cost_per_second  *3
			self:SetStackCount(1)
		end
		-- local parent = self:GetParent()
		-- self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		-- self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		-- self.interval = 0.25
		self:StartIntervalThink(1)
		-- self.block = self:GetAbility():GetSpecialValueFor("bonus_block")*self:GetCaster():GetIntellect(false)

	end
end
function modifier_Middle_Bloodrage_buff:OnRefresh(keys)
	self:OnCreated(keys)
end
-- function modifier_Middle_Bloodrage_buff:OnDestroy()
-- 	if IsServer() then
-- 		ParticleManager:DestroyParticle(self.nFXIndex, false)
-- 		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
-- 	end
-- end


function modifier_Middle_Bloodrage_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,         --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end
function modifier_Middle_Bloodrage_buff:OnIntervalThink()
	local ability = self:GetAbility()
	-- local caster = self:GetCaster()
	local parent = self:GetParent()
	local health = parent:GetHealth() -parent:GetMaxHealth()*self.max_health_as_cost_per_second
	parent:ModifyHealth(health,ability,false,0)

end

function modifier_Middle_Bloodrage_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Middle_Bloodrage_buff:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()==1 and self.bonus_attack_speed * 1.5 or self.bonus_attack_speed end
function modifier_Middle_Bloodrage_buff:Advanced_GetModifierSpellAmplifyBonus(keys) 
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL   then
		return  self:GetStackCount()==1 and self.bonus_spell_damage or self.bonus_spell_damage 
	end
	return 0
end


function modifier_Middle_Bloodrage_buff:OnTakeDamage( params )

	if IsServer() then
		if self.life_steal<=0 then
			return
		end
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 
		end
		if Attacker:GetHealthPercent()>=100 then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 
		end
		if params.damage_type~=DAMAGE_TYPE_PHYSICAL  then
			return
		end

		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * self.life_steal*gain
		if flLifesteal<=0 then
			return
		end
		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		Attacker:Heal( flLifesteal, self:GetAbility() )

	end

	return 

end


