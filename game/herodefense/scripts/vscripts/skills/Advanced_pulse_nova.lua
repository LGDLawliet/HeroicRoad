--特效优化 √
Advanced_pulse_nova = class({})
LinkLuaModifier( "modifier_Advanced_pulse_nova", "skills/Advanced_pulse_nova", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_pulse_nova_debuff", "skills/Advanced_pulse_nova", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Advanced_pulse_nova:CheckKV(key)
	local table = {

	


		damage = 4,
		bonus_damage = 0.04,




	}
	local value = table[key] or -1
	return value

end

function Advanced_pulse_nova:UnlockFirstCore(key)
	return true
end
function Advanced_pulse_nova:UnlockSecondCore(key)
	return true
end
function Advanced_pulse_nova:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Dragons_Lighting_unlock3",{})
	return true
end
function Advanced_pulse_nova:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/pulse_nova/effect2/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/pulse_nova/effect2_hit/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/pulse_nova/effect2_hit/impact_model_images.vpcf", context )




end


function Advanced_pulse_nova:OnSpellStart()

	local caster    =   self:GetCaster()

	local modifier = caster:FindModifierByName("modifier_Advanced_pulse_nova")
	if modifier then
		modifier:SafeDestroy()
		self.modifier = nil
		return
	end

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	self.modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_pulse_nova", {})

end
function Advanced_pulse_nova:GetCastRange()



	local caster =self:GetCaster()

	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

modifier_Advanced_pulse_nova = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_pulse_nova:IsHidden()	return false end
function modifier_Advanced_pulse_nova:IsDebuff()	return false end
function modifier_Advanced_pulse_nova:IsPurgable()	return false end
-- function modifier_Advanced_pulse_nova:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT 
-- end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_pulse_nova:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus_int = 2
	self.bonus_mana_cost = 0.008
	--LV5解锁无尽折磨+
	if self.advanced_level>=5 then
		self.bonus_mana_cost = 0.006
	end
	self.max_int = 100
	if self:GetAbility():GetUnlock(3)==3 then
		self.max_int = 500
	end

	if not IsServer() then return end
	-- references
	self:SetStackCount(math.min(self:GetStackCount()+1, 300))
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.manacost = self:GetAbility():GetSpecialValueFor( "mana_cost_per_second" )*self:GetCaster():GetIntellect(false)
	local interval = 1

	-- precache
	self.parent = self:GetParent()

	-- ApplyDamage(damageTable)

	-- Start interval
	self:Burn()
	self:StartIntervalThink( interval )

	-- play effects
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	EmitSoundOn( sound_loop, self.parent )
	self:AddAttachEffce()
	self.particle_hit = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	local type = particleManager:GetSpellParticle(self.parent:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
	if type=="ability_particle_9" then
		self.particle_hit = "particles/rebuild/spell/pulse_nova/effect2_hit/effect.vpcf"
		self.bonus_hit = "particles/rebuild/spell/pulse_nova/effect2_hit/impact_model_images.vpcf"
	end
end

function modifier_Advanced_pulse_nova:OnRefresh( kv )
end

function modifier_Advanced_pulse_nova:OnRemoved()
end

function modifier_Advanced_pulse_nova:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	StopSoundOn( sound_loop, self.parent )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_pulse_nova:OnIntervalThink()
	-- check mana
	self:SetStackCount(math.min(self:GetStackCount()+1, 300))
	local mana = self.parent:GetMana()
	if mana < self.manacost then
		-- turn off
		self:SafeDestroy()
		return
	end

	-- damage
	self:Burn()
end

function modifier_Advanced_pulse_nova:Burn()
	-- spend mana
	local stack = self:GetStackCount()
	local ability = self:GetAbility()
	--LV10解锁能量吸收+
	if self.advanced_level>=10 then
		self.manacost =ability:GetSpecialValueFor( "mana_cost_per_second" )*(self:GetCaster():GetIntellect(false)-self.bonus_int*(math.min(self:GetStackCount(), 100))*0.5 )
	else
		self.manacost =ability:GetSpecialValueFor( "mana_cost_per_second" )*self:GetCaster():GetIntellect(false)
	end
	self.manacost = (self.manacost + 1 )*(1+stack*self.bonus_mana_cost)
	--LV20解锁虚无
	if self.advanced_level>=20 and 25>=RandomInt(1, 100) then
		--do nothing
	else
		self.parent:SpendMana( self.manacost, ability )
	end
	-- print(self.manacost)
	local radius = self.radius
	--LV15解锁延展
	if self.advanced_level>=15 then
		radius = math.min(5*self:GetStackCount(),1000)+radius
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damage = (ability:GetSpecialValueFor( "damage" )+ability:GetSpecialValueFor( "bonus_damage" )*self.parent:GetIntellect(false))*(1+stack*0.01)
	if self.parent:HasAbility("heroTalent_npc_dota_hero_leshrac_2") then
		local spell_amp = self.parent:GetSpellAmplification(false)
		if spell_amp>0 then
			damage = damage * (1+spell_amp*0.3)
		end
	end
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}
	if ability.unlock1 then
		for _,enemy in pairs(enemies) do
			-- apply damage
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			if self.parent:GetRandomEffect(10,INT_TYPE,1)  > RandomInt(1, 100)  then
				if not enemy.pulse_nova_unlock1 or enemy.pulse_nova_unlock1<= GameRules:GetGameTime() then
					enemy:AddNewModifier(self.parent, ability, "modifier_Advanced_pulse_nova_debuff", {duration = 3})
					enemy.pulse_nova_unlock1 = GameRules:GetGameTime()+5
				end
			
		
			end
	
			-- play effects
			self:PlayEffects( enemy )
		end
	elseif ability.unlock2 then

		self.damageTable.damage = self.damageTable.damage * #enemies*2
		local current_damage = self.damageTable.damage
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			local health = enemy:GetHealth()
			self.damageTable.damage = math.min(health,current_damage)
			ApplyDamage( self.damageTable )

			self:PlayEffects( enemy )
			current_damage = current_damage - health
			if current_damage<=0 then
				break
			end
		end

	else
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			self:PlayEffects( enemy )
		end
	end

end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_Advanced_pulse_nova:GetEffectName()
-- 	return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"

-- end

-- function modifier_Advanced_pulse_nova:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_Advanced_pulse_nova:PlayEffects( target )
	-- Get Resources
	-- local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	-- particles/rebuild/spell/pulse_nova/effect2_hit/effect.vpcf
	local sound_cast = "Hero_Leshrac.Pulse_Nova_Strike"

	-- radius
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_hit, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if self.bonus_hit then

		local effect_cast = ParticleManager:CreateParticle( self.bonus_hit, PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin()  )
		-- ParticleManager:SetParticleControlEnt(
		-- 	effect_cast,
		-- 	1,
		-- 	target,
		-- 	PATTACH_POINT_FOLLOW,
		-- 	"attach_hitloc",
		-- 	Vector(0,0,0), -- unknown
		-- 	true -- unknown, true
		-- )

		-- ParticleManager:SetParticleControlEnt(
		-- 	effect_cast,
		-- 	0,
		-- 	target,
		-- 	PATTACH_POINT_FOLLOW,
		-- 	"attach_hitloc",
		-- 	Vector(0,0,0), -- unknown
		-- 	true -- unknown, true
		-- )

		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	EmitSoundOn( sound_cast, target )
end
function modifier_Advanced_pulse_nova:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

		

	}
