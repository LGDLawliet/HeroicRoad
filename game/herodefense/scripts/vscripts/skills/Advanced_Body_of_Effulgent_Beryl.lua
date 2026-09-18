Advanced_Body_of_Effulgent_Beryl = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Body_of_Effulgent_Beryl", "skills/Advanced_Body_of_Effulgent_Beryl", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Body_of_Effulgent_Beryl_passive", "skills/Advanced_Body_of_Effulgent_Beryl", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker", "skills/Advanced_Body_of_Effulgent_Beryl", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect", "skills/Advanced_Body_of_Effulgent_Beryl", LUA_MODIFIER_MOTION_NONE )


function Advanced_Body_of_Effulgent_Beryl:CheckKV(key)
	local table = {
		bonus_armor_shield = 0.2,
		bonus_shield = 6,



	}
	local value = table[key] or -1
	return value

end


function Advanced_Body_of_Effulgent_Beryl:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Body_of_Effulgent_Beryl_passive",{} )
	return true
end
function Advanced_Body_of_Effulgent_Beryl:UnlockSecondCore(key)
	return true
end
function Advanced_Body_of_Effulgent_Beryl:UnlockThirdCore(key)
	return true
end



function Advanced_Body_of_Effulgent_Beryl:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/body_of_effulgent_beryl/unlock2/effect/rebuild/spell/zet_telent/arc_warden_magnetic.vpcf", context )
end



function Advanced_Body_of_Effulgent_Beryl:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_WitchDoctor.Voodoo_Restoration")
	-- caster:EmitSound("Hero_ShadowDemon.ShadowPoison.Impact")
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_ShadowDemon.ShadowPoison.Impact", caster)
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/body_of_effulgent_beryl_cast/body_of_effulgent_beryl.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(100,0,0))
	ParticleManager:SetParticleControl(pfx, 2, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local gain = caster:GetModifierDurationGainIndex(1)
	if self.unlock2 then
		local thinker =CreateModifierThinker(
			caster,
			self,
			"modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker",
			{
				duration = self:GetSpecialValueFor("duration")*gain,
			},
			caster:GetAbsOrigin(),
			caster:GetTeamNumber(),
			false
		)
		return
	end

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

	caster:AddNewModifier(caster, self, "modifier_Advanced_Body_of_Effulgent_Beryl", {duration = self:GetSpecialValueFor("duration")*gain})

end


modifier_Advanced_Body_of_Effulgent_Beryl = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Body_of_Effulgent_Beryl:IsHidden()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl:IsDebuff()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl:IsPurgable()	return false end
-- function modifier_Advanced_Body_of_Effulgent_Beryl:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT 
-- end



function modifier_Advanced_Body_of_Effulgent_Beryl:GetEffectName()
	return "particles/rebuild/spell/body_of_effulgent_beryl/body_of_effulgent_beryll.vpcf"
end

function modifier_Advanced_Body_of_Effulgent_Beryl:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function modifier_Advanced_Body_of_Effulgent_Beryl:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
-- 	}
-- end
function modifier_Advanced_Body_of_Effulgent_Beryl:OnCreated(keys)
	if IsServer() then
		self.ability=self:GetAbility()
		self.advanced_level = self.ability.advanced_level
		self.index = 0.5
		self.bonus_index = 0.1

		if self.advanced_level>=5 then
			self.bonus_index  = 0.15
			if self.advanced_level>=10 then
				self.index =1

			end
		end
		self.parent=self:GetParent()
		self.health = self.parent:GetHealth()
		self:SetStackCount(5)
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Body_of_Effulgent_Beryl:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(5)
		self:StartIntervalThink(1)
	end
end


function modifier_Advanced_Body_of_Effulgent_Beryl:OnDestroy(keys)
	if IsServer() then
		local health = self.parent:GetHealth()
		if self.health>health and self.parent:IsAlive() then
			local amount = self.health-health
			self.parent:SetHealth(health + amount*self.index)
			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/body_of_effulgent_beryl_cast/body_of_effulgent_beryl_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
			-- ParticleManager:SetParticleControl(pfx, 1, Vector(100,0,0))

			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end


function modifier_Advanced_Body_of_Effulgent_Beryl:OnIntervalThink()
	self:DecrementStackCount()
	if self:GetStackCount()<=0 then
		self:StartIntervalThink(-1)
	end
