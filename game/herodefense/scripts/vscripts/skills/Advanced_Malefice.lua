--特效优化 √
Advanced_Malefice = class({})

LinkLuaModifier("modifier_Advanced_Malefice", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Malefice_illusion_stop", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Malefice_unlock2", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)
function Advanced_Malefice:GetCooldown(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enigma")
		if modifier then
			return 20 - modifier:GetSpecialValueFor("cd_reduce")
		end
		return 20
	end
end
function Advanced_Malefice:CheckKV(key)
	local table = {
		basic_damage = 4,
		intelligence_index = 0.04,
	}
	local value = table[key] or -1
	return value


end
function Advanced_Malefice:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_Malefice:UnlockSecondCore(key)
	local caster = self:GetCaster()
	if not caster:HasAbility("heroTalent_npc_dota_hero_enigma") then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	
	caster:AddNewModifier(caster,self,"modifier_Advanced_Malefice_unlock2",{})
	return true
end
function Advanced_Malefice:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	
	-- if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	-- self.totalcost = 0
	-- -- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fortunes_end_unlock3",{})
	-- _G.Fortunes_end_unlock3 = true
	return true

end
function Advanced_Malefice:IsHiddenWhenStolen() 		return false end
function Advanced_Malefice:IsRefreshable() 			return true  end
function Advanced_Malefice:IsStealable() 			return true  end
function Advanced_Malefice:IsNetherWardStealable() 	return true end
function Advanced_Malefice:SetPos(pos) 	
	self.pos = pos
end
function Advanced_Malefice:GetPos() 	
	return self.pos
end

function Advanced_Malefice:GetAOERadius() 
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_enigma") then
		return  self:GetSpecialValueFor("effect_radius")+200
	end
	return self:GetSpecialValueFor("effect_radius") 
end

function Advanced_Malefice:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("total_duration")
	if self.advanced_level>=15 then
		duration = duration *1.25
	end

	target:AddNewModifier(caster, self, "modifier_Advanced_Malefice", {duration = duration})
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enigma.Malefice", target)
	if self.unlock3 then
		local ability = caster:FindAbilityByName("Advanced_Midnight_Pulse")
		if ability then
			ability:MaleficeTrigger(target:GetOrigin())
		end
		local ability = caster:FindAbilityByName("Advanced_Black_Hole")
		if ability then
			ability:Malefice_Unlock3(target:GetOrigin())
		end
	end
end

modifier_Advanced_Malefice = advanced_modifier({})

function modifier_Advanced_Malefice:IsDebuff()			return true end
function modifier_Advanced_Malefice:IsHidden() 			return false end
function modifier_Advanced_Malefice:IsPurgable() 		return self.upgrade_on==true and false or true end
function modifier_Advanced_Malefice:IsPurgeException() 	return self.upgrade_on==true  and false or true end
function modifier_Advanced_Malefice:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_malefice.vpcf" end
function modifier_Advanced_Malefice:StatusEffectPriority() return 15 end
function modifier_Advanced_Malefice:GetAttributes() 
	if self.upgrade_on==true then
		return MODIFIER_ATTRIBUTE_MULTIPLE
	else
		return
	end
	
end

function modifier_Advanced_Malefice:GetEffectName() return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" end
function modifier_Advanced_Malefice:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Malefice:OnCreated()
	if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("effect_interval"))
		self:OnIntervalThink()
		self.upgrade_on = false
		--LV15解锁强化
		if self.advanced_level>=15 then
			self.upgrade_on  = true
		end
	end
end

