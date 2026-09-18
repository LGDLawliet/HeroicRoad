
LinkLuaModifier( "modifier_Middle_summon_healing_ward_buff", "skills/Middle_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_healing_ward_extra", "skills/Middle_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_summon_healing_ward_extra_earth", "skills/Middle_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
 Middle_summon_healing_ward						=  Middle_summon_healing_ward or class({})
require("internal/timers")
function Middle_summon_healing_ward:IsSummonSpell()return true end

function  Middle_summon_healing_ward:OnSpellStart()
	local caster =self:GetCaster()

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		if unit:FindModifierByNameAndCaster("modifier_Middle_summon_healing_ward_buff", caster) then
			TrueKill(caster,unit,self)
		end
	end
	self.earth = 0
	self.level = 0
	--决定图腾类型
	for i=0, 1 do  
		local Ability = caster:GetAbilityByIndex(i)
		if Ability then 
			--print(Ability:GetAbilityName()) 
			if Ability:GetAbilityName() == "Primary_Eldwurm_soul_Uldorak" or Ability:GetAbilityName() == "Middle_Eldwurm_soul_Uldorak" or Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Uldorak"then
				self.earth = 1
				print("大地图腾激活")
				if Ability:GetAbilityName() == "Advanced_Eldwurm_soul_Uldorak" then
					self.level = Ability.advanced_level
				end
				break
			end
		end
	end

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = 0
	local damage = 0
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 
	EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", caster)	

	local unit = caster:SummonUnit("npc_hd_healing_ward",life_duration,unit_pos,self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
	unit:AddNewModifier(caster, self, "modifier_Middle_summon_healing_ward_buff", {earth = self.earth , level = self.level})
end

--------------------------------------------------------------

modifier_Middle_summon_healing_ward_buff = advanced_modifier({})

function modifier_Middle_summon_healing_ward_buff:IsDebuff()			return false end
function modifier_Middle_summon_healing_ward_buff:IsHidden() 		return true end
function modifier_Middle_summon_healing_ward_buff:IsPurgable() 		return false end
function modifier_Middle_summon_healing_ward_buff:IsPurgeException() return false end
function modifier_Middle_summon_healing_ward_buff:GetEffectName() return "particles/rebuild/spell/healing_ward/healing_ward.vpcf" end


function modifier_Middle_summon_healing_ward_buff:OnCreated(keys)
	if IsServer() then
        self.level = keys.level
		self.earth = keys.earth
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		print(self.level)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Middle_summon_healing_ward_buff:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability then
		return
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local caster = self:GetCaster()
	for _, unit in pairs(enemies) do
		if unit ~= self:GetParent() then
			local heal = ability:GetSpecialValueFor("heal") + ability:GetSpecialValueFor("hp_heal")*0.01 * unit:GetMaxHealth()
			local healing = HealWithGain(heal,caster,unit,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
			unit:AddNewModifier(self:GetParent(),ability,"modifier_Middle_summon_healing_ward_extra",{duration = 1.6})
			if self.earth == 1 then
				unit:AddNewModifier(self:GetParent(),ability,"modifier_Middle_summon_healing_ward_extra_earth",{duration = 1.6 , level = self.level})
			end
		end
	end
end

function modifier_Middle_summon_healing_ward_buff:CheckState()
	return{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY  ] = true,
	}
end

--------------------------------------------------------------

modifier_Middle_summon_healing_ward_extra = advanced_modifier({})

function modifier_Middle_summon_healing_ward_extra:IsDebuff()			return false end
function modifier_Middle_summon_healing_ward_extra:IsHidden() 		return true end
function modifier_Middle_summon_healing_ward_extra:IsPurgable() 		return false end
function modifier_Middle_summon_healing_ward_extra:IsPurgeException() return false end
function modifier_Middle_summon_healing_ward_extra:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_res")
end
function modifier_Middle_summon_healing_ward_extra:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_Middle_summon_healing_ward_extra:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_Middle_summon_healing_ward_extra:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_Middle_summon_healing_ward_extra:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end
--------------------------------------------------------------

modifier_Middle_summon_healing_ward_extra_earth = advanced_modifier({})

function modifier_Middle_summon_healing_ward_extra_earth:IsDebuff()			return false end
function modifier_Middle_summon_healing_ward_extra_earth:IsHidden() 		return false end
function modifier_Middle_summon_healing_ward_extra_earth:IsPurgable() 		return false end
function modifier_Middle_summon_healing_ward_extra_earth:IsPurgeException() return false end
function modifier_Middle_summon_healing_ward_extra_earth:GetTexture() return "soul_of_Uldorak" end
function modifier_Middle_summon_healing_ward_extra_earth:OnCreated(keys)
	
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	if IsServer() then
		self.level = keys.level
		print(self.level)
		self:SetStackCount(self.level) 
	end
end
function modifier_Middle_summon_healing_ward_extra_earth:OnRefresh(keys)
	
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
	if IsServer() then
		self.level = keys.level
		self:SetStackCount(self.level) 
	end
end

function modifier_Middle_summon_healing_ward_extra_earth:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Middle_summon_healing_ward_extra_earth:Advanced_GetModifierIncomingDamage_Percentage()
	return -(self.incoming_down + (self:GetStackCount()*0.5))
end