
LinkLuaModifier( "modifier_Advanced_summon_water_element_buff", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_water_element_buff2", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_water_element_buff3", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_water_element_buff4", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_water_element_Waveform_motion", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_Advanced_summon_water_element_buff_unlock3", "skills/Advanced_summon_water_element", LUA_MODIFIER_MOTION_NONE )
Advanced_summon_water_element						= Advanced_summon_water_element or class({})
require("internal/timers")

function Advanced_summon_water_element:IsSummonSpell()return true end

function Advanced_summon_water_element:IsElementSummon()return true end

function Advanced_summon_water_element:Precache( context )
	PrecacheResource( "model", "models/items/morphling/armor_of_pure_absorption_shoulder/armor_of_pure_absorption_shoulder.vmdl", context )
	PrecacheResource( "model", "models/items/morphling/armor_of_pure_absorption_misc/armor_of_pure_absorption_misc.vmdl", context )
	PrecacheResource( "model", "models/items/morphling/armor_of_pure_absorption_head/armor_of_pure_absorption_head.vmdl", context )
	PrecacheResource( "model", "models/items/morphling/armor_of_pure_absorption_back/armor_of_pure_absorption_back.vmdl", context )
	PrecacheResource( "model", "models/items/morphling/armor_of_pure_absorption_arms/armor_of_pure_absorption_arms.vmdl", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_water_element/unlock3/effect.vpcf", context )
end
function Advanced_summon_water_element:CheckKV(key)
	local table = {
		bonus_damage=1.5,
		bonus_health=1.5,



	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_water_element:UnlockFirstCore(key)
	return true
end
function Advanced_summon_water_element:UnlockSecondCore(key)
	return true
end
function Advanced_summon_water_element:UnlockThirdCore(key)
	return true
end
function Advanced_summon_water_element:OnSpellStart()

	
	local caster =self:GetCaster()


	
	



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	-- Add spawn particles in spawn location
	EmitSoundOn("Hero_Morphling.Waveform", caster)	
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
	for i = 1, 10, 1 do
		local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, new_pos)
		ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
		Timers(1.3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex( pfx )
		end)	

	end
	
	local ability = self
	Timers(1.0, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_water_element",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff", {})
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff2", {})
		if self.advanced_level>=15 then
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff3", {})
			if self.advanced_level>=20 then
				unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff4", {})
			end
		end
		if self.unlock3 then
			local summon_intensity_gain = caster:GetSummonIntensityIndex(1.2)
	
			local new_health = heal*summon_intensity_gain
			local new_armor = armor*summon_intensity_gain
			local new_damage = damage * summon_intensity_gain
			unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff_unlock3", {health=new_health,damage=new_damage,armor=new_armor})
			
		end
	end)




end


function Advanced_summon_water_element:CreateHighElement(pos,health,damage,armor)
	local caster =self:GetCaster()
	local life_duration = self:GetSpecialValueFor("duration") 
	local unit_pos = pos
	-- Add spawn particles in spawn location
	EmitSoundOn("Hero_Morphling.Waveform", caster)	
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
	for i = 1, 10, 1 do
		local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, new_pos)
		ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
		Timers(1.3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex( pfx )
		end)	

	end
	
	local ability = self
	Timers(1.0, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_water_element_advanced",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,health,nil,damage,armor,1,1)
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff", {})
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff2", {})
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff3", {})
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_water_element_buff4", {})

	end)


end


modifier_Advanced_summon_water_element_buff= class({})

function modifier_Advanced_summon_water_element_buff:IsDebuff()			return false end
function modifier_Advanced_summon_water_element_buff:IsHidden() 			return false end
function modifier_Advanced_summon_water_element_buff:IsPurgable() 		return false end
function modifier_Advanced_summon_water_element_buff:IsPurgeException() 	return false end

