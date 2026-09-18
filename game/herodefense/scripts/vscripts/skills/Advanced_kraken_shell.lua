--特效优化 √

Advanced_kraken_shell = class({})
-- LinkLuaModifier("modifier_Advanced_kraken_shell_arua", "items/Advanced_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_kraken_shell_arua_effect", "skills/Advanced_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_kraken_shell", "skills/Advanced_kraken_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_kraken_shell_active", "skills/Advanced_kraken_shell", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_kraken_shell_unlock1", "skills/Advanced_kraken_shell", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function Advanced_kraken_shell:GetIntrinsicModifierName()
	return "modifier_Advanced_kraken_shell"
end
function Advanced_kraken_shell:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_kraken_shell_unlock1",{})
	return true
end
function Advanced_kraken_shell:UnlockSecondCore(key)
	return true
end
function Advanced_kraken_shell:UnlockThirdCore(key)
	return true
end

function Advanced_kraken_shell:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/kraken_shell/unlock1.vpcf", context )
end


function Advanced_kraken_shell:CheckKV(key)
	local table = {

		damage_block = 2,
		bonus_block = 0.01,
		purge_damage = -0.1,


	}
	if self:GetUnlock(2)==2 then
		table.damage_block = 8
		table.bonus_block = 0.044
		table.purge_damage = -0.24
	end
	local value = table[key] or -1
	return value

end


modifier_Advanced_kraken_shell = advanced_modifier({})

function modifier_Advanced_kraken_shell:IsDebuff() return false end
function modifier_Advanced_kraken_shell:IsHidden() return false end

function modifier_Advanced_kraken_shell:IsPurgable() 		return false end
function modifier_Advanced_kraken_shell:IsPurgeException() 	return false end
function modifier_Advanced_kraken_shell:RemoveOnDeath()  return false end
function modifier_Advanced_kraken_shell:IsAura() return true end
function modifier_Advanced_kraken_shell:GetAuraDuration() return 0.5 end
function modifier_Advanced_kraken_shell:GetModifierAura() return "modifier_Advanced_kraken_shell_arua_effect" end
function modifier_Advanced_kraken_shell:GetAuraRadius() return 1500 end
function modifier_Advanced_kraken_shell:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_kraken_shell:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_kraken_shell:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_kraken_shell:GetAuraEntityReject(hEntity)

	if hEntity == self:GetParent() then
		return true
	end
	return false
end

function modifier_Advanced_kraken_shell:OnCreated(table)
	self.bonus_status_resistance = 0
	if IsClient() then
		return
	end
	self.ability = self:GetAbility()

	self.advanced_level = 1
	self:StartIntervalThink(0.5)

end

function modifier_Advanced_kraken_shell:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_Advanced_kraken_shell:OnIntervalThink(table)
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		self.bonus_status_resistance = 35
		self:StartIntervalThink(-1)
	end

	
end


function modifier_Advanced_kraken_shell:OnTakeDamage(keys)
	if IsServer() then

		local parent = self:GetParent()
		if keys.unit==parent then
			
			self.advanced_level = self:GetAbility().advanced_level
			self:SetStackCount(self:GetStackCount()+keys.damage)
			if self:GetStackCount()>=parent:GetMaxHealth()*(self.ability:GetSpecialValueFor("purge_damage"))*0.01 then
				parent:Purge(false, true, false, false, true) --强驱散
				local ModifierStatusGain =  parent:GetModifierDurationGainIndex(1)
				local duration = 4
				--LV5解锁强抵挡+
				if self.advanced_level>=5 then
					duration = 6
				end
				parent:AddNewModifier(parent, self.ability, "modifier_Advanced_kraken_shell_active", {duration = duration*ModifierStatusGain})

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_POINT_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				parent:EmitSound("Hero_Tidehunter.KrakenShell")
				self:SetStackCount(0)

				--LV15海妖触手
				if self.advanced_level>=15  then
	

					parent:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
					--伤害
					local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 500,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
	   					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

					local damagetable= {
						attacker = parent,
						damage = parent:GetStrength()*2,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self.ability,
					}
					if self.ability.unlock2 then
						damagetable.damage = damagetable.damage*2.5
					end
			
		   			for i, unit in pairs(units) do
						local particle = ParticleManager:CreateParticle("particles/econ/items/tidehunter/tide_2021_immortal/tide_2021_ravage_hit.vpcf", PATTACH_POINT_FOLLOW, unit)
						ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(particle)

						damagetable.victim =unit
						ApplyDamage(damagetable)
						if i>=3 then
							break
						end


		   		end



		end
				
			end
		end
		
	end
end





function modifier_Advanced_kraken_shell:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
end
function modifier_Advanced_kraken_shell:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end
	local parent = self:GetParent()
	if parent:PassivesDisabled() then
		if not parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") then
			return
		end
	end
	
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

	self.advanced_level = self:GetAbility().advanced_level
	local block = parent:GetStrength()*(self.ability:GetSpecialValueFor("bonus_block"))+self.ability:GetSpecialValueFor("damage_block")
	if parent:HasModifier("modifier_Advanced_kraken_shell_active") then
		block = block *2
	end

	if parent:HasModifier("modifier_heroTalent_npc_dota_hero_tidehunter_2") and parent:HasModifier("modifier_generic_water_zoom_buff") then
		block = math.min(block*1.7,keys.damage)
	else
		block = math.min(block,keys.damage*0.95)
	end
	return block 
end



function modifier_Advanced_kraken_shell:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


modifier_Advanced_kraken_shell_active = class({})

function modifier_Advanced_kraken_shell_active:IsDebuff() return false end
function modifier_Advanced_kraken_shell_active:IsHidden() return false end
function modifier_Advanced_kraken_shell_active:IsPurgable() return false end















modifier_Advanced_kraken_shell_arua_effect = advanced_modifier({})

function modifier_Advanced_kraken_shell_arua_effect:IsDebuff() return false end
function modifier_Advanced_kraken_shell_arua_effect:IsHidden() return false end
function modifier_Advanced_kraken_shell_arua_effect:IsPurgable() return false end


function modifier_Advanced_kraken_shell_arua_effect:OnCreated(table)
	self.ability = self:GetAbility()

	self.caster = self:GetCaster()
end



function modifier_Advanced_kraken_shell_arua_effect:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_kraken_shell_arua_effect:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
	local parent = self:GetParent()
	if self.caster:PassivesDisabled() then
		return
	end

	self.advanced_level = self:GetAbility().advanced_level
	local block = self.caster:GetStrength()*(self.ability:GetSpecialValueFor("bonus_block"))+self.ability:GetSpecialValueFor("damage_block")
	--LV10解锁领域格挡+
	if self.advanced_level>=10 then
		block = block *0.75
	else
		block = block *0.5
	end

	if self.caster:HasModifier("modifier_Advanced_kraken_shell_arua_effect_active") then
		block = block *2
	end
	local modifier = self.caster:FindModifierByName("modifier_Advanced_kraken_shell")
	if modifier then
		local block_damage = math.min(keys.damage,block)
		modifier:SetStackCount(modifier:GetStackCount()+block_damage*0.3)
		if modifier:GetStackCount()>=self.caster:GetMaxHealth()*self.ability:GetSpecialValueFor("purge_damage")*0.01 then
			self.caster:Purge(false, true, false, false, true) --强驱散
			local ModifierStatusGain = self.caster:GetModifierDurationGainIndex(1)
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_Advanced_kraken_shell_active", {duration = 4*ModifierStatusGain})

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_POINT_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			self.caster:EmitSound("Hero_Tidehunter.KrakenShell")
			modifier:SetStackCount(0)


			--LV15海妖触手
			if self.advanced_level>=15  then
	

					self.caster:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
					--伤害
					local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 500,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
	   					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

					local damagetable= 
					{
						attacker = self.caster,
						damage = self.caster:GetStrength()*2,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self.ability,
					}
					if self.ability.unlock2 then
						damagetable.damage = damagetable.damage*2.5
					end
			
		   			for i, unit in pairs(units) do
						local particle = ParticleManager:CreateParticle("particles/econ/items/tidehunter/tide_2021_immortal/tide_2021_ravage_hit.vpcf", PATTACH_POINT_FOLLOW, unit)
						ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(particle)

						damagetable.victim =unit
						ApplyDamage(damagetable)
						if i>=3 then
							break
						end


		   		end
			end







		end
	end
	if self.ability.unlock3 then
		if keys.damage>=block and not self:GetCaster():IsInvulnerable() then
			local ex_damage =  keys.damage - block
			local damageTable = {

				attacker =keys.attacker,
				victim = self:GetCaster(),
				damage =ex_damage*0.3,
				damage_type = keys.damage_type,
				ability = self:GetAbility(), 
				damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS,
			}
			ApplyDamage(damageTable)
		end
		return keys.damage
	end
	block = math.min(block,keys.damage*0.95)
	return block
end







modifier_Advanced_kraken_shell_unlock1 = class({})

function modifier_Advanced_kraken_shell_unlock1:IsDebuff()			return false end
function modifier_Advanced_kraken_shell_unlock1:IsHidden() 			return true end
function modifier_Advanced_kraken_shell_unlock1:IsPurgable() 		return false end
function modifier_Advanced_kraken_shell_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_kraken_shell_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_kraken_shell_unlock1:OnCreated(keys)
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/kraken_shell/unlock1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_kraken_shell_unlock1:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	end
end
function modifier_Advanced_kraken_shell_unlock1:OnIntervalThink()
	self:GetParent():Purge(false, true, false, false, true)
end

function modifier_Advanced_kraken_shell_unlock1:GetPriority()
	return 10
end

function modifier_Advanced_kraken_shell_unlock1:CheckState()
    local state = 
	{
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
	

	return state
end