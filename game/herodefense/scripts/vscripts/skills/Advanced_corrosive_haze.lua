--特效优化 √
Advanced_corrosive_haze = class({})
LinkLuaModifier( "modifier_Advanced_corrosive_haze", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_debuff", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_buff", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_unlock1_debuff", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_unlock2", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_unlock3", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_corrosive_haze_unlock3_active", "skills/Advanced_corrosive_haze", LUA_MODIFIER_MOTION_NONE )
function Advanced_corrosive_haze:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/corrosive_haze/corrosive_hazeamp_damage.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance_water_swirls.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/corrosive_haze/unlock2/effect.vpcf", context )

end
function Advanced_corrosive_haze:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_corrosive_haze_unlock2",{})


	-- caster:RemoveAbilityByHandle(self)
	return true
end
function Advanced_corrosive_haze:UnlockSecondCore(key)
	-- self.CoreUnlock = false
	-- self.unlock2 = false
	-- self.bonus_damage_unlock2 = self.bonus_damage_unlock2 +500
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_corrosive_haze_unlock2",{})

	return true
end
function Advanced_corrosive_haze:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_corrosive_haze_unlock3",{})

	return true
end

function Advanced_corrosive_haze:CheckKV(key)
	local table = {
		armor_reduce =0.5,

	}
	local value = table[key] or -1
	return value

end


function Advanced_corrosive_haze:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_Advanced_corrosive_haze_unlock3") then

			if not target:IsRealHero() then
				return UF_FAIL_CUSTOM
			end
			-- if target==self:GetCaster() then
			-- 	return UF_FAIL_CUSTOM
			-- end
			if IsEnemy(target,self:GetCaster()) then
				return UF_FAIL_CUSTOM
			end
			return UF_SUCCESS
		else
			if not IsEnemy(target,self:GetCaster()) then
				return UF_FAIL_CUSTOM
			end
		end
		


		return UF_SUCCESS
	end
	
end
function Advanced_corrosive_haze:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end


function Advanced_corrosive_haze:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster:HasModifier("modifier_Advanced_corrosive_haze_unlock3") then
		caster:RemoveModifierByName("modifier_Advanced_corrosive_haze_unlock3")
		target:AddNewModifier(caster, self, "modifier_Advanced_corrosive_haze_unlock3_active", {} )
		return
	end



	local point = self:GetCursorPosition()

	if target:TriggerSpellAbsorb( self ) then
		return
	end
	local debuff_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_Advanced_corrosive_haze", { duration = debuff_duration } )
	if self.unlock1 then
		target:AddNewModifier(caster, self, "modifier_Advanced_corrosive_haze_unlock1_debuff", { duration = debuff_duration } )
		
	end
	EmitSoundOn( "Hero_Slardar.Amplify_Damage", target )
	if self.advanced_level>=20 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies<=1 then
			target:AddNewModifier(caster, self, "modifier_Advanced_corrosive_haze_debuff", { duration = 2 } )
		end
	end	
end

function Advanced_corrosive_haze:TalentBuff(target,unlock2)
	local duration = 1
	if unlock2 then
		duration = 2
	else
		duration = 5
	end
	target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_corrosive_haze", { duration = duration } )
end

function Advanced_corrosive_haze:GetIntrinsicModifierName()
	return "modifier_Advanced_corrosive_haze_buff"
end

modifier_Advanced_corrosive_haze = advanced_modifier({})

