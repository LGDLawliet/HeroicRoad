chaotic_arcane_supremacy = class({})
LinkLuaModifier("modifier_chaotic_arcane_supremacy", "chaotic_spell/class_8/chaotic_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_arcane_supremacy_buff", "chaotic_spell/class_8/chaotic_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_arcane_supremacy_rune1_thinker", "chaotic_spell/class_8/chaotic_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_arcane_supremacy_rune1_damage", "chaotic_spell/class_8/chaotic_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_arcane_supremacy_rune1_cd", "chaotic_spell/class_8/chaotic_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)

function chaotic_arcane_supremacy:GetIntrinsicModifierName()
	return "modifier_chaotic_arcane_supremacy"
end
function chaotic_arcane_supremacy:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm.vpcf", context )
end
--------------------------------------------------------
modifier_chaotic_arcane_supremacy = advanced_modifier({})

function modifier_chaotic_arcane_supremacy:IsDebuff() return false end
function modifier_chaotic_arcane_supremacy:IsPurgable()	return false end
function modifier_chaotic_arcane_supremacy:RemoveOnDeath() return false end
function modifier_chaotic_arcane_supremacy:IsPurgeException() return false end
function modifier_chaotic_arcane_supremacy:IsHidden() return true end
function modifier_chaotic_arcane_supremacy:OnCreated(keys)
    self.ability = self:GetAbility()
	self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
	self.crit_index = self.ability:GetSpecialValueFor("crit_index")*0.01
	self.outgoing = self.crit_chance * self.crit_index
    self.mp_steal = self.ability:GetSpecialValueFor("mp_steal")*0.01
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.type = self.ability:GetRuneType()
    self.rune_1_mp_cost = self.ability:GetSpecialValueFor("rune_1_mp_cost")*0.01
    self.rune_1_duration = self.ability:GetSpecialValueFor("rune_1_duration")
    self.rune_1_cd = self.ability:GetSpecialValueFor("rune_1_cd")
    -- 生效顺序：
    -- 1.阶级奥术至尊（不做任何特判）
    -- 2.乱奥术至尊（特判奥术至尊）
    -- 3.乱安姆（特判奥术至尊、乱奥术至尊）
    -- 4.银钥之门（特判奥术至尊、乱奥术至尊、安姆）
    self.crit_spell_table = {
        [1] = "modifier_Primary_arcane_supremacy",
        [2] = "modifier_Middle_arcane_supremacy",
        [3] = "modifier_Advanced_arcane_supremacy",
    }
    if IsServer() then
        self.crit_damage_table = {
            --victim = unit,
            attacker = self:GetCaster(),
            --damage = damage,
            --damage_type = keys.damage_type,
            damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
            --ability = keys.inflictor, --Optional.
            hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
        }
    end
end

function modifier_chaotic_arcane_supremacy:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end

function modifier_chaotic_arcane_supremacy:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end

    if IsPoisonDamage(keys) or IsBurningDamage(keys) or IsFreezingDamage(keys) then
     	return self.outgoing
    end
    return 0
end

function modifier_chaotic_arcane_supremacy:OnTakeDamage(keys)
    if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		local caster = self:GetCaster()

        if attacker ~= caster then return end
		if not caster:IsAlive() then return end
        if not IsEnemy(unit,attacker) then return end
		if not keys.inflictor then return end
        if keys.damage <= 0 then return end
		if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then return end
        if Cannotcrit(keys) then return end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then return end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return end
        -- 回蓝部分
        local mp = keys.damage*self.mp_steal
        attacker:GiveMana(mp)
        -- 暴击部分
		local more_multi
        for i = 1, 3 ,1 do
            more_multi = attacker:HasModifier(self.crit_spell_table[i])
        end
        if more_multi then return end
        
        local random = math.random
        local chance = self.crit_chance
		if chance >= random(1, 100) then
			self.crit_damage_table.victim = unit
            self.crit_damage_table.damage = keys.damage*self.crit_index
            self.crit_damage_table.damage_type = keys.damage_type
            self.crit_damage_table.ability = keys.inflictor

			local applydamage = ApplyDamage(self.crit_damage_table)
			if applydamage > 0 then 
                fSendCustomOverheadEventMessage("crit", unit, applydamage, nil, nil, Vector(255, 255, 0), 4)
            end
			
            attacker:AddNewModifier(attacker, self.ability, "modifier_chaotic_arcane_supremacy_buff", {duration = self.duration})

            if self.type == 1 then
                local cd = attacker:HasModifier("modifier_chaotic_arcane_supremacy_rune1_cd")
                if cd then return end
				if not attacker:IsAlive() then return end
                if not IsElementDamage(keys) then return end
                
                if IsFireDamage(keys) then
                    self.element = 64
                elseif IsIceDamage(keys) then
                    self.element = 256
                elseif IsLightningDamage(keys) then
                    self.element = 32
                elseif IsHolyDamage(keys) then
                    self.element = 128
                elseif IsDarkDamage(keys) then
                    self.element = 512
                end

                attacker:Script_ReduceMana(attacker:GetMana()*self.rune_1_mp_cost, self.ability)
                self:Rune1_Strom(unit:GetAbsOrigin(), self.element)
                attacker:AddNewModifier(attacker, self.ability, "modifier_chaotic_arcane_supremacy_rune1_cd", {duration = self.rune_1_cd})
            end
		end
    end 
end

function modifier_chaotic_arcane_supremacy:Rune1_Strom(pos,element)
	local caster = self:GetCaster()

	local thinker = CreateUnitByName("npc_dota_thinker", pos, false, caster, caster, caster:GetTeam())
	if thinker then
		thinker:AddNewModifier(caster, self.ability, "modifier_chaotic_arcane_supremacy_rune1_thinker", {duration = self.rune_1_duration, element = element})
	end
end
--------------------------------------------------------
modifier_chaotic_arcane_supremacy_buff = advanced_modifier({})

function modifier_chaotic_arcane_supremacy_buff:IsDebuff() return false end
function modifier_chaotic_arcane_supremacy_buff:IsPurgable()	return false end
function modifier_chaotic_arcane_supremacy_buff:IsPurgeException() return false end
function modifier_chaotic_arcane_supremacy_buff:OnCreated(keys)
    self.cast_range = self:GetAbility():GetSpecialValueFor("cast_range")
end

function modifier_chaotic_arcane_supremacy_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
end
function modifier_chaotic_arcane_supremacy_buff:Advanced_GetModifierCastRangeBonusStacking()
    if not self:GetAbility() then self:Destroy() return end
	return self.cast_range
end
----------------------------------------------------------
modifier_chaotic_arcane_supremacy_rune1_cd = advanced_modifier({})

function modifier_chaotic_arcane_supremacy_rune1_cd:IsDebuff() return false end
function modifier_chaotic_arcane_supremacy_rune1_cd:IsPurgable()	return false end
function modifier_chaotic_arcane_supremacy_rune1_cd:RemoveOnDeath() return false end
function modifier_chaotic_arcane_supremacy_rune1_cd:IsPurgeException() return false end
function modifier_chaotic_arcane_supremacy_rune1_cd:IsHidden() return true end
----------------------------------------------------------
modifier_chaotic_arcane_supremacy_rune1_thinker = advanced_modifier({})

function modifier_chaotic_arcane_supremacy_rune1_thinker:IsAura()return true end

function modifier_chaotic_arcane_supremacy_rune1_thinker:OnCreated(keys)
	self:GetParent().chaotic_static_storm_thinker = self

    self.ability = self:GetAbility()
	self.rune_1_duration = self.ability:GetSpecialValueFor("rune_1_duration")
    self.rune_1_radius = self.ability:GetSpecialValueFor("rune_1_radius")
	if IsServer() then
        local color
		self.element = keys.element
		local parent = self:GetParent()
		parent:EmitSound("Hero_Zuus.Cloud.Cast")

        if self.element == 64 then
            color = Vector(255,151,116)
        elseif self.element == 256 then
            color = Vector(255,255,255)
        elseif self.element == 32 then
            color = Vector(50,153,255)
        elseif self.element == 128 then
            color = Vector(248,254,93)
        elseif self.element == 2048 then
            color = Vector(235,92,254)
        end

		self.particle = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.rune_1_radius,0,0))
		ParticleManager:SetParticleControl(self.particle,2,Vector(self.rune_1_duration+1,0,0))
		if color then
        	ParticleManager:SetParticleControl(self.particle,60,color)
		end
        ParticleManager:SetParticleControl(self.particle,61,Vector(100,100,100))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_arcane_supremacy_rune1_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_arcane_supremacy_rune1_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(),	
		parent:GetOrigin(),
		nil,	
		self.rune_1_radius,	
		 DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		 DOTA_UNIT_TARGET_FLAG_NONE,	
		FIND_ANY_ORDER,	
		false	
	)
	for _,unit in pairs(units) do
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_arcane_supremacy_rune1_damage", {duration = 1, element = self.element})
	end
