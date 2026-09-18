--CreateEmptyTalents("axe")
--特效优化 √
Advanced_Berserkers_Call = class({})
LinkLuaModifier("modifier_Advanced_Berserkers_Call_as", "skills/Advanced_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Berserkers_Call_armor", "skills/Advanced_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Berserkers_Call_unlock3", "skills/Advanced_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
-- modifier_Advanced_Berserkers_Call
require('internal/timers')   --计时器功能
function Advanced_Berserkers_Call:IsRefreshable() return false end
function Advanced_Berserkers_Call:CheckKV(key)
	local table = {
		radius = 20,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Berserkers_Call:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Battle_Hunger_unlock3",{})
	return true
end
function Advanced_Berserkers_Call:UnlockSecondCore(key)
	-- self.CoreUnlock = false
	return true
end
function Advanced_Berserkers_Call:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Berserkers_Call_unlock3",{})
	return true
end
function Advanced_Berserkers_Call:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end

	return self.BaseClass.GetBehavior(self)
	
end


function Advanced_Berserkers_Call:IsHiddenWhenStolen() 		return false end
function Advanced_Berserkers_Call:IsStealable() 			return true end
function Advanced_Berserkers_Call:IsNetherWardStealable() 	return true end

function Advanced_Berserkers_Call:GetCastRange(vLocation, hTarget) 

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	return  self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Advanced_Berserkers_Call:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Axe.BerserkersCall.Start")
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	return true
end

function Advanced_Berserkers_Call:OnAbilityPhaseInterrupted() self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1) end

function Advanced_Berserkers_Call:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Axe.Berserkers_Call")
	local level = self.advanced_level  
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_Advanced_Berserkers_Call_armor", {duration = duration})
	local radius = self:GetSpecialValueFor("radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)

	if self.unlock1 then
		local ability = caster:FindAbilityByName("Advanced_Battle_Hunger")
		if ability then
			for i, enemy in pairs(enemies) do
				-- enemy:AddNewModifier(caster, self, "modifier_Advanced_Berserkers_Call", {duration = self:GetSpecialValueFor("duration")})
				enemy:AddNewModifier(caster, self, "modifier_Advanced_Berserkers_Call_as", {duration = duration})
				if i<=7 then
					ability:AddDebuff(enemy)
				end

			end
			local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"
		
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")))
			ParticleManager:SetParticleControl(pfx, 2, Vector(radius, radius, radius))
			ParticleManager:ReleaseParticleIndex(pfx)
			return
		end
	end
	if self.unlock3 then
		duration = 1
	end
	for _, enemy in pairs(enemies) do
		-- enemy:AddNewModifier(caster, self, "modifier_Advanced_Berserkers_Call", {duration = self:GetSpecialValueFor("duration")})
		if not enemy:ImmuneForceAttack() then
			enemy:AddNewModifier(caster, self, "modifier_Advanced_Berserkers_Call_as", {duration = duration})
		end
		
	end
	local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")))
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(pfx)
end
MUSIC={
	"teamfandom.2.8204512.140239",
	"teamfandom.2.7407260.140175"
}

function Advanced_Berserkers_Call:EndAbility()
	local caster = self:GetCaster()
	caster:EmitSound(MUSIC[RandomInt(1, 2)])
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									self:GetSpecialValueFor("radius"),
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
	for _, enemy in pairs(enemies) do
		local buffs = enemy:FindAllModifiersByName("modifier_Advanced_Berserkers_Call_as")
		if  #buffs ~= 0 then
			buffs[1]:SafeDestroy()
		end

	end

end



modifier_Advanced_Berserkers_Call_as = advanced_modifier({})

function modifier_Advanced_Berserkers_Call_as:IsDebuff()				return true end
function modifier_Advanced_Berserkers_Call_as:IsHidden() 			return true end
function modifier_Advanced_Berserkers_Call_as:IsPurgable() 			return true end
function modifier_Advanced_Berserkers_Call_as:IsPurgeException() 	return true end
function modifier_Advanced_Berserkers_Call_as:CheckState() 
	if self:GetAbility():GetUnlock(3)==3 then
		return
	end
	return {[MODIFIER_STATE_TAUNTED]=true} 
end
function modifier_Advanced_Berserkers_Call_as:StatusEffectPriority(  )
	return 10
end
function modifier_Advanced_Berserkers_Call_as:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end
	return funcs
end

function modifier_Advanced_Berserkers_Call_as:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end
function modifier_Advanced_Berserkers_Call_as:GetModifierMagicalResistanceBonus() return -35 end

function modifier_Advanced_Berserkers_Call_as:OnCreated( kv )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) 
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
	--LV20解锁猝死
	local level = self:GetAbility().advanced_level
	if level>=20 then
		self.parent = self:GetParent()
		self.limit_health = self:GetCaster():GetStrength()*7
		if self:GetAbility().unlock2 then
			self.limit_health = math.max(self.limit_health,self:GetParent():GetMaxHealth()*0.13)
		end
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Berserkers_Call_as:OnIntervalThink( kv )
	if not IsServer() then
		return
	end
	if self.parent:GetHealth()<=self.limit_health then
		TrueKill(self:GetCaster(), self.parent, self:GetAbility())
	end
end


function modifier_Advanced_Berserkers_Call_as:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end

function modifier_Advanced_Berserkers_Call_as:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end

function modifier_Advanced_Berserkers_Call_as:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
	end
    return funcs
end
function modifier_Advanced_Berserkers_Call_as:Advanced_GetModifierPhysicalArmorBonus()
    return -20
end


modifier_Advanced_Berserkers_Call_armor = advanced_modifier({})

function modifier_Advanced_Berserkers_Call_armor:IsDebuff()				return false end
function modifier_Advanced_Berserkers_Call_armor:IsHidden() 			return false end
function modifier_Advanced_Berserkers_Call_armor:IsPurgable() 			return false end
function modifier_Advanced_Berserkers_Call_armor:IsPurgeException() 	return false end
-- function modifier_Advanced_Berserkers_Call_armor:StatusEffectPriority(  )return MODIFIER_PRIORITY_LOW end
function modifier_Advanced_Berserkers_Call_armor:OnCreated(table)
	self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_damage = 0
	self.hp_return = 0.3
	self.min_health = 0
	self.outgoing_damage = 0

	--LV5解锁迎合+
	if self.level>=5 then
		self.bonus_damage = 35
		self.hp_return = 0.55
	end

	if IsServer() then
		--LV10解锁我错了别打了+
		if self.level>=10 then
			self.min_health = self:GetParent():GetMaxHealth()*0.3
		end
	end

	--LV15解锁狂暴
	if self.level>=15 then
		self.outgoing_damage = 25
	end
end
function modifier_Advanced_Berserkers_Call_armor:DeclareFunctions() 
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,

	}
	if self:GetAbility():GetUnlock(3)~=3 then
		table.insert(funcs,	MODIFIER_PROPERTY_MIN_HEALTH)
	end
	return funcs
 end


