Advanced_Anchor_Smash = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Anchor_Smash_buff", "skills/Advanced_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Anchor_Smash_debuff", "skills/Advanced_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Anchor_Smash_attack", "skills/Advanced_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Anchor_Smash_armor", "skills/Advanced_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_Anchor_Smash_Unlock1", "skills/Advanced_Anchor_Smash", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function Advanced_Anchor_Smash:GetIntrinsicModifierName() return "modifier_Advanced_Anchor_Smash_attack" end
function Advanced_Anchor_Smash:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/anchor_smash_torrent_splash/torrent_splash.vpcf", context )
end

function Advanced_Anchor_Smash:Spawn()
	if IsServer() then
		self.bonus_damage_unlock2 = 0
	end
end

function Advanced_Anchor_Smash:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Anchor_Smash_Unlock1",{})


	caster:RemoveAbilityByHandle(self)
	return true
end
function Advanced_Anchor_Smash:UnlockSecondCore(key)
	self.CoreUnlock = false
	self.unlock2 = false
	self.bonus_damage_unlock2 = self.bonus_damage_unlock2 +1500
	return true
end
function Advanced_Anchor_Smash:UnlockThirdCore(key)

	return true
end

function Advanced_Anchor_Smash:OnSpellStart()
	local caster = self:GetCaster()

	-- get references
	local radius = self:GetSpecialValueFor("radius")
	local pos = caster:GetAbsOrigin()


	self:AttackOnRadius(pos,radius)
	self:PlayEffects(pos,radius)

	if self.unlock3 then
		local ability = self
		local new_pos1 = pos + Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
		local new_pos2 = pos + Vector(RandomInt(-500, 500),RandomInt(-500, 500),0)
		Timers:CreateTimer(2, function()
			if ability and not ability:IsNull() then
				self:AttackOnRadius(new_pos1,300)
				self:PlayEffects2(new_pos1)
			end
			Timers:CreateTimer(2, function()
				if ability and not ability:IsNull() then
					self:AttackOnRadius(new_pos2,300)
					self:PlayEffects2(new_pos2)
				end
			end)
		end)
	end


end


function Advanced_Anchor_Smash:AttackOnRadius(pos,radius)
	local caster = self:GetCaster()
	local bonus_damage = self:GetSpecialValueFor("damage") + self.bonus_damage_unlock2+ self:GetSpecialValueFor("damage_index")*caster:GetStrength()
	--LV5解锁千钧一击+
	if self.advanced_level>=5 then
		bonus_damage = bonus_damage + 100
	end
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		pos,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Anchor_Smash_buff", -- modifier name
		{
			bonus = bonus_damage,
		} -- kv
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)

	-- Do for each affected enemies
	for i,enemy in pairs(enemies) do
		-- Add reduction modifier
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)
		enemy:AddNewModifier(caster, self, "modifier_Advanced_Anchor_Smash_debuff", {duration = 2*StatusResistance})
		--lV20解锁碎甲
		if self.advanced_level>=20 then
			enemy:AddNewModifier(caster, self, "modifier_Advanced_Anchor_Smash_armor", {duration = 15})
		end
		
		-- attack
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )
		if i>=8 then
			break
		end
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	-- destroy modifier
	if mod then
		mod:SafeDestroy()
	end
end