end
--物理伤害阻挡
-- function modifier_Advanced_Body_of_Effulgent_Beryl:GetModifierPhysical_ConstantBlock(keys)  
-- 	if self.ability:IsNull() then
-- 		return
-- 	end
-- 	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")
-- 	if self.advanced_level>=15 then
-- 		block = block*1.2
-- 	else
-- 		if keys.damage_category ==DOTA_DAMAGE_CATEGORY_SPELL  then --LV15以下只针对攻击伤害
-- 			return
-- 		end
-- 	end
-- 	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
-- 		return
-- 	end
-- 	--生命丢失也不要
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
-- 		return 0
-- 	end

-- 	if self:GetStackCount()>0 then
-- 		block = math.max(block,self.parent:GetMaxHealth()*self.bonus_index )
-- 		local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_weapon_rainmaker/windrunner_spell_powershot_destruction_sparkles.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
-- 		--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
-- 		-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
-- 		local pos = self.parent:GetAbsOrigin()
-- 		ParticleManager:SetParticleControl(pfx, 0, pos)
-- 		pos.z = pos.z +100
-- 		ParticleManager:SetParticleControl(pfx, 3, pos)

-- 		ParticleManager:ReleaseParticleIndex(pfx)
-- 	end
-- 	if self.advanced_level>=20 then
		
-- 		local damageTable = {
-- 			victim = keys.attacker,
-- 			attacker = self.parent,
-- 			-- attacker = self.caster,
-- 			damage = math.min(keys.damage,block)*0.3,
-- 			damage_type = DAMAGE_TYPE_PHYSICAL,
-- 			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
-- 			ability = self.ability, --Optional.
-- 		}
-- 		ApplyDamage(damageTable)
-- 		local particle_cast = "particles/rebuild/spell/body_of_effulgent_beryl_return/body_of_effulgent_beryl_return.vpcf"
-- 		local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self.parent)
-- 		ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
-- 		ParticleManager:SetParticleControlEnt(particle_return_fx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.attacker:GetAbsOrigin(), true)
-- 		ParticleManager:ReleaseParticleIndex(particle_return_fx)
-- 		if self.ability.unlock3 then
-- 			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.attacker:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
-- 			for i,unit in pairs(units) do
-- 				if unit~=keys.attacker then
-- 					damageTable.victim = unit
-- 					ApplyDamage(damageTable)
-- 					local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  keys.attacker)
-- 					ParticleManager:SetParticleControlEnt(particle_return_fx, 0,keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
-- 					ParticleManager:SetParticleControlEnt(particle_return_fx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
-- 					ParticleManager:ReleaseParticleIndex(particle_return_fx)
-- 				end
-- 			end
		
-- 		end

-- 	end

-- 	return block 
-- end




function modifier_Advanced_Body_of_Effulgent_Beryl:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_Body_of_Effulgent_Beryl:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if self.ability:IsNull() then
		return 0
	end
	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")
	if self.advanced_level>=15 then
		block = block*1.2
	else
		if keys.damage_category ==DOTA_DAMAGE_CATEGORY_SPELL  then --LV15以下只针对攻击伤害
			return 0
		end
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	--生命丢失也不要
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end

	if self:GetStackCount()>0 then
		block = math.max(block,self.parent:GetMaxHealth()*self.bonus_index )
		local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_weapon_rainmaker/windrunner_spell_powershot_destruction_sparkles.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
		local pos = self.parent:GetAbsOrigin()
		ParticleManager:SetParticleControl(pfx, 0, pos)
		pos.z = pos.z +100
		ParticleManager:SetParticleControl(pfx, 3, pos)

		ParticleManager:ReleaseParticleIndex(pfx)
	end
	if self.advanced_level>=20 then
		
		local damageTable = {
			victim = keys.attacker,
			attacker = self.parent,
			-- attacker = self.caster,
			damage = math.min(keys.damage,block)*0.3,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
		ApplyDamage(damageTable)
		local particle_cast = "particles/rebuild/spell/body_of_effulgent_beryl_return/body_of_effulgent_beryl_return.vpcf"
		local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self.parent)
		ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_return_fx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.attacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_return_fx)
		if self.ability.unlock3 then
			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.attacker:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for i,unit in pairs(units) do
				if unit~=keys.attacker then
					damageTable.victim = unit
					ApplyDamage(damageTable)
					local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  keys.attacker)
					ParticleManager:SetParticleControlEnt(particle_return_fx, 0,keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_return_fx, 1,unit, PATTACH_POINT_FOLLOW, "attach_hitloc",  unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle_return_fx)
				end
			end
		
		end

	end

	return block 
end









modifier_Advanced_Body_of_Effulgent_Beryl_passive = class({})


