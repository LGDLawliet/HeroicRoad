heroTalent_npc_dota_hero_spectre = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_spectre", "heroTalent/heroTalent_npc_dota_hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_spectre_triger", "heroTalent/heroTalent_npc_dota_hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_spectre_bonus", "heroTalent/heroTalent_npc_dota_hero_spectre", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_spectre:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()
end

function heroTalent_npc_dota_hero_spectre:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_spectre" end

------
modifier_heroTalent_npc_dota_hero_spectre = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spectre:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_spectre:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_spectre:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_spectre:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_spectre:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_spectre:ADDeclareFunctions() return {
	MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
	advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
} 
end
function modifier_heroTalent_npc_dota_hero_spectre:DeclareFunctions() return {
	MODIFIER_PROPERTY_TOOLTIP
} 
end
function modifier_heroTalent_npc_dota_hero_spectre:OnCreated(table)
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")+100
	self.no_armor = self.ability:GetSpecialValueFor("no_armor")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.line = self.ability:GetSpecialValueFor("line")*0.01
	self.taken = 0
	if IsServer() then 
		self:StartIntervalThink(1)
		self.number = 0
		self:SetStackCount(self.number)
		self.no_armor_final = 0
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end
function modifier_heroTalent_npc_dota_hero_spectre:OnIntervalThink()
	self.talentgain = self:GetAbility():GetTalentGain(0.6)
	local heroes = GetAllRealHeroes()
	local modifier = self:GetCaster():FindAllModifiersByName("modifier_heroTalent_npc_dota_hero_spectre_bonus")
	if modifier then
		self.bonus = #modifier
	end
	self.number = 0
	for _, hero in pairs(heroes) do
		if not hero:IsInvulnerable() and CalculateDistance(self:GetCaster(),hero) <= self.radius then
			self.number = self.number + 1
			self:SetStackCount(self.number + self.bonus)
		end
	end

	self.no_armor_final = self.no_armor*self:GetStackCount()*self.talentgain
end

function modifier_heroTalent_npc_dota_hero_spectre:OnTakeDamage(keys)
	if IsServer() and keys.unit==self:GetParent() then
		if self:GetParent():PassivesDisabled() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if not self.taken then 
			self.taken = 0
		end
		if self:GetAbility():IsCooldownReady() and self.taken then
			self.taken = self.taken + keys.damage
			-- self:SetStackCount(self:GetStackCount()+keys.damage)
			if self.taken >= caster:GetMaxHealth()*self.line then
				self.taken = 0
				self:GetAbility():UseResources(true, true, true,true)

				local illusion = caster:MakeCustomIllusion()
				illusion:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_spectre_triger", {duration = self.duration})
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_spectre_bonus", {duration = self.duration})
			end
		end
	end
end

function modifier_heroTalent_npc_dota_hero_spectre:Advanced_GetModifierAttackArmor_Ignore()
	return self.no_armor_final
end
function modifier_heroTalent_npc_dota_hero_spectre:OnTooltip()
	return self.no_armor_final
end
function modifier_heroTalent_npc_dota_hero_spectre:AddCustomTransmitterData( )
	return
	{
		no_armor_final = self.no_armor_final,
	}
end

function modifier_heroTalent_npc_dota_hero_spectre:HandleCustomTransmitterData( data )
	self.no_armor_final = data.no_armor_final
end

modifier_heroTalent_npc_dota_hero_spectre_bonus = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spectre_bonus:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_spectre_bonus:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_spectre_bonus:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_spectre_bonus:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_spectre_bonus:GetAttributes()    return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_heroTalent_npc_dota_hero_spectre_triger = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_spectre_triger:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_spectre_triger:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_spectre_triger:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_spectre_triger:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_spectre_triger:CheckState() return 
	{[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end

function modifier_heroTalent_npc_dota_hero_spectre_triger:DeclareFunctions() return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
	}
end


function modifier_heroTalent_npc_dota_hero_spectre_triger:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

	end
end
function modifier_heroTalent_npc_dota_hero_spectre_triger:GetModifierAttackSpeedBaseOverride(keys)
	return self:GetCaster():GetAttackSpeed(false)
end


function modifier_heroTalent_npc_dota_hero_spectre_triger:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetAbility():GetCaster()  --技能的拥有者
	local parent = self:GetCaster()               --幻象跟随者
	local parent_pos = parent:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (parent_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1500 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(parent_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end



function modifier_heroTalent_npc_dota_hero_spectre_triger:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	local caster = ability:GetCaster() 
	
	target:EmitSound("Hero_Terrorblade.Reflection")

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, true, true, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

function modifier_heroTalent_npc_dota_hero_spectre_triger:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		UTIL_Remove( parent )
	end
end