function modifier_Advanced_corrosive_haze:IsHidden()	return false end
function modifier_Advanced_corrosive_haze:IsDebuff()	return true end
function modifier_Advanced_corrosive_haze:IsStunDebuff()	return false end
function modifier_Advanced_corrosive_haze:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze:IsPurgeException() return true end
function modifier_Advanced_corrosive_haze:OnCreated( kv )

	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" ) 
	self.bonus_physical_damage = 15
	self.max = 5
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if level>=5 then
		self.max = 7
		if level>=10 then
			self.bonus_physical_damage = 22
		end
	end
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Advanced_corrosive_haze:OnRefresh( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" ) 
	if IsServer() then

		self:SetStackCount(math.min(self.max,self:GetStackCount()+1))
	end
end


function modifier_Advanced_corrosive_haze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end



function modifier_Advanced_corrosive_haze:GetModifierProvidesFOWVision()
	return 1
end
function modifier_Advanced_corrosive_haze:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_physical_damage
end

--------------------------------------------------------------------------------

function modifier_Advanced_corrosive_haze:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_Advanced_corrosive_haze:PlayEffects()
	local particle_cast = "particles/rebuild/spell/corrosive_haze/corrosive_hazeamp_damage.vpcf"
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx,0,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,1,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,2,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	if self:GetAbility().unlock2 then
		ParticleManager:SetParticleControl(pfx,59,Vector(10,4,0))
	else
		ParticleManager:SetParticleControl(pfx,59,Vector(50,24,0))
	end
	self:AddParticle(pfx,false,false,-1,false,true)
end


function modifier_Advanced_corrosive_haze:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
	return funcs
end



function modifier_Advanced_corrosive_haze:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor_reduction * (1+self:GetStackCount()*0.07)
end



function modifier_Advanced_corrosive_haze:Advanced_GetModifier_StatusResistance(keys)
	return -30
end





modifier_Advanced_corrosive_haze_debuff = class({})

function modifier_Advanced_corrosive_haze_debuff:IsHidden()	return false end
function modifier_Advanced_corrosive_haze_debuff:IsDebuff()	return true end
function modifier_Advanced_corrosive_haze_debuff:IsStunDebuff()	return false end
function modifier_Advanced_corrosive_haze_debuff:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_debuff:IsPurgeException() return true end
function modifier_Advanced_corrosive_haze_debuff:OnCreated( kv )
	self.bonus_damage = -self:GetParent():GetDamageMax() *0.5
end

function modifier_Advanced_corrosive_haze_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end
function modifier_Advanced_corrosive_haze_debuff:GetModifierBaseAttack_BonusDamage() return self.bonus_damage end








modifier_Advanced_corrosive_haze_buff = class({})

function modifier_Advanced_corrosive_haze_buff:IsHidden()	return true end
function modifier_Advanced_corrosive_haze_buff:IsDebuff()	return false end
function modifier_Advanced_corrosive_haze_buff:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_buff:IsPurgeException() return false end
function modifier_Advanced_corrosive_haze_buff:RemoveOnDeath() return false end


function modifier_Advanced_corrosive_haze_buff:DeclareFunctions()
	local fus = {MODIFIER_EVENT_ON_ATTACK_LANDED}

    return fus
end




function modifier_Advanced_corrosive_haze_buff:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if self:GetAbility().advanced_level>=15 then
			local parent = self:GetParent()

			if parent:PassivesDisabled() or  not parent:IsApplyModifier() then
				return
			end
	
			local target = keys.target
			local modifier = target:FindModifierByNameAndCaster("modifier_Advanced_corrosive_haze", parent)
			if modifier then
				modifier:ForceRefresh()
			end
			-- target:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_corrosive_haze", { duration = 1 } )
		end

		
		
	end
end






modifier_Advanced_corrosive_haze_unlock1_debuff = class({})

function modifier_Advanced_corrosive_haze_unlock1_debuff:IsHidden()	return false end
function modifier_Advanced_corrosive_haze_unlock1_debuff:IsDebuff()	return true end
function modifier_Advanced_corrosive_haze_unlock1_debuff:IsStunDebuff()	return false end
function modifier_Advanced_corrosive_haze_unlock1_debuff:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_unlock1_debuff:IsPurgeException() return true end
function modifier_Advanced_corrosive_haze_unlock1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE ,
	}
