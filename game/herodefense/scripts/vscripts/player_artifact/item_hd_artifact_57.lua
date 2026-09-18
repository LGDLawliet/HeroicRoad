-- 重写完成
item_hd_artifact_57 = class({})
LinkLuaModifier("modifier_item_hd_artifact_57", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_57_buff", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_57_lv20", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_57_lv10", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_57_buff_lightning", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_artifact_57_lv70", "player_artifact/item_hd_artifact_57.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_artifact_57:GetIntrinsicModifierName()
	return "modifier_item_hd_artifact_57"
end
function item_hd_artifact_57:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1/effect_ground_beam.vpcf", context )
end
function item_hd_artifact_57:SciAllCheck(target)
	if target then
        if target:HasModifier("modifier_item_hd_summon_ring_effects") 
            and target:HasModifier("modifier_item_hd_artifact_56") 
            and target:HasModifier("modifier_item_hd_artifact_57")
            and target:HasModifier("modifier_item_hd_artifact_58") then
            return true
        end
        return
    end
    return
end
function item_hd_artifact_57:SciCheck(target)
	if target then
        if target:GetUnitName() == "npc_hd_artifact_sci_dragon" 
            or target:GetUnitName() == "npc_hd_spirit_of_sci_snake" 
            or target:GetUnitName() == "npc_hd_artifact_sci_cat"
            or target:GetUnitName() == "npc_hd_artifact_sci_blue_whale" then
            return true
        end
        return
    end
    return
end
function item_hd_artifact_57:GetArtifactSpecialList()
    local list = {}
    list["76561198101659620"] = true
    return list
end
function item_hd_artifact_57:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_artifact_57:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end

modifier_item_hd_artifact_57 = advanced_modifier({})

function modifier_item_hd_artifact_57:IsDebuff() return false end
function modifier_item_hd_artifact_57:IsHidden() return self.level < 20 end
function modifier_item_hd_artifact_57:IsPurgable() return false end
function modifier_item_hd_artifact_57:RemoveOnDeath() return false end
function modifier_item_hd_artifact_57:GetTexture() return "item_artifact_59" end

function modifier_item_hd_artifact_57:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_57")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_artifact_57:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_summon_intensity = self.ability:GetArtifactSpecialValueFor("bonus_summon_intensity")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.armor_index = self.ability:GetArtifactSpecialValueFor("armor_index")*0.01
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")
    self.spell_give_7 = self.ability:GetArtifactSpecialValueFor("spell_give_7")*0.01
    self.spell_max_7 = self.ability:GetArtifactSpecialValueFor("spell_max_7")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_artifact_57")
end
function modifier_item_hd_artifact_57:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_57:OnTooltip()
	return self.attack_2*self:GetStackCount()
end
function modifier_item_hd_artifact_57:OnIntervalThink()
    local whale = self:GetCaster():HasModifier("modifier_item_hd_artifact_58")
    if whale and GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_artifact_58") >= 20 then return end
    self:SummonSlime()
end

function modifier_item_hd_artifact_57:SummonSlime()
    if not IsServer() then return end
    
    local count = self.max
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	local caster = self:GetCaster()
    local armor = self.armor_index * caster:GetPhysicalArmorValue(false)
	local life_duration = self.duration

    local health = 0
    local attack = 0
    local shop = chaotic_era_shop:GetPlayerShopLevel(caster:GetPlayerOwnerID(),true)
    -- print("商店等级是"..shop)
    if shop <= 3 then
        attack = 70 + 5*shop
        health = 56 + 5*shop
        -- print("1-3级商店.."..attack)
    elseif shop > 3 and shop <= 7 then
        attack = 80 + 4*shop
        health = 70 + 4*shop
        -- print("4-7级商店.."..attack)
    elseif shop > 7 then
        attack = 100 + 3*shop
        health = 91 + 3*shop
        -- print("8-13级商店.."..attack)
    end

    local heal = health*0.01 * caster:GetMaxHealth()+1000
	local damage = attack*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7)+100

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 400) 
	local unit = caster:SummonUnit("npc_hd_artifact_sci_cat",life_duration,unit_pos,caster:GetForwardVector(),self:GetAbility(),0,heal,nil,damage,armor,1,0)

	table.insert(self.summon_table,unit)
	unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_57_buff", {level = self.level})


    if self.level >= 40 and self:GetAbility():SciAllCheck(caster) then
        local ability = unit:AddAbility("chaotic_element_lightning")
		if ability then
			ability:SetLevel(1)
		end
    end
    if self.level >= 70 then
        local spell = 0
        local spell_amp = self.parent:GetSpellAmplification(false)*100
		if spell_amp>0 then
			spell = math.min(spell_amp*self.spell_give_7, self.spell_max_7)
		end
        unit:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_artifact_57_lv70", {spell = spell})
    end

    -- 播放音效
    EmitSoundOnLocationWithCaster(unit_pos, "Hero_Crystal.CrystalNova", unit)
    -- 创建特效
    local particle0 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
    ParticleManager:SetParticleControl(particle0, 0, Vector(unit_pos.x, unit_pos.y, unit_pos.z+2000))
    ParticleManager:SetParticleControl(particle0, 1, Vector(unit_pos.x, unit_pos.y, unit_pos.z))
    ParticleManager:SetParticleControl(particle0, 2, Vector(unit_pos.x, unit_pos.y, unit_pos.z))
    ParticleManager:ReleaseParticleIndex(particle0)
