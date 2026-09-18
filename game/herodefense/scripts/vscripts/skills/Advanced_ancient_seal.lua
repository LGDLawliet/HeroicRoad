
--特效优化 √
LinkLuaModifier("modifier_Advanced_ancient_seal", "skills/Advanced_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_ancient_seal_debuff", "skills/Advanced_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_ancient_seal_debuff_mark", "skills/Advanced_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_ancient_seal_unlock1", "skills/Advanced_ancient_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_ancient_seal_unlock2", "skills/Advanced_ancient_seal", LUA_MODIFIER_MOTION_NONE)

Advanced_ancient_seal		= Advanced_ancient_seal or class({})
function Advanced_ancient_seal:CheckKV(key)
	local table = {
		res_reduce = 0.4,
	}
	local value = table[key] or -1
	return value

end
function Advanced_ancient_seal:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_ancient_seal_unlock1",{})
	return true
end
function Advanced_ancient_seal:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_ancient_seal_unlock2",{})
	return true
end
function Advanced_ancient_seal:UnlockThirdCore(key)

	return true
end

function Advanced_ancient_seal:GetIntrinsicModifierName()
	return "modifier_Advanced_ancient_seal"
end
function Advanced_ancient_seal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf", context )
end

modifier_Advanced_ancient_seal	= modifier_Advanced_ancient_seal or class({})

function modifier_Advanced_ancient_seal:DestroyOnExpire()	return false end
function modifier_Advanced_ancient_seal:IsPurgable()		return false end
function modifier_Advanced_ancient_seal:RemoveOnDeath()	return false end
function modifier_Advanced_ancient_seal:IsPurgeException() return false end
function modifier_Advanced_ancient_seal:IsHidden()			return true end
function modifier_Advanced_ancient_seal:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE
		
	}
end




function modifier_Advanced_ancient_seal:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if not keys.inflictor then return end
		if attacker~=self:GetParent() then	return end
		if keys.damage<=30 then return	end
		if keys.damage_type~=DAMAGE_TYPE_MAGICAL  then
			return
		end
		if attacker:PassivesDisabled() then
			return
		end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


		local ability = self:GetAbility()
		if ability.advanced_level>=15 then
			unit:AddNewModifier(attacker,ability, "modifier_Advanced_ancient_seal_debuff", {duration = ability:GetSpecialValueFor('duration')})
			return
		end
		if unit:HasModifier("modifier_Advanced_ancient_seal_debuff") then
			return
		end
		unit:AddNewModifier(attacker,ability, "modifier_Advanced_ancient_seal_debuff", {duration = ability:GetSpecialValueFor('duration')})
 
    end 
end


modifier_Advanced_ancient_seal_debuff = modifier_Advanced_ancient_seal_debuff or class({})

function modifier_Advanced_ancient_seal_debuff:IsDebuff() return true end
function modifier_Advanced_ancient_seal_debuff:IsHidden() return false end
function modifier_Advanced_ancient_seal_debuff:IsPurgable() return false end
function modifier_Advanced_ancient_seal_debuff:IsPurgeException() return false end
function modifier_Advanced_ancient_seal_debuff:OnCreated(keys)
	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.magical_res_reduce = -ability:GetSpecialValueFor("res_reduce")
	if caster:HasModifier("modifier_Advanced_ancient_seal_unlock2") then
		self.magical_res_reduce = self.magical_res_reduce -45
	end
	if IsServer() then
		self:PlayEffects()
		local parnet = self:GetParent()
		-- local caster = self:GetCaster()
		parnet:AddNewModifier(caster,ability, "modifier_Advanced_ancient_seal_debuff_mark", {})

		local index = 0.2
		local bonus =math.floor( caster:GetSpellAmplification(false)/index)
		local max = 20
		if ability.advanced_level>=10 then
			max = 35
		end
		bonus = math.min(bonus,max)
		if bonus>0 then
			self:SetStackCount(bonus)
		end
 
	end
end
function modifier_Advanced_ancient_seal_debuff:OnRefresh(keys)
	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.magical_res_reduce = -ability:GetSpecialValueFor("res_reduce")
	if caster:HasModifier("modifier_Advanced_ancient_seal_unlock2") then
		self.magical_res_reduce = self.magical_res_reduce -45
	end
	if IsServer() then
		local parnet = self:GetParent()
	
		parnet:AddNewModifier(caster,ability, "modifier_Advanced_ancient_seal_debuff_mark", {})
 
		local index = 0.2
		local bonus =math.floor( caster:GetSpellAmplification(false)/index)
		local max = 20
		if ability.advanced_level>=10 then
			max = 35
		end
		bonus = math.min(bonus,max)
		if bonus>0 then
			self:SetStackCount(bonus)
		end
	end
