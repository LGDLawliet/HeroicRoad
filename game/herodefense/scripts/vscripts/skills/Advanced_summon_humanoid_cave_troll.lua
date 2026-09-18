

Advanced_summon_humanoid_cave_troll						= Advanced_summon_humanoid_cave_troll or class({})
LinkLuaModifier( "modifier_Advanced_summon_humanoid_cave_troll_buff", "skills/Advanced_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_humanoid_cave_troll_trigger", "skills/Advanced_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_humanoid_cave_troll_trigger_effect", "skills/Advanced_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summon_humanoid_cave_troll_fast", "skills/Advanced_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_summon_humanoid_cave_troll_unlock3", "skills/Advanced_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )
require("internal/timers")


function Advanced_summon_humanoid_cave_troll:IsSummonSpell()return true end


function Advanced_summon_humanoid_cave_troll:CheckKV(key)
	local table = {
		bonus_damage=1.6,
		bonus_health=1.4,


	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_humanoid_cave_troll:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_summon_humanoid_cave_troll:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_summon_humanoid_cave_troll:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blade_Fury_unlock3",{})
	return true

end

function Advanced_summon_humanoid_cave_troll:Spawn()
	self.unlock3_list = {}
	self.unlock3_head = nil
end

function Advanced_summon_humanoid_cave_troll:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/troll_roar/roar_wave.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", context )



	
end

function Advanced_summon_humanoid_cave_troll:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_cave_troll",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", PATTACH_ABSORIGIN, unit)
		-- ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_cast_fx, 3, unit, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_humanoid_cave_troll_buff", {}) 
		if self.unlock3 then
			unit:AddNewModifier(caster, self or nil, "modifier_Advanced_summon_humanoid_cave_troll_unlock3", {}) 
			
		end

	end	

end



function Advanced_summon_humanoid_cave_troll:InsertToUnlock3(modifier)
	local unitTable = {}

	local height = 0
	local height_add = 128
	local offect = 0
	
	for i = 1, #self.unlock3_list, 1 do
		if not self.unlock3_list[i]:IsNull() then
			table.insert(unitTable,self.unlock3_list[i])
			self.unlock3_list[i].cave_troll_height = height
			self.unlock3_list[i].cave_troll_offect = height *0.2
			height = height + height_add
			-- print(height)
		end
	end
	table.insert(unitTable,modifier)
	modifier.cave_troll_height = height
	modifier.cave_troll_offect = height *0.2
	self.unlock3_list = unitTable
	if #self.unlock3_list>=1 then
		self.unlock3_head = self.unlock3_list[1]
	else
		self.unlock3_head = nil
	end
	self:RefreshUnlock3ListState()
end

function Advanced_summon_humanoid_cave_troll:RefreshUnlock3List()
	local unitTable = {}

	local height = 0
	local height_add = 128
	for i = 1, #self.unlock3_list, 1 do
		if not self.unlock3_list[i]:IsNull() then
			table.insert(unitTable,self.unlock3_list[i])
			self.unlock3_list[i].cave_troll_height = height
			self.unlock3_list[i].cave_troll_offect = height *0.2
			height = height + height_add
		end
	end
	self.unlock3_list = unitTable
	if #self.unlock3_list>=1 then
		self.unlock3_head = self.unlock3_list[1]
	else
		self.unlock3_head = nil
	end
	self:RefreshUnlock3ListState()
end
function Advanced_summon_humanoid_cave_troll:RefreshUnlock3ListState()
	for i = 1, #self.unlock3_list, 1 do
		if not self.unlock3_list[i]:IsNull() then
			self.unlock3_list[i]:RefreshState()
		end
	end
end
function Advanced_summon_humanoid_cave_troll:GetUnlock3Head()
	return self.unlock3_head
end

modifier_Advanced_summon_humanoid_cave_troll_buff = modifier_Advanced_summon_humanoid_cave_troll_buff or class({})

function modifier_Advanced_summon_humanoid_cave_troll_buff:IsDebuff() return false end
function modifier_Advanced_summon_humanoid_cave_troll_buff:IsHidden() return true end
function modifier_Advanced_summon_humanoid_cave_troll_buff:IsPurgable() return false end
function modifier_Advanced_summon_humanoid_cave_troll_buff:IsPurgeException() return false end
function modifier_Advanced_summon_humanoid_cave_troll_buff:OnCreated(keys)
	if IsServer() then
		self.damage_index = 1
		if self:GetAbility().advanced_level>=5 then
			self.damage_index = 1.4
		end
	end
end
function modifier_Advanced_summon_humanoid_cave_troll_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_Advanced_summon_humanoid_cave_troll_buff:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
	
		if keys.attacker == parent then
			if parent:IsInSpecialAttack() or not parent:IsApplyModifier() then
				return
			end

			local ability = self:GetAbility()
			if not ability then
				return
			end
			local chance = 10
			if ability.unlock1 then
				chance = 35
			end
			if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then

			else
				return
			end

			local target =keys.target
			-- local pos = target:GetAbsOrigin()

			local tTargets = FindUnitsInRadius(parent:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 0, false)
			
			
			local damageTable = {

				attacker = parent,
				damage = keys.damage*self.damage_index,
				damage_type = keys.damage_type,
				ability = ability, --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  , --Optional.
			}
			local count = 4
    		for i, hTarget in pairs(tTargets) do
				if hTarget~=target then
					damageTable.victim = hTarget
					ApplyDamage(damageTable)
					count = count - 1
					if count<=0 then
						break
					end
				end

    		end
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  parent )
			ParticleManager:SetParticleControl( nFXIndex, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 300, 300, 300 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			parent:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")

		end
	end
end





function modifier_Advanced_summon_humanoid_cave_troll_buff:OnDeath(keys)
    if not IsServer() then
        return
    end
    local unit = keys.unit
    local parent =  self:GetParent()
    if unit:GetUnitName() == parent:GetUnitName() and unit:GetTeamNumber()==parent:GetTeamNumber() and unit~=parent then
        if CalculateDistance(unit,parent)<=1000 then
			local ability = self:GetAbility()
			if not ability then
				return
			end
			local caster = self:GetCaster()
            local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
            parent:AddNewModifier(caster,ability,"modifier_Advanced_summon_humanoid_cave_troll_trigger",{	duration = 2.3})
			local duration = 10
			if ability.advanced_level>=10 then
				duration = 16
			end
            parent:AddNewModifier(caster,ability,"modifier_Advanced_summon_humanoid_cave_troll_fast",{	duration = duration*ModifierStatusGain})
        end

    end
	if keys.attacker==parent and unit~=parent then
		local ability = self:GetAbility()
		if not ability then
			return
		end
	
		if ability.advanced_level>=15 then
			
			local caster = self:GetCaster()
			local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
			parent:AddNewModifier(caster,ability,"modifier_Advanced_summon_humanoid_cave_troll_trigger",{	duration = 2.3})
			local duration = 16
            parent:AddNewModifier(caster,ability,"modifier_Advanced_summon_humanoid_cave_troll_fast",{	duration = duration*ModifierStatusGain})
		end
	end
end


modifier_Advanced_summon_humanoid_cave_troll_trigger = modifier_Advanced_summon_humanoid_cave_troll_trigger or advanced_modifier({})

function modifier_Advanced_summon_humanoid_cave_troll_trigger:IsHidden()	return true end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:IsDebuff()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:IsPurgable()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:IsPurgeException() return false end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:RemoveOnDeath() return true end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_Advanced_summon_humanoid_cave_troll_trigger:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:GetOverrideAnimationRate()
	return 1
end

function modifier_Advanced_summon_humanoid_cave_troll_trigger:CheckState()
	if self:GetAbility() and self:GetAbility().unlock2 then
		return
	end
    return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_Advanced_summon_humanoid_cave_troll_trigger:OnCreated(keys)
    if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local parent = self:GetParent()
		local tTargets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 0, false)
		local duration = 10
		if ability.advanced_level>=10 then
			duration = 16
		end
		for _, unit in ipairs(tTargets) do
			unit:AddNewModifier(caster,ability,"modifier_Advanced_summon_humanoid_cave_troll_trigger_effect",{	duration = duration})
		end
        self:StartIntervalThink(0.6)
    end