function modifier_Advanced_summon_water_element_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(3)
		self.health = 10
		if self:GetAbility().advanced_level>=5 then
			self:SetStackCount(5)
			if self:GetAbility().unlock2 then
				self:SetStackCount(20)
				self.health = 20
			end
			
		end
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_summon_water_element_buff:OnIntervalThink()
	local ability = self:GetAbility()

	local parent = self:GetParent()
	if parent:GetHealthPercent()<=self.health then
		local heal = parent:GetMaxHealth()*0.4
		if ability.unlock2 then
			heal = parent:GetMaxHealth()*0.6
		end
		
		local healing = HealWithGain(heal,self:GetCaster(),parent,ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		self:DecrementStackCount()
		EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Target", parent)	
		local attachment = parent:ScriptLookupAttachment( "attach_attack1" )
		local info = 
							{
							Target = parent,
							Source = parent,
							Ability = ability,
							EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
							iMoveSpeed = 1000,
							vSourceLoc = parent:GetAttachmentOrigin(attachment),
							bDodgeable = false,
							bProvidesVision = false,
							flExpireTime = GameRules:GetGameTime() + 4,
							}

						ProjectileManager:CreateTrackingProjectile( info )
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end
















modifier_Advanced_summon_water_element_buff2= class({})

function modifier_Advanced_summon_water_element_buff2:IsDebuff()			return false end
function modifier_Advanced_summon_water_element_buff2:IsHidden() 			return false end
function modifier_Advanced_summon_water_element_buff2:IsPurgable() 		return false end
function modifier_Advanced_summon_water_element_buff2:IsPurgeException() 	return false end

function modifier_Advanced_summon_water_element_buff2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.parent = self:GetParent()
		self.prevLoc = self.parent:GetAbsOrigin()
		self.max_stack = 200
		if self:GetAbility().advanced_level>=10 then
			self.max_stack = 350
		end
        self.move_dis = 0
		
	end
end

function modifier_Advanced_summon_water_element_buff2:OnIntervalThink()
	
	local dis = CalculateDistance(self.prevLoc, self.parent)
	self.move_dis = self.move_dis + dis
	if self.move_dis >=100 then
		self.move_dis  = 0
		local heal = self.parent:GetMaxHealth()*0.05
		local healing = HealWithGain(heal,self:GetCaster(),self.parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, healing, nil)
		self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stack))

	end
	self.prevLoc = self:GetParent():GetAbsOrigin()
end



function modifier_Advanced_summon_water_element_buff2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比

	}
end


function modifier_Advanced_summon_water_element_buff2:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount() end

















modifier_Advanced_summon_water_element_buff3= class({})

function modifier_Advanced_summon_water_element_buff3:IsDebuff()			return false end
function modifier_Advanced_summon_water_element_buff3:IsHidden() 			return true end
function modifier_Advanced_summon_water_element_buff3:IsPurgable() 		return false end
function modifier_Advanced_summon_water_element_buff3:IsPurgeException() 	return false end
function modifier_Advanced_summon_water_element_buff3:OnCreated(keys)
	if IsServer() then
		self.chance = 50
		if self:GetAbility().unlock1 then
			self.chance = 80
		end
	end
end
function modifier_Advanced_summon_water_element_buff3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,

	}
end


function modifier_Advanced_summon_water_element_buff3:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.attacker==parent and self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,1) >=RandomInt(1, 100) then
			local ability = self:GetAbility()
			if not ability then
				return
			end
			local caster_pos = parent:GetAbsOrigin()
			local target_pos = keys.target:GetAbsOrigin()
			local direction = (target_pos - caster_pos):Normalized()
			direction.z = 0.0
			local range = CalculateDistance(parent,keys.target)+400
			local speed = 3000
			local attack_range = parent:Script_GetAttackRange()
			--lock1 则range为攻击距离
			if ability.unlock1 then
				range = CalculateDistance(parent,keys.target)+attack_range
			end
			local pos = caster_pos + direction * range
			local duration = (caster_pos - pos):Length2D() / speed
			parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_water_element_Waveform_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
			parent:EmitSound("Hero_Morphling.Waveform")
		end
	end


end








modifier_water_element_Waveform_motion = class({})