function Advanced_Anchor_Smash:SingleAttackEffect(target)

	local caster = self:GetCaster()
	local bonus_damage = self:GetSpecialValueFor("damage") + self.bonus_damage_unlock2+ self:GetSpecialValueFor("damage_index")*caster:GetStrength()
	--LV5解锁千钧一击+
	if self.advanced_level>=5 then
		bonus_damage = bonus_damage + 100
	end
	
	
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Anchor_Smash_buff", -- modifier name
		{
			bonus = bonus_damage,
		} -- kv
	)
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)

	local StatusResistance = target:GetHDStatusResistanceIndex(1)
	target:AddNewModifier(caster, self, "modifier_Advanced_Anchor_Smash_debuff", {duration = 2*StatusResistance})
	--lV20解锁碎甲
	if self.advanced_level>=20 then
		target:AddNewModifier(caster, self, "modifier_Advanced_Anchor_Smash_armor", {duration = 15})
	end
	
	-- attack
	caster:PerformAttack( target, true, true, true, true, false, false, true )

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	if mod then
		mod:SafeDestroy()
	end

	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_rebuildhero.vpcf"
	local sound_cast = "Hero_Tidehunter.AnchorSmash"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0,target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(0.5,0,0))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(100,0,0))
	ParticleManager:SetParticleControl( effect_cast, 62, Vector(100,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, caster )
end


function Advanced_Anchor_Smash:PlayEffects(pos,radius)
	-- get resources
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_rebuildhero.vpcf"
	local sound_cast = "Hero_Tidehunter.AnchorSmash"
	local index = radius/500

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0,pos )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(index,0,0))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius,0,0))
	ParticleManager:SetParticleControl( effect_cast, 62, Vector(radius-500,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Advanced_Anchor_Smash:PlayEffects2(pos)
	-- get resources
	local particle_cast = "particles/rebuild/spell/anchor_smash_torrent_splash/torrent_splash.vpcf"
	local sound_cast = "Ability.Torrent"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0,pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function Advanced_Anchor_Smash:CheckKV(key)
	local table = {
		damage = 6,
		damage_index  = 0.1,



	}
	local value = table[key] or -1
	return value

end



modifier_Advanced_Anchor_Smash_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Anchor_Smash_buff:IsHidden()	return true end
function modifier_Advanced_Anchor_Smash_buff:IsDebuff()	return false end
function modifier_Advanced_Anchor_Smash_buff:IsPurgable()	return false end
function modifier_Advanced_Anchor_Smash_buff:OnCreated( kv )
	if not IsServer() then return end
	self.bonus = kv.bonus
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Anchor_Smash_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_Advanced_Anchor_Smash_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus
end





modifier_Advanced_Anchor_Smash_debuff = class({})
function modifier_Advanced_Anchor_Smash_debuff:IsDebuff()				             return true  end
function modifier_Advanced_Anchor_Smash_debuff:IsPurgable() 			                 return true end
function modifier_Advanced_Anchor_Smash_debuff:IsPurgeException() 	                 return true end
function modifier_Advanced_Anchor_Smash_debuff:IsHidden()				             return false end

function modifier_Advanced_Anchor_Smash_debuff:CheckState()
	if IsClient() then
		return
	end
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}

	return state
end





modifier_Advanced_Anchor_Smash_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Anchor_Smash_attack:IsDebuff()			return false end
function modifier_Advanced_Anchor_Smash_attack:IsHidden() 			return true end
function modifier_Advanced_Anchor_Smash_attack:IsPurgable() 		return false end
function modifier_Advanced_Anchor_Smash_attack:IsPurgeException() 	return false end
function modifier_Advanced_Anchor_Smash_attack:RemoveOnDeath()  return false end
function modifier_Advanced_Anchor_Smash_attack:IsPurgeException() 	return false end
function modifier_Advanced_Anchor_Smash_attack:OnRemoved() end
function modifier_Advanced_Anchor_Smash_attack:OnDestroy() end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Anchor_Smash_attack:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Anchor_Smash_attack:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() or keys.attacker:PassivesDisabled() then
		return
	end

	local ability = self:GetAbility()
	local time = ability:GetCooldownTimeRemaining()

	if time>=10 then
		return
	end
	local chance = 5
	local plusTime = 1.5
	--LV10解锁癫狂
	if ability.advanced_level>=10 then
		chance = 7
		plusTime = 1
		if ability.unlock3 then
			plusTime = 2
		end
	end
	if self:GetCaster():GetRandomEffect(chance,INT_TYPE,0.6) >=RandomInt(1, 100) then
		ability:StartCooldown(time+plusTime)
		ability:OnSpellStart()
	end

	
end

function modifier_Advanced_Anchor_Smash_attack:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
		self.time = 0
		self.plus = true
	end
end


function modifier_Advanced_Anchor_Smash_attack:OnIntervalThink(keys)
	local ability = self:GetAbility()
	--LV15解锁潮汐
	if ability.advanced_level>=15 then
		if self.plus then
			self.time = self.time+0.001
		else
			self.time = self.time-0.001
		end
		if self.time>=0.03 then
			self.plus = false
		end
		if self.time<=-0.2 then
			self.plus = true
		end
		if not ability:IsCooldownReady() then
			local cooldown = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cooldown+self.time)
		end
		self:StartIntervalThink(0.1)
	end
	