end

function modifier_chaotic_arcane_supremacy_rune1_thinker:CheckState()
	return{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}
end
---------------------------------------------------
modifier_chaotic_arcane_supremacy_rune1_damage = advanced_modifier({})

function modifier_chaotic_arcane_supremacy_rune1_damage:IsHidden() 			return true end
function modifier_chaotic_arcane_supremacy_rune1_damage:IsPurgable() 			return false end
function modifier_chaotic_arcane_supremacy_rune1_damage:IsPurgeException() 	return false end
function modifier_chaotic_arcane_supremacy_rune1_damage:IsDebuff() return true end
function modifier_chaotic_arcane_supremacy_rune1_damage:OnCreated(keys)
	local ability = self:GetAbility()
	self.rune_1_damage = ability:GetSpecialValueFor("rune_1_damage")
	if IsServer() then
		self.element = keys.element or 1
		self.timer = GameRules:GetGameTime()
		local caster = self:GetCaster()

		self.damageTable = {
			victim = self:GetParent(),
			attacker = caster,
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			hd_flags = self.element + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
		}

		self.interval = 1
		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_arcane_supremacy_rune1_damage:OnIntervalThink()
	local caster = self:GetCaster()
	local damage =  self.rune_1_damage*caster:HDGetPrimaryStatValue()

	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)
end