end

function modifier_item_hd_artifact_57:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end

function modifier_item_hd_artifact_57:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_hd_artifact_57:OnSummonUnit(keys)
    if not IsServer() then return end
    if self.level >= 20 then 
        if self:GetAbility():SciCheck(keys.target) then
            keys.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_artifact_57_lv20",{stack =self:GetStackCount()}) 
        end
    end
end

-- function modifier_item_hd_artifact_57:OnSummonUnitFinished(keys)
--     if not IsServer() then return end
--     if not keys.target then return end
--     if not self:GetAbility():SciCheck(keys.target) then
--         keys.target:ModifyHealth(0, self:GetAbility(), true, 0)
--     end
-- end
-----
modifier_item_hd_artifact_57_buff = advanced_modifier({})

function modifier_item_hd_artifact_57_buff:IsDebuff() return false end
function modifier_item_hd_artifact_57_buff:IsHidden() return true end
function modifier_item_hd_artifact_57_buff:IsPurgable() return false end
function modifier_item_hd_artifact_57_buff:RemoveOnDeath() return false end
function modifier_item_hd_artifact_57_buff:OnCreated(keys)
    if not self:GetAbility() then return end
    if IsServer() then
        self.level = keys.level or 0
        self:SetStackCount(self.level)
        self:StartIntervalThink(1.5)

        local caster = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1/effect_ground_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle,1,Vector(1400,0,0))
		self:AddParticle( self.particle, false, false, -1, true, false )
    end

    self.count_3 = self:GetAbility():GetArtifactSpecialValueFor("count_3")
    self.max_3 = self:GetAbility():GetArtifactSpecialValueFor("max_3")
    self.damage_3 = self:GetAbility():GetArtifactSpecialValueFor("damage_3")
    self.down_3 = self:GetAbility():GetArtifactSpecialValueFor("down_3")*0.01

    if self:GetStackCount() >= 10 then
        self.down_3 = self.down_3*0.5
    end
    if self:GetStackCount() >= 40 and self:GetAbility():SciAllCheck(self:GetCaster()) then
        self.count_3 = self:GetAbility():GetArtifactSpecialValueFor("count_4")
    end
end

function modifier_item_hd_artifact_57_buff:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
	end
end
function modifier_item_hd_artifact_57_buff:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
    return funcs
end