end
function modifier_Advanced_corrosive_haze_unlock1_debuff:GetModifierIncomingPhysicalDamage_Percentage(keys)
	local armor = self:GetParent():GetPhysicalArmorValue(false)
	if armor<0 then
		return math.min(-armor,100)
	end
	return 0
end
function modifier_Advanced_corrosive_haze_unlock1_debuff:OnCreated()
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Advanced_corrosive_haze_unlock1_debuff:PlayEffects()
	local particle_cast = "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance_water_swirls.vpcf"
	local parent = self:GetParent()
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, parent )
	ParticleManager:SetParticleControlEnt(pfx,0,parent,PATTACH_OVERHEAD_FOLLOW,nil,parent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,1,parent,PATTACH_OVERHEAD_FOLLOW,nil,parent:GetOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx,2,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	self:AddParticle(pfx,false,false,-1,false,true)
end




modifier_Advanced_corrosive_haze_unlock2 = class({})

function modifier_Advanced_corrosive_haze_unlock2:IsHidden()	return true end
function modifier_Advanced_corrosive_haze_unlock2:IsDebuff()	return false end
function modifier_Advanced_corrosive_haze_unlock2:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_unlock2:IsPurgeException() return false end
function modifier_Advanced_corrosive_haze_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_corrosive_haze_unlock2:IsAuraActiveOnDeath() return false end
function modifier_Advanced_corrosive_haze_unlock2:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_corrosive_haze_unlock2:GetModifierAura()	return "modifier_Advanced_corrosive_haze" end
function modifier_Advanced_corrosive_haze_unlock2:GetAuraRadius()	return 500  end
function modifier_Advanced_corrosive_haze_unlock2:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_corrosive_haze_unlock2:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_corrosive_haze_unlock2:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_corrosive_haze_unlock2:OnCreated()
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Advanced_corrosive_haze_unlock2:PlayEffects()
	local particle_cast = "particles/rebuild/spell/corrosive_haze/unlock2/effect.vpcf"
	local parent = self:GetParent()
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, parent )
	-- ParticleManager:SetParticleControlEnt(pfx,0,parent,PATTACH_OVERHEAD_FOLLOW,nil,parent:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,2,parent,PATTACH_POINT_FOLLOW,nil,parent:GetOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx,2,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	self:AddParticle(pfx,false,false,-1,false,true)
end








modifier_Advanced_corrosive_haze_unlock3 = class({})

function modifier_Advanced_corrosive_haze_unlock3:IsHidden()	return true end
function modifier_Advanced_corrosive_haze_unlock3:IsDebuff()	return false end
function modifier_Advanced_corrosive_haze_unlock3:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_unlock3:IsPurgeException() return false end
function modifier_Advanced_corrosive_haze_unlock3:RemoveOnDeath() return false end



modifier_Advanced_corrosive_haze_unlock3_active = class({})

function modifier_Advanced_corrosive_haze_unlock3_active:IsHidden()	return false end
function modifier_Advanced_corrosive_haze_unlock3_active:IsDebuff()	return false end
function modifier_Advanced_corrosive_haze_unlock3_active:IsPurgable()	return false end
function modifier_Advanced_corrosive_haze_unlock3_active:IsPurgeException() return false end
function modifier_Advanced_corrosive_haze_unlock3_active:RemoveOnDeath() return false end
function modifier_Advanced_corrosive_haze_unlock3_active:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_Advanced_corrosive_haze_unlock3_active:OnAttackLanded( keys )
	local parent = self:GetParent()
	if IsServer() and (not parent:PassivesDisabled()) then
		
		if not parent:IsRealHero() then
			return false
		end
		
		if keys.attacker~=parent then
			return false
		end
		if not IsEnemy(parent,keys.target) then
			return
		end
	
		local ability = self:GetAbility()
	
		if not ability then
			self:SafeDestroy()
			return
		end
	
		ability:TalentBuff(keys.target,true)





	end
end