end


function modifier_Advanced_summon_humanoid_cave_troll_trigger:OnIntervalThink()
	local pfx = ParticleManager:CreateParticle("particles/rebuild/creeps_spell/troll_roar/roar_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(3000,1,1))
	ParticleManager:ReleaseParticleIndex(pfx)
end
function modifier_Advanced_summon_humanoid_cave_troll_trigger:Advanced_GetModifierIncomingDamage_Percentage()
	return -100
end


function modifier_Advanced_summon_humanoid_cave_troll_trigger:ADDeclareFunctions()
	local funcs = {

	}
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end

	return funcs
end






modifier_Advanced_summon_humanoid_cave_troll_trigger_effect = modifier_Advanced_summon_humanoid_cave_troll_trigger_effect or  advanced_modifier({})
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:IsHidden()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:IsDebuff()	return true end
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:IsPurgable()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:IsPurgeException() return false end
-- function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:OnCreated(params)
	self.armor_reduce = -7
	-- self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end




function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_summon_humanoid_cave_troll_trigger_effect:Advanced_GetModifierPhysicalArmorBonus()
    return math.max(self.armor_reduce*self:GetStackCount(),-60)
end








modifier_Advanced_summon_humanoid_cave_troll_fast = modifier_Advanced_summon_humanoid_cave_troll_fast or advanced_modifier({})
function modifier_Advanced_summon_humanoid_cave_troll_fast:IsHidden()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_fast:IsDebuff()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_fast:IsPurgable()	return false end
function modifier_Advanced_summon_humanoid_cave_troll_fast:IsPurgeException() return false end
-- function modifier_Advanced_summon_humanoid_cave_troll_fast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_summon_humanoid_cave_troll_fast:GetStatusEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end

function modifier_Advanced_summon_humanoid_cave_troll_fast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比    
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		table.insert(funcs,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL)
	end
	-- if self:GetAbility():GetUnlock(2)==2 then
	-- 	table.insert(funcs,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	-- end
	return funcs
end
function modifier_Advanced_summon_humanoid_cave_troll_fast:OnCreated()
    self.bonus_move = 20
    self.bonus_attack = 50
	if self:GetAbility():GetUnlock(1)==1 then
		self.bonus_attack = 100
	end
    if IsServer() then
        self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_ti10/ursa_ti10_enrage_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
    end
end

function modifier_Advanced_summon_humanoid_cave_troll_fast:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_summon_humanoid_cave_troll_fast:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_Advanced_summon_humanoid_cave_troll_fast:OnDestroy()
    if IsServer() then
        if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
    end
end
function modifier_Advanced_summon_humanoid_cave_troll_fast:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack * self:GetStackCount() end
function modifier_Advanced_summon_humanoid_cave_troll_fast:GetModifierMoveSpeedBonus_Percentage()	return  self.bonus_move* self:GetStackCount() end
function modifier_Advanced_summon_humanoid_cave_troll_fast:GetActivityTranslationModifiers( params )
	return "fast"
end
function modifier_Advanced_summon_humanoid_cave_troll_fast:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

-- function modifier_Advanced_summon_humanoid_cave_troll_fast:GetModifierTotalDamageOutgoing_Percentage()
-- 	return 200
-- end


function modifier_Advanced_summon_humanoid_cave_troll_fast:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		local max_health = target:GetMaxHealth()
		local health_damage = (max_health-target:GetHealth())*0.015

		health_damage = math.min(self:GetParent():GetAverageTrueAttackDamage(nil)*5,health_damage)

		return health_damage
	end
end
-- advanced_modifier
function modifier_Advanced_summon_humanoid_cave_troll_fast:ADDeclareFunctions()
	local funcs = {
        -- advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	if self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs

end
function modifier_Advanced_summon_humanoid_cave_troll_fast:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 200
end











modifier_Advanced_summon_humanoid_cave_troll_unlock3 = modifier_Advanced_summon_humanoid_cave_troll_unlock3 or advanced_modifier({})

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:IsDebuff() return false end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:IsHidden() return true end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:IsPurgable() return false end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:IsPurgeException() return false end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:OnCreated()
	if IsServer() then
		self:GetAbility():InsertToUnlock3(self)
		
	end
end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			ability:RefreshUnlock3List()
			Timers:CreateTimer(0.06, function()
				if ability and not ability:IsNull() then
					ability:RefreshUnlock3List()
				end
			end)
		end
		
		
	end
end	

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:RefreshState()
	if IsServer() then
		local ability = self:GetAbility()
		local head = ability:GetUnlock3Head()
		if head~=self then
			self.head = head:GetParent()
			self:SetStackCount(1)
			self:StartIntervalThink(FrameTime())
		else
			self:SetStackCount(0)
			self:StartIntervalThink(-1)
		end
	end
end	

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		if not self.head:IsNull() then
			FindClearSpaceForUnit( self:GetParent(), self.head:GetAbsOrigin(), true )
		end
		self:SafeDestroy()
		return
	end
	if not self.head:IsNull() then
		local parnet = self:GetParent()
		local forward = self.head:GetForwardVector()
		parnet:SetOrigin(self.head:GetAbsOrigin()+(Vector(0,0,self.cave_troll_height or 128))-forward*(self.cave_troll_offect or 0))
		parnet:SetForwardVector(forward)
	end
end



function modifier_Advanced_summon_humanoid_cave_troll_unlock3:CheckState() 
	if self:GetStackCount()==1 then
		return {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_ROOTED] = true,
		} 
	else
		return nil
	end
	
end


function modifier_Advanced_summon_humanoid_cave_troll_unlock3:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING,

    } 
end

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:GetModifierDisableTurning() 
	if self:GetStackCount()==1 then
		return 1 
	end
    return 0
end
function modifier_Advanced_summon_humanoid_cave_troll_unlock3:GetModifierIgnoreCastAngle()
	if self:GetStackCount()==1 then
		return 1
	end
    return 0
end

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:Advanced_GetModifierAttackRangeBonus()
	if self:GetStackCount()==1 then
		local bonus = self.cave_troll_offect or 0
		return bonus*1.1
	end
    return 0
end


function modifier_Advanced_summon_humanoid_cave_troll_unlock3:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

    }
end

function modifier_Advanced_summon_humanoid_cave_troll_unlock3:Advanced_GetModifier_FlyingPathing()	
	if self:GetStackCount()==1 then
		return 1
	end
	return 0
end