end









modifier_Advanced_Anchor_Smash_armor = advanced_modifier({})

function modifier_Advanced_Anchor_Smash_armor:IsDebuff() return true end
function modifier_Advanced_Anchor_Smash_armor:IsHidden() return false end
function modifier_Advanced_Anchor_Smash_armor:IsPurgable() return false end
function modifier_Advanced_Anchor_Smash_armor:GetTexture() return "tidehunter_anchor_smash" end

function modifier_Advanced_Anchor_Smash_armor:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Anchor_Smash_armor:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Anchor_Smash_armor:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end


function modifier_Advanced_Anchor_Smash_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_Anchor_Smash_armor:Advanced_GetModifierPhysicalArmorBonus()
    return -1.5*self:GetStackCount()
end







modifier_Advanced_Anchor_Smash_Unlock1 = class({})

function modifier_Advanced_Anchor_Smash_Unlock1:IsDebuff()			return false end
function modifier_Advanced_Anchor_Smash_Unlock1:IsHidden() 			return false end
function modifier_Advanced_Anchor_Smash_Unlock1:IsPurgable() 		return false end
function modifier_Advanced_Anchor_Smash_Unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Anchor_Smash_Unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Anchor_Smash_Unlock1:DestroyOnExpire() return false end
function modifier_Advanced_Anchor_Smash_Unlock1:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Anchor_Smash_Unlock1:GetTexture() return "tidehunter_anchor_smash" end
function modifier_Advanced_Anchor_Smash_Unlock1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_Advanced_Anchor_Smash_Unlock1:OnCreated(table)
	if IsServer() then
		local ability = self:GetAbility()
		self.radius = ability:GetSpecialValueFor("radius")
		self.bonus_damage = ability:GetSpecialValueFor("damage") +100 + ability.bonus_damage_unlock2+ self:GetSpecialValueFor("damage_index")*caster:GetStrength()
	end
end

function modifier_Advanced_Anchor_Smash_Unlock1:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() or keys.attacker:PassivesDisabled() then
		return
	end

	local time = self:GetRemainingTime()

	if time>=10 then
		return
	end
	local chance = 30


	if self:GetCaster():GetRandomEffect(chance,INT_TYPE,0.6) >=RandomInt(1, 100) then
		self:SetDuration(math.max(time+1,1), true)
		self:Trigger()

	end

	
end

function modifier_Advanced_Anchor_Smash_Unlock1:Trigger()
	local caster = self:GetCaster()

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	local mod = caster:AddNewModifier(caster,self,"modifier_Advanced_Anchor_Smash_buff",
		{
			bonus = self.bonus_damage,
		}
	)
	
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(nil,modifier_keys)

	for i,enemy in pairs(enemies) do
		local ModifierStatusGain = enemy:GetModifierDurationGainIndex(1)
		enemy:AddNewModifier(caster, nil, "modifier_Advanced_Anchor_Smash_debuff", {duration = 2*ModifierStatusGain})
		enemy:AddNewModifier(caster, nil, "modifier_Advanced_Anchor_Smash_armor", {duration = 15})
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )
		if i>=8 then
			break
		end
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	if mod then
		mod:SafeDestroy()
	end
	
	self:PlayEffects()
end

function modifier_Advanced_Anchor_Smash_Unlock1:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_rebuildhero.vpcf"
	local sound_cast = "Hero_Tidehunter.AnchorSmash"
	local radius = self.radius
	local index = radius/500
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(index,0,0))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(radius,0,0))
	ParticleManager:SetParticleControl( effect_cast, 62, Vector(radius-500,0,0))
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end