end

function modifier_Advanced_pulse_nova:GetModifierBonusStats_Intellect()	return self.bonus_int*(math.min(self:GetStackCount(), self.max_int)) end


function modifier_Advanced_pulse_nova:AddAttachEffce()
	local pfx_name ="particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
	local parent = self:GetParent()
	local type = particleManager:GetSpellParticle(parent:GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
	if type=="ability_particle_9" then
		pfx_name = "particles/rebuild/spell/pulse_nova/effect2/effect.vpcf"
	end
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CENTER_FOLLOW , parent)
	self:AddParticle(pfx, false, false, 15, false, false)

end








modifier_Advanced_pulse_nova_debuff = class({})

function modifier_Advanced_pulse_nova_debuff:IsDebuff()			return true end
function modifier_Advanced_pulse_nova_debuff:IsHidden() 			return false end
function modifier_Advanced_pulse_nova_debuff:IsPurgable() 		return true end
function modifier_Advanced_pulse_nova_debuff:IsPurgeException() 	return true end
function modifier_Advanced_pulse_nova_debuff:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Advanced_pulse_nova_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_pulse_nova_debuff:CheckState() return {
	[MODIFIER_STATE_ATTACK_IMMUNE] = true, 
	[MODIFIER_STATE_DISARMED] = true, 
} 
end
function modifier_Advanced_pulse_nova_debuff:DeclareFunctions() return
	 {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} 
end

function modifier_Advanced_pulse_nova_debuff:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Advanced_pulse_nova_debuff:GetModifierMagicalResistanceBonus() return -100 end


