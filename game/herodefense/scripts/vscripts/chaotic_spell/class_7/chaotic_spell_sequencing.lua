chaotic_spell_sequencing = class({})


LinkLuaModifier("modifier_chaotic_spell_sequencing", "chaotic_spell/class_7/chaotic_spell_sequencing", LUA_MODIFIER_MOTION_NONE)

function chaotic_spell_sequencing:IsRefreshable() return false end


function chaotic_spell_sequencing:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_death_end.vpcf", context )
end
function chaotic_spell_sequencing:GetIntrinsicModifierName()
	return "modifier_chaotic_spell_sequencing"
end




modifier_chaotic_spell_sequencing = advanced_modifier({})

function modifier_chaotic_spell_sequencing:IsDebuff() return false end
function modifier_chaotic_spell_sequencing:IsHidden() return false end
function modifier_chaotic_spell_sequencing:IsPurgable() 		return false end
function modifier_chaotic_spell_sequencing:IsPurgeException() 	return false end
function modifier_chaotic_spell_sequencing:RemoveOnDeath()  return false end
function modifier_chaotic_spell_sequencing:GetTexture()
	if self.abilityTexture then
		local ability = EntIndexToHScript(self.abilityTexture)
		if ability then
			return ability:GetAbilityTextureName()
		end
		
	end

	return self:GetAbility():GetAbilityTextureName()
end


function modifier_chaotic_spell_sequencing:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability:GetRuneType()==1 then
			self.rune_1_bonus = 1 + ability:GetSpecialValueFor("rune_1_bonus")*0.01
			self.rune_1_reduction = 1-ability:GetSpecialValueFor("rune_1_reduction")*0.01
			self:StartIntervalThink(ability:GetSpecialValueFor("rune_1_interval"))
		end
	
		self.abilityTexture = self:GetAbility():entindex()
		
		self.cooldown_rate = ability:GetSpecialValueFor("cooldown_rate")*0.01
		self.max_cooldown_index = ability:GetSpecialValueFor("max_cooldown_index")
		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_chaotic_spell_sequencing:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
	
		self.cooldown_rate = ability:GetSpecialValueFor("cooldown_rate")*0.01
		self.max_cooldown_index = ability:GetSpecialValueFor("max_cooldown_index")
	end
end

function modifier_chaotic_spell_sequencing:AddCustomTransmitterData( )
	return
	{
		abilityTexture = self.abilityTexture
	}
end

function modifier_chaotic_spell_sequencing:HandleCustomTransmitterData( data )
	self.abilityTexture = data.abilityTexture
end

function modifier_chaotic_spell_sequencing:ADDeclareFunctions()
    return 
    {

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },

    }
end




function modifier_chaotic_spell_sequencing:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<0.5 then
		return
	end
	if keys.ability==self:GetAbility() then
		return
	end
	if not keys.ability:IsRefreshable() then
		return
	end
	local ability = self:GetAbility()
	if ability:GetAutoCastState() then
		if ability:IsCooldownReady() then
			self.abilityTexture = keys.ability:entindex()
			self.ability = keys.ability
			self:SendBuffRefreshToClients()
		end
	end
	local caster = self:GetCaster()
	caster:GameTimer(0.3, function()
		if IsValid(self) then
			if IsValid(self.ability) then
				local targetRemaing = self.ability:GetCooldownTimeRemaining()
				if targetRemaing<=0.5 then
					return
				end
				local cooldown = self.ability:GetCooldown(self.ability:GetLevel())* caster:GetCooldownReduction()
				local cooldownRemaining = ability:GetCooldownTimeRemaining()
				
				if cooldown*self.max_cooldown_index<=cooldownRemaining then
					return
				end
				if self.rune_1_bonus then
					targetRemaing = targetRemaing * self.rune_1_bonus
				end
		
				ability:StartCooldown(cooldownRemaining+targetRemaing*self.cooldown_rate)
				self.ability:EndCooldown()
				self:PlayEffect()
			end
		
		
		end
	end)



	

	
end


function modifier_chaotic_spell_sequencing:PlayEffect()
	local caster = self:GetCaster()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_death_end.vpcf", PATTACH_WORLDORIGIN,nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(84,218,242))
	DestroyParticleByDelay(effect_cast,2.5)
	caster:EmitSound("chaotic_spell_sequencing_target")
end


function modifier_chaotic_spell_sequencing:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		local cooldown = ability:GetCooldownTimeRemaining()*self.rune_1_reduction
		ability:EndCooldown()
		ability:StartCooldown(cooldown)
	end
end