function modifier_Advanced_Malefice:OnIntervalThink()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local ability_talent = caster:FindAbilityByName("heroTalent_npc_dota_hero_enigma")
	local radius = ability:GetSpecialValueFor("effect_radius")
	if ability_talent then
		radius = ability:GetSpecialValueFor("effect_radius") + ability_talent:GetSpecialValueFor("radius")
	end

	local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * (ability:GetSpecialValueFor( "intelligence_index" ))
	local damage_type = ability:GetAbilityDamageType()
	if ability_talent then
		damage = (ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * ability:GetSpecialValueFor( "intelligence_index" ))*(1+ability_talent:GetSpecialValueFor("damage")*0.01)
	end
	local black_hole_duration =  ability:GetSpecialValueFor("black_hole_duration")
	--LV5解锁奇点+
	if self.advanced_level>=5 then
		black_hole_duration = 2
	end
	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = black_hole_duration}, self:GetParent():GetAbsOrigin(), caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, ability, "modifier_Advanced_Malefice_black_hole_thinker", {duration = black_hole_duration})
	target:EmitSound("Hero_Terrorblade.Reflection")
	local modifierKeys = {}
	-- modifierKeys.outgoing_damage = -100
	-- modifierKeys.incoming_damage = 0
	modifierKeys.duration = ability:GetSpecialValueFor("illusion_duration")
	if self.advanced_level>=20 then
		modifierKeys.duration = modifierKeys.duration *2
	end
	if caster:IsHero() then
		-- local illusion = CreateIllusions( caster, caster, modifierKeys, 1, 20, true, true)
		-- illusion[1]:SetControllableByPlayer(-1, true)	
		local illusion =  caster:MakeCustomIllusion()
		illusion:AddNewModifier(caster, ability, "modifier_Advanced_Malefice_illusion", {duration = modifierKeys.duration,target = target:entindex()})
	end

	for i=1, #enemy do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = enemy[i]:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
		enemy[i]:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")*StatusResistance})
		local damageTable = {
							victim = enemy[i],
							attacker = caster,
							damage = damage,
							damage_type = damage_type,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		if not target:IsAlive() and not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
		enemy[i]:EmitSound("Hero_Enigma.MaleficeTick")	
	end
	local hole_pfx = "particles/rebuild/spell/malefice/active.vpcf"
	local pos = self:GetParent():GetAbsOrigin()
	self.pos = pos
	self:GetAbility():SetPos(pos)
	pos.z = pos.z + 100
	local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	self:AddParticle(pfx, false, false, 15, false, false)
end
function modifier_Advanced_Malefice:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Advanced_Malefice:OnDeath(keys)
	if IsServer() then
		if not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
	end
end




LinkLuaModifier("modifier_Advanced_Malefice_black_hole_thinker", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Malefice_black_hole_out_pull", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Malefice_black_hole_aura", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)


modifier_Advanced_Malefice_black_hole_thinker = class({})
function modifier_Advanced_Malefice_black_hole_thinker:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
		local hole_pfx = "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf"
		self:GetParent():EmitSound("Imba.EnigmaBlackHoleTobi0"..math.random(1, 5))
		self:SetStackCount(1)
		local pos = self:GetParent():GetAbsOrigin()
		self.pos = pos
		ability:SetPos(pos)
		pos.z = pos.z + 100
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		self:AddParticle(pfx, false, false, 15, false, false)
		self.advanced_level = ability.advanced_level
		self.out_distance = ability:GetSpecialValueFor("base_pull_distance") 
		--LV5解锁奇点+
		if self.advanced_level>=5 then
			self.out_distance = self.out_distance+200
		end
		if ability.unlock1 then
			-- self.unlock1 = true
			local ability = self:GetCaster():FindAbilityByName("Advanced_Black_Hole")
			self.out_distance = self.out_distance +200
			if ability then
				self.dmg = (ability:GetSpecialValueFor("basic_damage") +ability:GetSpecialValueFor("intelligence_index")*self:GetCaster():GetIntellect(false))/ (1.0 / 0.5)
				self:StartIntervalThink(0.5)
			end
			

		end
		-- self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_Malefice_black_hole_thinker:OnIntervalThink()
	-- if self.unlock1 then
		
	-- end
	local enemies2 = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.out_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	-- for i=1, #enemies2 do
	-- 	if not enemies2[i]:HasModifier("modifier_Advanced_Malefice_black_hole_aura") then
	-- 		enemies2[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Malefice_black_hole_out_pull", {})
	-- 	end
	-- end
	local caster = self:GetCaster()
	local damageTable = {
		-- victim = enemies2[i],
		attacker = caster,
		damage = self.dmg*0.2,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		}
	for i=1, #enemies2 do
		damageTable.victim = enemies2[i]
		ApplyDamage(damageTable)
	end
end

function modifier_Advanced_Malefice_black_hole_thinker:IsAura() return true end
function modifier_Advanced_Malefice_black_hole_thinker:GetAuraDuration() return 0.1 end
function modifier_Advanced_Malefice_black_hole_thinker:GetModifierAura() return "modifier_Advanced_Malefice_black_hole_aura" end
function modifier_Advanced_Malefice_black_hole_thinker:GetAuraRadius() return self.out_distance end
function modifier_Advanced_Malefice_black_hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Advanced_Malefice_black_hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Malefice_black_hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Malefice_black_hole_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		-- self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		-- self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		UTIL_Remove(self:GetParent())
	end
end

modifier_Advanced_Malefice_black_hole_aura = class({})

function modifier_Advanced_Malefice_black_hole_aura:IsDebuff()			return true end
function modifier_Advanced_Malefice_black_hole_aura:IsHidden() 			return true end
function modifier_Advanced_Malefice_black_hole_aura:IsPurgable() 			return false end
function modifier_Advanced_Malefice_black_hole_aura:IsPurgeException() 	return false end
function modifier_Advanced_Malefice_black_hole_aura:IsStunDebuff()		return true end

function modifier_Advanced_Malefice_black_hole_aura:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_Malefice_black_hole_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Advanced_Malefice_black_hole_aura:IsMotionController() return true end
function modifier_Advanced_Malefice_black_hole_aura:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_Malefice_black_hole_aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.pos = self:GetAbility():GetPos()
	end
end

function modifier_Advanced_Malefice_black_hole_aura:OnDestroy()
	if IsServer()then
		-- if IsServer() and not self:GetParent():HasModifier("modifier_Advanced_Malefice_black_hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

function modifier_Advanced_Malefice_black_hole_aura:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	if self.pos == nil then
		return
	end
	local pos = self.pos
	-- local pos = self:GetParent():GetAbsOrigin()
	local distance = (self:GetParent():GetAbsOrigin() - pos):Length2D()
	local in_pull = 25
	local new_pos = GetGroundPosition(RotatePosition(pos, QAngle(0,1.5,0), self:GetParent():GetAbsOrigin()), self:GetParent())
	if true then
		local direction = (pos - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
	end
	self:GetParent():SetOrigin(new_pos)
end



modifier_Advanced_Malefice_black_hole_out_pull = class({})

function modifier_Advanced_Malefice_black_hole_out_pull:IsDebuff()			return false end
function modifier_Advanced_Malefice_black_hole_out_pull:IsHidden() 			return true end
function modifier_Advanced_Malefice_black_hole_out_pull:IsPurgable() 			return false end
function modifier_Advanced_Malefice_black_hole_out_pull:IsPurgeException() 	return false end
function modifier_Advanced_Malefice_black_hole_out_pull:IsMotionController() return true end
function modifier_Advanced_Malefice_black_hole_out_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Advanced_Malefice_black_hole_out_pull:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Malefice_black_hole_out_pull:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_Advanced_Malefice_black_hole_aura") then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local out_distance = self:GetAbility():GetSpecialValueFor("pull_distance") 
	if not ability:IsChanneling() or (self:GetParent():GetAbsOrigin() - ability.pos):Length2D() > out_distance or self:GetParent():IsBoss() then
		self:SafeDestroy()
	end
	local out_pull = ability:GetSpecialValueFor("pull_speed")

	local direction = (ability.pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local new_pos = self:GetParent():GetAbsOrigin() + direction * (out_pull / (1.0 / FrameTime()))
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Advanced_Malefice_black_hole_out_pull:OnDestroy()
	if IsServer()then
		-- if IsServer() and not self:GetParent():HasModifier("modifier_Advanced_Malefice_black_hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

LinkLuaModifier("modifier_Advanced_Malefice_illusion", "skills/Advanced_Malefice", LUA_MODIFIER_MOTION_NONE)

modifier_Advanced_Malefice_illusion = advanced_modifier({})

function modifier_Advanced_Malefice_illusion:IsDebuff()			return false end
function modifier_Advanced_Malefice_illusion:IsHidden() 			return false end
function modifier_Advanced_Malefice_illusion:IsPurgable() 		return false end
function modifier_Advanced_Malefice_illusion:IsPurgeException() 	return false end
function modifier_Advanced_Malefice_illusion:CheckState() return 
	{[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
-- function modifier_Advanced_Malefice_illusion:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,} end
function modifier_Advanced_Malefice_illusion:GetModifierMoveSpeedBonus_Constant() return 1000 end
function modifier_Advanced_Malefice_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_terrorblade_reflection.vpcf" end
function modifier_Advanced_Malefice_illusion:StatusEffectPriority() return 15 end

function modifier_Advanced_Malefice_illusion:OnCreated(keys)
	if IsServer() then
		local target = EntIndexToHScript(keys.target)
		self:GetParent():SetForceAttackTarget(target)
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.advanced_level = ability.advanced_level
		self.damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * (ability:GetSpecialValueFor( "intelligence_index" ))
	
		--LV10解锁失实+
		if self.advanced_level>=10 then
			self.damage = self.damage*0.75
		else
			self.damage = self.damage *0.5
		end
	end
end

function modifier_Advanced_Malefice_illusion:OnDestroy()
	if IsServer() then
		-- self:GetParent():SetForceAttackTarget(nil)
		local parent = self:GetParent()
		UTIL_Remove( parent )
	end
end

function modifier_Advanced_Malefice_illusion:DeclareFunctions()
	return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_Advanced_Malefice_illusion:GetModifierAttackSpeedBaseOverride(keys)
	return self:GetCaster():GetAttackSpeed(false)
end


function modifier_Advanced_Malefice_illusion:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	local caster = ability:GetCaster()

	local damage_type = ability:GetAbilityDamageType()
	target:EmitSound("Hero_Terrorblade.Reflection")
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
		}
	 ApplyDamage(damageTable)
	 self:GetParent():AddNewModifier(caster, ability, "modifier_Advanced_Malefice_illusion_stop", {duration = 0.5})
end



modifier_Advanced_Malefice_illusion_stop = class({})

function modifier_Advanced_Malefice_illusion_stop:IsDebuff()			return false end
function modifier_Advanced_Malefice_illusion_stop:IsHidden() 			return false end
function modifier_Advanced_Malefice_illusion_stop:IsPurgable() 		return false end
function modifier_Advanced_Malefice_illusion_stop:IsPurgeException() 	return false end
function modifier_Advanced_Malefice_illusion_stop:CheckState() return  {[MODIFIER_STATE_DISARMED] = true,} end










modifier_Advanced_Malefice_unlock2 = class({})

function modifier_Advanced_Malefice_unlock2:IsHidden()	return true end
function modifier_Advanced_Malefice_unlock2:IsDebuff()	return false end
function modifier_Advanced_Malefice_unlock2:IsPurgable()	return false end
function modifier_Advanced_Malefice_unlock2:IsPurgeException() return false end
function modifier_Advanced_Malefice_unlock2:RemoveOnDeath() return false end
