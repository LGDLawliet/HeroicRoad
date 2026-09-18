LinkLuaModifier("modifier_chaotic_ice_storm_debuff", "chaotic_spell/class_4/chaotic_ice_storm", LUA_MODIFIER_MOTION_NONE)

chaotic_ice_storm = class({})
function chaotic_ice_storm:Precache( context )
	PrecacheResource( "particle", "particles/rebuid/chaotic_spell/chaotic_ice_storm/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_hit.vpcf", context )
end

function chaotic_ice_storm:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_ice_storm:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	return cost
end

function chaotic_ice_storm:OnSpellStart()
	local caster = self:GetCaster()

	caster:EmitSound("chaotic_ice_storm_cast")  
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()

	self:ApplySpellEffect(target_pos,caster_pos,0.1)
	if self:GetRuneType()==1 then
		local rune_1_delay_1 = self:GetSpecialValueFor("rune_1_delay_1")
		local rune_1_delay_2 = self:GetSpecialValueFor("rune_1_delay_2")
		local rune_1_index_1 = self:GetSpecialValueFor("rune_1_index_1")*0.01
		local rune_1_index_2 = self:GetSpecialValueFor("rune_1_index_2")*0.01
		if self:IsOwnersManaEnough() then
			self:ApplySpellEffect(target_pos,caster_pos,rune_1_delay_1,rune_1_index_1)
			self:UseResources(true, true, true, false)
			if self:IsOwnersManaEnough() then
				self:ApplySpellEffect(target_pos,caster_pos,rune_1_delay_2,rune_1_index_2)
				self:UseResources(true, true, true, false)
			end
		end
	end
end

function chaotic_ice_storm:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	local StatusResistance = target:GetHDStatusResistanceIndex(0.6)
	target:AddNewModifier(caster, self, "modifier_chaotic_ice_storm_debuff", {duration = duration*StatusResistance})
end

function chaotic_ice_storm:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_hit.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
end



function chaotic_ice_storm:ApplySpellEffect(target_pos,caster_pos,delay,damageindex)
	if not damageindex then damageindex = 1 end
	
	local caster = self:GetCaster()
	EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_cast", caster)

	local dir = CalculateDirection(target_pos,caster_pos)
	if caster_pos==target_pos then
		dir = caster:GetForwardVector()
	end

	local effect_gain= self:GetEffectGain()
	local index_1 = self:GetSpecialValueFor("index_1")*0.01
	local index_2 = self:GetSpecialValueFor("index_2")*0.01
	local radius = self:GetSpecialValueFor("radius")
	local count = 8
	caster:GameTimer(delay, function()
		if not IsValid(self) then
			return
		end
		local speed = 3000

		for i = 1, 6, 1 do
			local end_pos = target_pos + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),0)
			end_pos = GetGroundPosition( end_pos, nil )
			local spawn_pos = end_pos - dir *350 + Vector(0,0,1500 + RandomInt(-300, 1200)) 
	
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuid/chaotic_spell/chaotic_ice_storm/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, spawn_pos )
			ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
			ParticleManager:SetParticleControl( effect_cast, 2, Vector(speed,0,0) )
			local delay = CalculateDistance3D(spawn_pos, end_pos)/speed+0.03
			ParticleManager:SetParticleControl( effect_cast, 4, Vector(delay,0,0) )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			speed = speed +500
		end
		count = count - 1
		EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_target", caster)
		if count<=0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

			local damageTable = {
				attacker	= self:GetCaster(),
				-- victim = target,
				damage		= (self:GetSpecialValueFor("base_damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage"))*effect_gain*damageindex,
				damage_type	= self:GetAbilityDamageType(),
				ability		= self,
				hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
			}
			-- damageTable.damage = 5
		
			local duration = self:GetSpecialValueFor("duration") *  caster:GetModifierStatusNegativeGainIndex(0.6)
		
			for _, unit in ipairs(enemies) do
				self:PlayEffect(unit)
				damageTable.victim = unit
				if unit:HasModifier("modifier_hd_freezing") then
					damageTable.damage = damageTable.damage*(1+index_1)
				end
				if unit:HasModifier("modifier_hd_freezing_frozen") then
					damageTable.damage = damageTable.damage*(1+index_2)
				end
				ApplyDamage(damageTable)
				if IsValid(unit) and unit:IsAlive() then
					self:ApplyModifier(unit, duration)
				end
			end
			return nil
		end

		return 0.03
	end)
end



modifier_chaotic_ice_storm_debuff = advanced_modifier({})

function modifier_chaotic_ice_storm_debuff:IsHidden() 			return false end
function modifier_chaotic_ice_storm_debuff:IsPurgable() 			return false end
function modifier_chaotic_ice_storm_debuff:IsPurgeException() 	return false end
function modifier_chaotic_ice_storm_debuff:IsDebuff() return true end
function modifier_chaotic_ice_storm_debuff:OnCreated(keys)
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow")
	self.attack_slow = -self:GetAbility():GetSpecialValueFor("attack_slow")
	if IsServer() then
		
	end
end




function modifier_chaotic_ice_storm_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_ice_storm_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end
function modifier_chaotic_ice_storm_debuff:GetModifierAttackSpeedBonus_Constant() return   self.attack_slow end


function modifier_chaotic_ice_storm_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Constant()
	elseif self._tooltip == 2 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
end