function modifier_Advanced_Berserkers_Call_armor:Advanced_GetModifierIncomingDamage_Percentage() 
	return self.bonus_damage
	
end
-- function modifier_Advanced_Berserkers_Call_armor:GetModifierTotalDamageOutgoing_Percentage() 
-- 	return self.outgoing_damage
	
-- end


function modifier_Advanced_Berserkers_Call_armor:GetMinHealth() return self.min_health end

function modifier_Advanced_Berserkers_Call_armor:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	--不反映刃甲伤害
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	--生命丢失也不要
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	--技能伤害不要
	-- print(" keys.damage_category=".. keys.damage_category)
	if keys.damage_category~=1 then 
		return 0
	end
	if IsServer() then
		--返还生命值

		local dmg = keys.damage*self.hp_return
		local parent = self:GetParent()
		Timers:CreateTimer(0.2, function()
			parent:Heal(dmg, parent)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent,dmg, nil) 
		end)
	

		--LV10效果
		if self.level<10 then
			if parent:GetHealthPercent()<30 then
				self:GetAbility():EndAbility()
				parent:Heal(parent:GetMaxHealth()*0.4, parent)
				self:SafeDestroy()
			end
		end
		
		
	end
end



function modifier_Advanced_Berserkers_Call_armor:OnDestroy(table)
	if IsServer() then
		--LV10恢复生命
		if self.level>=10 then
			if self:GetAbility().unlock3 then
				return
			end
			local parent = self:GetParent()
			parent:Heal(parent:GetMaxHealth()*0.4, parent)
		end

	end
end


-- advanced_modifier
function modifier_Advanced_Berserkers_Call_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_Advanced_Berserkers_Call_armor:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.outgoing_damage
end








modifier_Advanced_Berserkers_Call_unlock3 = class({})

function modifier_Advanced_Berserkers_Call_unlock3:IsDebuff()				return false end
function modifier_Advanced_Berserkers_Call_unlock3:IsHidden() 			return true end
function modifier_Advanced_Berserkers_Call_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Berserkers_Call_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Berserkers_Call_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Berserkers_Call_unlock3:OnCreated()
	if IsServer() then
		self.step = 0
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Berserkers_Call_unlock3:OnIntervalThink()
	
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	self.step = self.step + 1

	if parent:GetHealthPercent()<=30 then
		local healing = HealWithGain(parent:GetMaxHealth()*0.1,parent,parent,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	end
	if self.step>=2 then
		local ability = self:GetAbility()
		ability:OnSpellStart()
		self.step = 0
	end
end