function modifier_item_hd_artifact_57_buff:CheckState()
    return{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end
    
function modifier_item_hd_artifact_57_buff:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetCaster() then return end
    if keys.attacker ~= self:GetParent() then return end
    if self:GetStackCount() < 20 then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_item_hd_artifact_57")
    if modifier then
        modifier:SetStackCount(math.min(modifier:GetStackCount() + 1, 5000))
    end
end

function modifier_item_hd_artifact_57_buff:OnIntervalThink()
	if not IsServer() then
		return 
	end
    if not self:GetAbility() then self:Destory() return end
    local attacker = self:GetParent()
    if not attacker:IsAlive() then return end
    local units = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , unit in pairs(units) do
        if unit:IsAlive() then
            self:Lightning(unit) 
            -- lv30
            if self:GetStackCount() >= 30 then
                if not self.count then
                    self.count = 0
                end
                self.count = self.count + 1 
                if self.count >= self.count_3 then
                    if unit:IsAlive() then
                        self:Lightning(unit)
                        self.count = 0
                    end
                end
            end
            break
        end
    end
end

function modifier_item_hd_artifact_57_buff:Lightning(target)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if not target then return end
    local attacker = self:GetParent()

    local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
    ParticleManager:ReleaseParticleIndex(head_particle)
    
    self:GetParent():AddNewModifier(attacker, self:GetAbility(), "modifier_item_hd_artifact_57_buff_lightning", 
    {
        starting_unit_entindex	= target:entindex(),
        max = self.max_3,
        damage = self.damage_3,
        down = self.down_3,
    })
end
-----
modifier_item_hd_artifact_57_buff_lightning = advanced_modifier({})

function modifier_item_hd_artifact_57_buff_lightning:IsHidden()		return true end
function modifier_item_hd_artifact_57_buff_lightning:IsPurgable()		return false end
function modifier_item_hd_artifact_57_buff_lightning:RemoveOnDeath()	return false end
function modifier_item_hd_artifact_57_buff_lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hd_artifact_57_buff_lightning:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage = self:GetParent():GetAverageTrueAttackDamage(nil)*keys.damage
    print(self.arc_damage)
	self.radius	= 600
	self.jump_count	= keys.max
	self.jump_delay	= 0.05
    self.down = keys.down

	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	self.units_affected	= {}  
	self.current_unit = EntIndexToHScript(self.starting_unit_entindex)

	if self.current_unit then  
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= DAMAGE_TYPE_PHYSICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetParent(),
			ability 		= self:GetAbility(),
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		})
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	self.unit_counter = 0
	self.pos = self.current_unit:GetAbsOrigin()
	self:StartIntervalThink(self.jump_delay)
end

function modifier_item_hd_artifact_57_buff_lightning:OnIntervalThink()
	if not self.current_unit or self.current_unit:IsNull() then
		self:SafeDestroy()
		return
	end
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
			
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			
			self.previous_unit = self.current_unit
			self.current_unit = enemy
			
			self.pos = self.current_unit:GetAbsOrigin()
			self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
			self.unit_counter = self.unit_counter + 1
			
			ApplyDamage({
                victim 			= enemy,
                damage 			= self.arc_damage,
                damage_type		= DAMAGE_TYPE_PHYSICAL,
                damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
                attacker 		= self:GetParent(),
                ability 		= self:GetAbility(),
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			})
			self.arc_damage = self.arc_damage *(1-self.down)
			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end
	--区域内没有符合的单位了 就去除
	self:SafeDestroy()
end

---
modifier_item_hd_artifact_57_lv20 = advanced_modifier({})

function modifier_item_hd_artifact_57_lv20:IsDebuff() return false end
function modifier_item_hd_artifact_57_lv20:IsHidden() return false end
function modifier_item_hd_artifact_57_lv20:IsPurgable() return false end
function modifier_item_hd_artifact_57_lv20:GetTexture() return "item_artifact_59" end

function modifier_item_hd_artifact_57_lv20:OnCreated(keys)
    if not self:GetAbility() then return end
    self.ability = self:GetAbility()
    self.attack_2 = self.ability:GetArtifactSpecialValueFor("attack_2")
	if IsServer() then
		self.stack = keys.stack
        self:SetStackCount(self.stack)
	end
end

function modifier_item_hd_artifact_57_lv20:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_item_hd_artifact_57_lv20:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_artifact_57_lv20:Advanced_GetModifierPreAttack_BonusDamage()
    if not self.ability then return end
	return self.attack_2*self:GetStackCount()
end
function modifier_item_hd_artifact_57_lv20:OnTooltip()
    if not self.ability then return end
	return self.attack_2*self:GetStackCount()
end

modifier_item_hd_artifact_57_lv70 = advanced_modifier({})

function modifier_item_hd_artifact_57_lv70:IsDebuff() return false end
function modifier_item_hd_artifact_57_lv70:IsHidden() return true end
function modifier_item_hd_artifact_57_lv70:IsPurgable() return false end

function modifier_item_hd_artifact_57_lv70:OnCreated(keys)
    if not self:GetAbility() then return end
	if IsServer() then
        self:SetStackCount(keys.spell)
    end
end

function modifier_item_hd_artifact_57_lv70:ADDeclareFunctions()
	return{
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_artifact_57_lv70:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end