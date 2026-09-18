--特效优化 √


Advanced_infernal_blade = Advanced_infernal_blade or class({})

LinkLuaModifier("modifier_Advanced_infernal_blade_debuff", "skills/Advanced_infernal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_infernal_blade_orb", "skills/Advanced_infernal_blade", LUA_MODIFIER_MOTION_NONE)
function Advanced_infernal_blade:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/infernal_blade/unlock2/effect.vpcf", context )

end

function Advanced_infernal_blade:CheckKV(key)
	local table = {

	

		damage =3,
		burn_duration = 0.08,


	}
	local value = table[key] or -1
	return value

end

function Advanced_infernal_blade:UnlockFirstCore(key)
	local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	local modifier = caster:FindModifierByName("modifier_Advanced_infernal_blade_orb")
	if modifier then
		modifier:StartIntervalThink(1)
	end
	return true
end
function Advanced_infernal_blade:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	return true
end
function Advanced_infernal_blade:UnlockThirdCore(key)
	return true
end




function Advanced_infernal_blade:GetIntrinsicModifierName()
	return "modifier_Advanced_infernal_blade_orb"
end

function Advanced_infernal_blade:OnSpellStart()
	self:OnOrbImpact( self:GetCaster():GetCursorCastTarget() )
end

function Advanced_infernal_blade:OnOrbImpact( target )
	-- get reference
	local duration = self:GetSpecialValueFor( "burn_duration" )
	local bash = self:GetSpecialValueFor( "stun_duration" )

	local caster = self:GetCaster()

	local NegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance =target:GetHDStatusResistanceIndex()
	if self.advanced_level>=10 then
		duration = duration + 1
	end
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_infernal_blade_debuff", -- modifier name
		{ duration = duration*NegativeGain } -- kv
	)

	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = bash*StatusResistance*NegativeGain } -- kv
	)
end





modifier_Advanced_infernal_blade_orb = modifier_Advanced_infernal_blade_orb or class({})

function modifier_Advanced_infernal_blade_orb:IsDebuff()			return false end
function modifier_Advanced_infernal_blade_orb:IsHidden() 			return false end
function modifier_Advanced_infernal_blade_orb:IsPurgable() 		return false end
function modifier_Advanced_infernal_blade_orb:IsPurgeException() 	return false end
function modifier_Advanced_infernal_blade_orb:RemoveOnDeath() return false end
function modifier_Advanced_infernal_blade_orb:DestroyOnExpire() return false end
function modifier_Advanced_infernal_blade_orb:OnCreated()
	if IsServer() then
		self.attack_record = {}
		-- self.record_ok = false
	end
end
function modifier_Advanced_infernal_blade_orb:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability:GetAutoCastState() then
		return
	end
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(),parent:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- local count = 1
	ability:OnOrbImpact(parent)
	for i,enemy in pairs(enemies) do
		ability:OnOrbImpact(enemy)
		if i>=5 then
			break
		end
		
	end
end
-- function modifier_Advanced_infernal_blade_orb:OnDestroy()
-- 	if IsServer() and self.pfx then
-- 		self.pfx = nil
-- 	end
-- end
function modifier_Advanced_infernal_blade_orb:DeclareFunctions()
	 return 
	 {
		MODIFIER_EVENT_ON_ATTACK,
	 	MODIFIER_EVENT_ON_ATTACK_LANDED,
	} 
	end
function modifier_Advanced_infernal_blade_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if ability.unlock1 then
		return
	end
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
function modifier_Advanced_infernal_blade_orb:OnAttackLanded(keys)
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	if self.attack_record[keys.record] then
		self.attack_record[keys.record] = nil
	
		if not ability:IsFullyCastable() then
			return
		end
		if keys.fail_type==DOTA_ATTACK_RECORD_FAIL_NO  then
			local chance = 25
			if ability.advanced_level>=5 then
				chance = 35
			end
			if chance>=RandomInt(1, 100) then
				--do nothing
			else
				ability:UseResources(true, true, true, true)
			end
			
			ability:OnOrbImpact(keys.target)
			if ability.advanced_level>=20 then
				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local count = 1
				for _,enemy in pairs(enemies) do
					if enemy~=keys.target then
						ability:OnOrbImpact(enemy)
						count = count - 1
						if count<=0 then
							break
						end
					end
					
				end
			end
		end
	end

	if ability.unlock3 and keys.attacker==self:GetParent() then
		if keys.attacker:IsApplyModifier() then
			if self:GetRemainingTime()>=10 then
				return
			end
			if 15>=RandomInt(1, 100) then
				self:SetDuration(math.max(self:GetRemainingTime()+0.5,0.5), true)
				ability:OnOrbImpact(keys.target)
			end
		end
	end
end