end
function modifier_Advanced_ancient_seal_debuff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		local parnet = self:GetParent()
		local caster = self:GetCaster()
		parnet:AddNewModifier(caster,ability, "modifier_Advanced_ancient_seal_debuff_mark", {})
 
	end
end


function modifier_Advanced_ancient_seal_debuff:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end

function modifier_Advanced_ancient_seal_debuff:GetModifierMagicalResistanceBonus()return self.magical_res_reduce-self:GetStackCount() end


function modifier_Advanced_ancient_seal_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf"
	local sound_cast = "Hero_SkywrathMage.AncientSeal.Target"

	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, parent )
end








modifier_Advanced_ancient_seal_debuff_mark	= modifier_Advanced_ancient_seal_debuff_mark or class({})
function modifier_Advanced_ancient_seal_debuff_mark:IsDebuff() return true end
function modifier_Advanced_ancient_seal_debuff_mark:DestroyOnExpire()	return false end
function modifier_Advanced_ancient_seal_debuff_mark:IsPurgable()		return false end
-- function modifier_Advanced_ancient_seal_debuff_mark:RemoveOnDeath()	return false end
function modifier_Advanced_ancient_seal_debuff_mark:IsPurgeException() return false end
function modifier_Advanced_ancient_seal_debuff_mark:IsHidden()			return false end
function modifier_Advanced_ancient_seal_debuff_mark:OnCreated(keys)
	
	-- local ability = self:GetAbility()
	self.bonus_per_stack = 1
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock3 then
			self.unlock3 = true
			self.unlock3_caster = self:GetCaster()
			self.lv20 = true
			self:SetStackCount(50)
			return
		end
		self.max = 20
		if ability.advanced_level>=5 then
			self.max = 30
			if ability.advanced_level>=20 then
				self.lv20 = true
			end
		end
		
		self:SetStackCount(1)
	end
end
function modifier_Advanced_ancient_seal_debuff_mark:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		if self.unlock3 then
			return
		end
		if ability.unlock3 then
			self.unlock3 = true
			self.unlock3_caster = self:GetCaster()
			self.lv20 = true
			self:SetStackCount(50)
			return
		end
		if self:GetAbility().advanced_level>=5 then
			self.max = 30
			if self:GetAbility().advanced_level>=20 then
				self.lv20 = true
			end
		end
		self:SetStackCount(math.min(1+self:GetStackCount(),self.max))
	end
end
function modifier_Advanced_ancient_seal_debuff_mark:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
		
	}
end


function modifier_Advanced_ancient_seal_debuff_mark:GetModifierIncomingSpellDamageConstant(keys)
	if IsServer() then
		if not keys.damage_type==DAMAGE_TYPE_MAGICAL  then
			return
		end
		if keys.attacker:HasModifier("modifier_Advanced_ancient_seal") then
			local stack = self:GetStackCount()
			local bonus = keys.damage * stack*0.01*self.bonus_per_stack
			if self.lv20 then
				bonus = bonus + stack* keys.attacker:GetMaxMana()*0.001
			end
			if self.unlock3 and self.unlock3_caster and not self.unlock3_caster:IsNull() then
				bonus = bonus + self.unlock3_caster:GetIntellect(false)*7
			end
			return bonus
		end
	end

end
function modifier_Advanced_ancient_seal_debuff_mark:OnTooltip()
	return self:GetStackCount()*self.bonus_per_stack
end









modifier_Advanced_ancient_seal_unlock1 = class({})

function modifier_Advanced_ancient_seal_unlock1:IsDebuff()			return false end
function modifier_Advanced_ancient_seal_unlock1:IsHidden() 			return true end
function modifier_Advanced_ancient_seal_unlock1:IsPurgable() 		return false end
function modifier_Advanced_ancient_seal_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_ancient_seal_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_ancient_seal_unlock1:DestroyOnExpire() return false end






modifier_Advanced_ancient_seal_unlock2 = class({})

function modifier_Advanced_ancient_seal_unlock2:IsDebuff()			return false end
function modifier_Advanced_ancient_seal_unlock2:IsHidden() 			return true end
function modifier_Advanced_ancient_seal_unlock2:IsPurgable() 		return false end
function modifier_Advanced_ancient_seal_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_ancient_seal_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_ancient_seal_unlock2:DestroyOnExpire() return false end
function modifier_Advanced_ancient_seal_unlock2:DeclareFunctions()
	return {
 
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
end

function modifier_Advanced_ancient_seal_unlock2:GetModifierMagicalResistanceBonus()return -100 end
