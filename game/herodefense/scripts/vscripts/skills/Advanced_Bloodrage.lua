Advanced_Bloodrage = class({})

LinkLuaModifier("modifier_Advanced_Bloodrage_buff", "skills/Advanced_Bloodrage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bloodrage_buff_lv20", "skills/Advanced_Bloodrage", LUA_MODIFIER_MOTION_NONE)
function Advanced_Bloodrage:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*ModifierStatusGain
	local bonus_index = 0
	local modifier = caster:FindModifierByName("modifier_Advanced_Bloodrage_buff_lv20")
	if modifier then
		bonus_index = modifier:GetStackCount()
		if self.unlock2 then
			if bonus_index>200 then
				modifier:SetStackCount(bonus_index-(bonus_index-200)*0.08)
			end
		else
			if bonus_index>100 then
				modifier:SetStackCount(bonus_index-(bonus_index-100)*0.2)
			end
		end

	end
	target:AddNewModifier(caster, self, "modifier_Advanced_Bloodrage_buff", {duration = duration,bonus_index=bonus_index})
	caster:EmitSound("hero_bloodseeker.bloodRage")
end
function Advanced_Bloodrage:CheckKV(key)
	local table = {
		duration=0.1,
		bonus_attack_speed=3,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Bloodrage:CheckKVFixedOverride(key)
	if key=="bonus_spell_damage" then
		if self:GetUnlock(3)==3 then
			return 150
		end
	end

	return -999999

end



function Advanced_Bloodrage:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
function Advanced_Bloodrage:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Bloodrage:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
function Advanced_Bloodrage:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
	PrecacheResource( "particle", "particles/new_effect/new_effect/new_hd_soul_move.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/bloodrage/lv20/effect.vpcf", context )
end


function Advanced_Bloodrage:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Bloodrage_buff_lv20",{stack = keys.stack})
end


modifier_Advanced_Bloodrage_buff = advanced_modifier({})

function modifier_Advanced_Bloodrage_buff:IsDebuff() return false end
function modifier_Advanced_Bloodrage_buff:IsHidden() return false end
function modifier_Advanced_Bloodrage_buff:IsPurgable() return false end
function modifier_Advanced_Bloodrage_buff:IsPurgeException() return false end
function modifier_Advanced_Bloodrage_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end
function modifier_Advanced_Bloodrage_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Bloodrage_buff:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_spell_damage = ability:GetSpecialValueFor("bonus_spell_damage")
	self.max_health_as_cost_per_second =ability:GetSpecialValueFor("max_health_as_cost_per_second")*0.01
	self.bonus_attack_damage =0
	if ability:GetSpecialValueFor("advanced_level")>=15 then
		
		self.bonus_attack_damage = self:GetParent():GetMaxHealth()*self.max_health_as_cost_per_second
	end

	self.max = 300
	if ability:GetUnlock(1)==1 then
		self.max_health_as_cost_per_second = 0.15
		self.bonus_attack_damage = self:GetParent():GetMaxHealth()*self.max_health_as_cost_per_second
		self.max = 1000
	end
	if IsServer() then
		local stack = keys.bonus_index*2
		stack = stack - stack%2
	
		self.life_steal = 0
		if ability:GetAutoCastState() then
			self.life_steal = 0.03
			stack = stack + 1
			if ability.advanced_level>=5 then
				self.life_steal = 0.06
			end
	
		end
		self:SetStackCount(stack)
		self.bonus_damage1 = 25
		self.bonus_damage2 = 50
		if ability.advanced_level>=10 then
			self.bonus_damage1 = self.bonus_damage1*1.3
			self.bonus_damage2 = self.bonus_damage2*1.3
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
function modifier_Advanced_Bloodrage_buff:OnRefresh(keys)
	self:OnCreated(keys)
end


function modifier_Advanced_Bloodrage_buff:DeclareFunctions()
	local funs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,         --魔法抗性
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if level>=15 then
		table.insert(funs,MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE)
		if level>=20 then
			table.insert(funs,MODIFIER_EVENT_ON_DEATH)
			table.insert(funs,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE)
		end
	end
	return  funs
end
function modifier_Advanced_Bloodrage_buff:OnIntervalThink()
	local ability = self:GetAbility()
	-- local caster = self:GetCaster()
	local parent = self:GetParent()
	local damage = self.max_health_as_cost_per_second
	if self:GetStackCount()%2==1 then
		damage = damage *3
	end
	local health = parent:GetHealth() -parent:GetMaxHealth()*damage
	parent:ModifyHealth(health,ability,false,0)

end


function modifier_Advanced_Bloodrage_buff:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()%2==1 and self.bonus_attack_speed * 1.5 or self.bonus_attack_speed end
function modifier_Advanced_Bloodrage_buff:Advanced_GetModifierSpellAmplifyBonus(keys) 
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL   then
		return  self:GetStackCount()%2==1 and self.bonus_spell_damage or self.bonus_spell_damage 
	end
	return 0
end


function modifier_Advanced_Bloodrage_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end


function modifier_Advanced_Bloodrage_buff:GetModifierBaseAttack_BonusDamage()
	return math.min(self:GetStackCount()%2==1 and self.bonus_attack_damage *3 or self.bonus_attack_damage ,self.max)
end

function modifier_Advanced_Bloodrage_buff:OnTakeDamage( params )

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



function modifier_Advanced_Bloodrage_buff:OnDeath(keys)
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	local ability = self:GetAbility()
	if ability.unlock2 then
		local caster = self:GetCaster()
		local info = 
		{
			Target = caster,
			-- Source = parent,
			Ability = ability,	
			EffectName = "particles/rebuild/spell/bloodrage/lv20/effect.vpcf",
			iMoveSpeed = 2000,
			vSourceLoc = 	parent:GetAttachmentOrigin( parent:ScriptLookupAttachment( "attach_hitloc" ) ),
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,  
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false, 
			ExtraData = {stack = 2} 
		}
		ProjectileManager:CreateTrackingProjectile(info)
		return
	end
    if keys.attacker == parent and IsEnemy(keys.unit, keys.attacker) then
		local caster = self:GetCaster()
		local info = 
		{
			Target = caster,
			-- Source = parent,
			Ability = ability,	
			EffectName = "particles/rebuild/spell/bloodrage/lv20/effect.vpcf",
			iMoveSpeed = 2000,
			vSourceLoc = 	parent:GetAttachmentOrigin( parent:ScriptLookupAttachment( "attach_hitloc" ) ),
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,  
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false, 
			ExtraData = {stack = 1} 
		}
		ProjectileManager:CreateTrackingProjectile(info)

	end

end
function modifier_Advanced_Bloodrage_buff:CheckState()
	local state = {}
	
	if self:GetAbility():GetUnlock(3)==3 then 
		state = {[MODIFIER_STATE_DISARMED] = true}
	end

	return state
end

-- advanced_modifier
function modifier_Advanced_Bloodrage_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_Advanced_Bloodrage_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return 0
	end
	local health = keys.target:GetHealthPercent()
	if health<=50 then
		if health<=15 then
			return self.bonus_damage2
		end
		return self.bonus_damage1
	end
	return 0
end



modifier_Advanced_Bloodrage_buff_lv20 = class({})

function modifier_Advanced_Bloodrage_buff_lv20:IsDebuff()			return false end
function modifier_Advanced_Bloodrage_buff_lv20:IsHidden() 			return false end
function modifier_Advanced_Bloodrage_buff_lv20:IsPurgable() 		return false end
function modifier_Advanced_Bloodrage_buff_lv20:IsPurgeException() 	return false end
function modifier_Advanced_Bloodrage_buff_lv20:RemoveOnDeath() return false end
function modifier_Advanced_Bloodrage_buff_lv20:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Bloodrage_buff_lv20:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end

function modifier_Advanced_Bloodrage_buff_lv20:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)
	end
end