function modifier_water_element_Waveform_motion:IsDebuff()			return false end
function modifier_water_element_Waveform_motion:IsHidden() 			return true end
function modifier_water_element_Waveform_motion:IsPurgable() 		return false end
function modifier_water_element_Waveform_motion:IsPurgeException() 	return false end
function modifier_water_element_Waveform_motion:IsStunDebuff()		return true end
--状态无敌
function modifier_water_element_Waveform_motion:CheckState() 
	return 
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true ,
		[MODIFIER_STATE_INVULNERABLE] = true ,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	} 
end

function modifier_water_element_Waveform_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_water_element_Waveform_motion:GetModifierDisableTurning() return 1 end
function modifier_water_element_Waveform_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_water_element_Waveform_motion:IsMotionController() return true end
function modifier_water_element_Waveform_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_water_element_Waveform_motion:OnCreated(keys)
	if IsServer() then
		self.hitted = {}

		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed = 3000
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self:GetParent():GetAverageTrueAttackDamage(nil)*0.07,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		if self:GetAbility().unlock1 then
			self.damageTable.damage = self.damageTable.damage * 5
		end
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())

			local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
			--local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
			local pfx_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetUpVector() * 50
			ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
			ParticleManager:SetParticleControl(self.pfx, 1, (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.speed)
			self:AddParticle(self.pfx, false, false, 15, false, false)
------------------------------------------------------------------------------------------------------------------------------------------
		else
			self:SafeDestroy()
		end
	end
end

function modifier_water_element_Waveform_motion:OnIntervalThink()
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	local width = 200
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	--local enemies = FindUnitsInRadius(

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
		nil, width,
		 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  DOTA_UNIT_TARGET_FLAG_NONE,
		   FIND_ANY_ORDER, false)


	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			if not enemy:IsMagicImmune() then 
				--造成伤害
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				table.insert(self.hitted,enemy)
			end
		end
	end
end

function modifier_water_element_Waveform_motion:OnDestroy() 
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.hitted = nil
		self.pos = nil
		self.speed = nil
		self:GetParent():SetForwardVector(Vector(self:GetParent():GetForwardVector()[1], self:GetParent():GetForwardVector()[2], 0))
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

	end
end


















modifier_Advanced_summon_water_element_buff4= class({})

function modifier_Advanced_summon_water_element_buff4:IsDebuff()			return false end
function modifier_Advanced_summon_water_element_buff4:IsHidden() 			return false end
function modifier_Advanced_summon_water_element_buff4:IsPurgable() 		return false end
function modifier_Advanced_summon_water_element_buff4:IsPurgeException() 	return false end




function modifier_Advanced_summon_water_element_buff4:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end

function modifier_Advanced_summon_water_element_buff4:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount()*5 end
function modifier_Advanced_summon_water_element_buff4:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.attacker==parent then
			local selfHealth = parent:GetHealthPercent()
			if selfHealth>=100 or selfHealth<=keys.target:GetHealthPercent() then
				self:SetStackCount(math.min(self:GetStackCount()+1, 80))
			end
		end
	end


end






modifier_Advanced_summon_water_element_buff_unlock3= class({})

function modifier_Advanced_summon_water_element_buff_unlock3:IsDebuff()			return false end
function modifier_Advanced_summon_water_element_buff_unlock3:IsHidden() 			return false end
function modifier_Advanced_summon_water_element_buff_unlock3:IsPurgable() 		return false end
function modifier_Advanced_summon_water_element_buff_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_summon_water_element_buff_unlock3:OnCreated(keys)
	if IsServer() then
		self.health = keys.health
		self.armor = keys.armor
		self.damage = keys.damage
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_summon_water_element_buff_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), nil, 800,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		if unit:IsRealHero() then
			local mana_regen = unit:GetMaxMana()*0.01
			if mana_regen>0 then
				local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/summon_water_element/unlock3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex(nFXIndex)
				unit:Script_ReduceMana(mana_regen,self:GetAbility())
				self:SetStackCount(self:GetStackCount()+mana_regen)
			end
		
		end
	end

	if self:GetStackCount()>=(self:GetCaster():GetMaxMana()*0.2+1000) then
		self:GetAbility():CreateHighElement(parent:GetOrigin(),self.health,self.damage,self.armor)
		TrueKill(parent, parent, self:GetAbility())
		-- self:SafeDestroy()
	end
	
end