modifier_Advanced_infernal_blade_debuff = modifier_Advanced_infernal_blade_debuff or class({})
function modifier_Advanced_infernal_blade_debuff:IsHidden()	return false end
function modifier_Advanced_infernal_blade_debuff:IsDebuff()	return true end
function modifier_Advanced_infernal_blade_debuff:IsStunDebuff()	return false end
function modifier_Advanced_infernal_blade_debuff:IsPurgable()	return self.purgeable end
function modifier_Advanced_infernal_blade_debuff:IsPurgeException()return self.purgeable end
-- function modifier_Advanced_infernal_blade_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_infernal_blade_debuff:OnCreated( keys )
	local ability = self:GetAbility()
	self.purgeable = true
	local level = ability:GetSpecialValueFor("advanced_level")
	if level>=10 then
		self.purgeable = false
	end
	if not IsServer() then return end

	
	self.damage = ability:GetSpecialValueFor( "damage" )
	self.damage_pct = ability:GetSpecialValueFor( "bonus_damage" )*0.01
	self.bonus_damage_max = ability:GetSpecialValueFor("bonus_damage_max")
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type =ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	self.timer = GameRules:GetGameTime()+1

	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	self:IncrementStackCount()
	self:StartIntervalThink( 0.1 )
	self:PlayEffects()
	self.unlock2_damage_count = 0
	self.unlock2_timer = GameRules:GetGameTime() + 5
	if ability.unlock2 then
		self.unlock2 = true
	end

end

function modifier_Advanced_infernal_blade_debuff:OnRefresh( keys )
	local ability = self:GetAbility()
	local level = ability:GetSpecialValueFor("advanced_level")
	if level>=10 then
		self.purgeable = false
	end
	if not IsServer() then return end
	-- local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor( "damage" )
	self.damage_pct = ability:GetSpecialValueFor( "bonus_damage" )*0.01
	self.bonus_damage_max = ability:GetSpecialValueFor("bonus_damage_max")
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	self:IncrementStackCount()
	self:PlayEffects()
	if ability.unlock2 then
		self.unlock2 = true
	end
end

function modifier_Advanced_infernal_blade_debuff:OnDestroy()

	if IsServer() then
		if self.unlock2 then
			self:Unlock2Effect()
		end
	end
end

function modifier_Advanced_infernal_blade_debuff:OnIntervalThink()
	local fGameTime = GameRules:GetGameTime()

	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].dieTime then
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end

	if fGameTime>=self.timer then
		self.timer = self.timer + 1
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local damage =  self:GetParent():GetMaxHealth()*self.damage_pct
		-- print("damage1="..damage)
		damage = math.min(damage,self:GetCaster():GetAverageTrueAttackDamage(nil)*self.bonus_damage_max)
		damage = math.max(damage,0)
		self.damageTable.damage = (self.damage + damage)*self:GetStackCount()
		if ability.advanced_level>=15 then
			local debuff_count = self:GetParent():FindDebuffCount()
			if debuff_count>=1 then
				-- print("debuff_count="..debuff_count)
				self.damageTable.damage = self.damageTable.damage * (1+debuff_count*0.08)
			end
		end
		local real_damage = ApplyDamage( self.damageTable )
		-- if self.unlock2 then
		-- 	self.unlock2_damage_count = self.unlock2_damage_count + real_damage *0.3
		-- end
	end

	if fGameTime>=self.unlock2_timer then
		self.unlock2_timer = self.unlock2_timer + 5
		self:Unlock2Effect()
	end
end
function modifier_Advanced_infernal_blade_debuff:Unlock2Effect()
	if self.unlock2_damage_count>=5 then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),self:GetParent():GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {
			-- victim = self:GetParent(),
			attacker = caster,
			damage = self.unlock2_damage_count,
			damage_type =ability:GetAbilityDamageType(),
			ability = ability, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		}
		for _, unit in ipairs(enemies) do
			damageTable.victim = unit
			ApplyDamage( damageTable )
		end
		local particle_cast = "particles/rebuild/spell/infernal_blade/unlock2/effect.vpcf"
		local sound_cast = "Hero_DoomBringer.InfernalBlade.Target"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		DestroyParticleByDelay(effect_cast,5)
		EmitSoundOn( sound_cast, self:GetParent() )
		self.unlock2_damage_count = 0
	end

end
function modifier_Advanced_infernal_blade_debuff:GetEffectName()	return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf" end
function modifier_Advanced_infernal_blade_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_infernal_blade_debuff:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf"
	local sound_cast = "Hero_DoomBringer.InfernalBlade.Target"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_Advanced_infernal_blade_debuff:DeclareFunctions() 
	local funcs ={}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	return funcs
end


function modifier_Advanced_infernal_blade_debuff:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		self.unlock2_damage_count = self.unlock2_damage_count + flDamage *0.3



	end

	return 0.0

end