function modifier_Advanced_Body_of_Effulgent_Beryl_passive:IsHidden()	return true end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:IsDebuff()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:IsStunDebuff()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:RemoveOnDeath()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:DestroyOnExpire()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:IsPurgable() 		return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:IsPurgeException() 	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_Advanced_Body_of_Effulgent_Beryl_passive:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsAlive() then	
		local ability = self:GetAbility()
		if not ability then
			self:SafeDestroy()
			return
		end
		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Body_of_Effulgent_Beryl",{} )
	end
end





modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker = class({})
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:IsAura()	return self:GetAbility() end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:GetModifierAura()	return "modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect" end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:GetAuraRadius()	return 600  end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:OnCreated(params)
	if IsServer() then
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/body_of_effulgent_beryl/unlock2/effect/rebuild/spell/zet_telent/arc_warden_magnetic.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(600,0,0) )
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
	end
end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast,false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	UTIL_Remove( self:GetParent() )
end


modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect = advanced_modifier({})
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:IsHidden()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:IsDebuff()	return false end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:IsPurgable()	return false end
-- function modifier_Advanced_Vengeance_Aura_unlock3_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:GetEffectName()
	return "particles/rebuild/spell/body_of_effulgent_beryl/body_of_effulgent_beryll.vpcf"
end

function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
-- 	}
-- end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:OnCreated(keys)
	if IsServer() then
		self.ability=self:GetAbility()
		self.owner = self:GetAuraOwner()
		self.advanced_level = self.ability.advanced_level
		self.index = 1
		self.bonus_index = 0.075
		self.parent=self:GetParent()
		self.health = self.parent:GetHealth()

	end
end



function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:OnDestroy(keys)
	if IsServer() then
		local health = self.parent:GetHealth()
		if self.health>health and self.parent:IsAlive() then
			local amount = self.health-health
			self.parent:SetHealth(health + amount*self.index)
			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/body_of_effulgent_beryl_cast/body_of_effulgent_beryl_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end
end



--物理伤害阻挡
-- function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:GetModifierPhysical_ConstantBlock(keys)  
-- 	if not self.owner or self.owner:IsNull() or self.ability:IsNull() then
-- 		self:SafeDestroy()
-- 		return
-- 	end
-- 	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")
-- 	block = block*1.2
-- 	if CalculateDistance(self.owner,keys.attacker)>=600 then
-- 		block = block * 3
-- 	end
-- 	block = math.max(block,self.parent:GetMaxHealth()*self.bonus_index )
-- 	local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_weapon_rainmaker/windrunner_spell_powershot_destruction_sparkles.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
-- 	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
-- 	-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
-- 	local pos = self.parent:GetAbsOrigin()
-- 	ParticleManager:SetParticleControl(pfx, 0, pos)
-- 	pos.z = pos.z +100
-- 	ParticleManager:SetParticleControl(pfx, 3, pos)
-- 	ParticleManager:ReleaseParticleIndex(pfx)

-- 	local damageTable = {
-- 		victim = keys.attacker,
-- 		attacker = self.parent,
-- 		-- attacker = self.caster,
-- 		damage = math.min(keys.damage,block)*0.3,
-- 		damage_type = DAMAGE_TYPE_PHYSICAL,
-- 		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
-- 		ability = self:GetAbility(), --Optional.
-- 	}
-- 	ApplyDamage(damageTable)
-- 	local particle_cast = "particles/rebuild/spell/body_of_effulgent_beryl_return/body_of_effulgent_beryl_return.vpcf"
-- 	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self.parent)
-- 	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
-- 	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.attacker:GetAbsOrigin(), true)
-- 	ParticleManager:ReleaseParticleIndex(particle_return_fx)

-- 	return block 
-- end


function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_Body_of_Effulgent_Beryl_unlock2_effect:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if not self.owner or self.owner:IsNull() or self.ability:IsNull() then
		self:SafeDestroy()
		return 0
	end
	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")
	block = block*1.2
	if CalculateDistance(self.owner,keys.attacker)>=600 then
		block = block * 3
	end
	block = math.max(block,self.parent:GetMaxHealth()*self.bonus_index )
	local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_weapon_rainmaker/windrunner_spell_powershot_destruction_sparkles.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	local pos = self.parent:GetAbsOrigin()
	ParticleManager:SetParticleControl(pfx, 0, pos)
	pos.z = pos.z +100
	ParticleManager:SetParticleControl(pfx, 3, pos)
	ParticleManager:ReleaseParticleIndex(pfx)

	local damageTable = {
		victim = keys.attacker,
		attacker = self.parent,
		-- attacker = self.caster,
		damage = math.min(keys.damage,block)*0.3,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	local particle_cast = "particles/rebuild/spell/body_of_effulgent_beryl_return/body_of_effulgent_beryl_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self.parent)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.attacker:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)

	return block 
end
