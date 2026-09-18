
modifier_chaotic_bonus_attributes = advanced_modifier({})

function modifier_chaotic_bonus_attributes:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_impact_damage.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/shadow_wave/unlock2/thinker_effectformation.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/set_tree/set_tree_4.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/set_tree/time.vpcf", context )
end
function modifier_chaotic_bonus_attributes:IsHidden()return false end
function modifier_chaotic_bonus_attributes:IsDebuff()return false end
function modifier_chaotic_bonus_attributes:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes:IsPurgable()return false end
function modifier_chaotic_bonus_attributes:GetTexture() return "ability_capture" end
function modifier_chaotic_bonus_attributes:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes:OnCreated(keys)
	local hero = self:GetParent()
	local nPlayerID = hero:GetPlayerOwnerID()
	-- local NetTable_key = tostring(nPlayerID).."_bonus_attribute"
	-- local data = CustomNetTables:GetTableValue( "fellOmenInfo", NetTable_key).value
	
	if IsServer() then
		if  keys.ability_point then
			local abilityPoints = hero:GetAbilityPoints() + keys.ability_point
        	hero:SetAbilityPoints(abilityPoints)

		end
		--self.health = keys.health
		--self.mana = keys.mana
		self.outgoing = keys.outgoing
		self.incoming = keys.incoming
		--self.summon = keys.summon
		--self.bonus_spell_damage = keys.spell_damage
		--self.armor = keys.armor
		self.attack = keys.attack

		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_chaotic_bonus_attributes:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		--MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		--MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		--MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

--function modifier_chaotic_bonus_attributes:Advanced_GetModifier_Summon_Intensity()	return self.summon end
function modifier_chaotic_bonus_attributes:Advanced_GetModifierIncomingDamage_Percentage()   return -self.incoming end
function modifier_chaotic_bonus_attributes:Advanced_GetModifierTotalDamageOutgoing_Percentage()   return self.outgoing end
function modifier_chaotic_bonus_attributes:Advanced_GetModifierBaseAttack_BonusDamage()   return self.attack end
--function modifier_chaotic_bonus_attributes:AdvancedGetModifierManaBonus()   return self.mana end

function modifier_chaotic_bonus_attributes:ADDeclareFunctions()
    return 
    {
        --advanced_MODIFIER_PROPERTY_HEALTH_BONUS,--生命值
        --advanced_MODIFIER_PROPERTY_MANA_BONUS,--魔法值
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,--伤害增加
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,--伤害减免
        --advanced_MODIFIER_PROPERTY_Summon_Intensity,--召唤增强
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        --advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		--advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_chaotic_bonus_attributes:AddCustomTransmitterData()
	return
	{
		--bonus_str = self.bonus_str,
		--bonus_agi = self.bonus_agi,
		--bonus_int = self.bonus_int,
		--bonus_spell_damage = self.bonus_spell_damage,
		--health = self.health,
		--mana = self.mana,
        outgoing = self.outgoing,
        incoming = self.incoming,
        summon = self.summon,
		--armor = self.armor,
		--attack_damage = self.attack_damage,
	}
end

function modifier_chaotic_bonus_attributes:HandleCustomTransmitterData(data)
	--self.bonus_str = data.bonus_str
	--self.bonus_agi = data.bonus_agi
	--self.bonus_int = data.bonus_int

	self.summon = data.summon
	--self.health = data.health
	--self.mana = data.mana
	self.outgoing = data.outgoing
	self.incoming = data.incoming
end

function modifier_chaotic_bonus_attributes:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 8 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	elseif self._tooltip == 2 then
		return  self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 3 then
		return  self:Advanced_GetModifier_Summon_Intensity()
	elseif self._tooltip == 4 then
		return  0
	elseif self._tooltip == 5 then
		return  0
    
	elseif self._tooltip == 6 then
		return  0
	elseif self._tooltip == 7 then
		return  0
	elseif self._tooltip ==8 then
		return  0
	end
end




-------天赋1
---
modifier_chaotic_bonus_attributes_talent_1 = advanced_modifier({})
function modifier_chaotic_bonus_attributes_talent_1:IsHidden()return false end
function modifier_chaotic_bonus_attributes_talent_1:IsDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_1:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_1:IsPurgable()return false end
function modifier_chaotic_bonus_attributes_talent_1:GetTexture() return "disruptor_static_storm" end
function modifier_chaotic_bonus_attributes_talent_1:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes_talent_1:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes_talent_1:DestroyOnExpire() return false end
function modifier_chaotic_bonus_attributes_talent_1:OnCreated(keys)
    self.conut_max = 3
    self.time = 3    
end

function modifier_chaotic_bonus_attributes_talent_1:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
    }
end

function modifier_chaotic_bonus_attributes_talent_1:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

-- function modifier_chaotic_bonus_attributes_talent_1:OnTooltip()
--     return self:GetParent():HDGetPrimaryStatValue()*self:GetParent():GetLevel()*0.6
-- end

function modifier_chaotic_bonus_attributes_talent_1:OnTakeDamage(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.unit:GetTeamNumber()==keys.attacker:GetTeamNumber() then
        return
    end
    if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then
        return
    end
    local caster = keys.attacker
    local target = keys.unit
    self.conut_max = 3
    self.time = 3
  
    --套装：巨浪风暴之主--------------------------------------
    self.storm_set = 0 
    self.storm_set_2 = nil
    self.storm_set_4 = nil
    local tModifiers = caster:FindAllModifiers()
	for _, hModifier in pairs(tModifiers) do
		if hModifier:GetName()=="modifier_item_set_storm_book" or hModifier:GetName()=="modifier_item_set_storm_boot" or hModifier:GetName()=="modifier_item_set_storm_armor" or hModifier:GetName()=="modifier_item_set_storm_amulet" then
			self.storm_set = self.storm_set + 1
		end
	end
    if self.storm_set >= 2 then
        self.storm_set_2 = true
        if self.storm_set >= 4 then
            self.storm_set_4 = true
        end
	end

    if self.storm_set_2 or self.storm_set_4 then
        self.time = 1.5
    end
    --套装：巨浪风暴之主-------------------------------------

    if self:GetRemainingTime()<=0 then
        self:SetStackCount(math.min(self:GetStackCount()+1,self.conut_max+1))
        self:SetDuration(self.time, true)
    end
    if self:GetStackCount() >= (self.conut_max+1) then
        
        self:GetParent():GameTimer(0.05, function()
            --套装：巨浪风暴之主-------------------------------------
            if self.storm_set_4 then
                self:SetStackCount(0)
                self:SetStackCount(math.min(self:GetStackCount()+2,self.conut_max+1))
                if target:HasModifier("modifier_item_set_storm_active") then
                    self:SetStackCount(math.min(self:GetStackCount()+1,self.conut_max+1))
                end

                local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                for _ , enemy in pairs(enemies) do
                    if enemy then
                        local pos = enemy:GetAbsOrigin()
                        local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControl(pfx, 0, pos)
                        ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
                        ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
                        enemy:EmitSound("Hero_Disruptor.ThunderStrike.Target")
                        local damageTable = {
                            victim = enemy,
                            attacker = caster,
                            damage =caster:HDGetPrimaryStatValue()*caster:GetLevel()*0.6,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = nil, --Optional.
                            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
                            }
                        ApplyDamage(damageTable)
                        ParticleManager:DestroyParticle(pfx, false)
                        ParticleManager:ReleaseParticleIndex(pfx)
                    end
                end
            --套装：巨浪风暴之主-------------------------------------
            else
                if not target or target:IsNull() or caster:IsNull() then
                    return
                end
                self:SetStackCount(0)
                local pos = target:GetAbsOrigin()
                local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, pos)
                ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
                ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
                target:EmitSound("Hero_Disruptor.ThunderStrike.Target")

                local damageTable = {
                    victim = target,
                    attacker = caster,
                    damage = caster:HDGetPrimaryStatValue()*caster:GetLevel()*0.6,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                    ability = nil, --Optional.
                    hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
                    }
                ApplyDamage(damageTable)
                ParticleManager:DestroyParticle(pfx, false)
                ParticleManager:ReleaseParticleIndex(pfx)
                
            end
        end)
    end
end

-----------------------------
---
modifier_chaotic_bonus_attributes_talent_2 = advanced_modifier({})
function modifier_chaotic_bonus_attributes_talent_2:IsHidden()return false end
function modifier_chaotic_bonus_attributes_talent_2:IsDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_2:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_2:IsPurgable()return false end
function modifier_chaotic_bonus_attributes_talent_2:GetTexture() return "phantom_assassin/persona/phantom_assassin_phantom_strike_persona1" end
function modifier_chaotic_bonus_attributes_talent_2:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes_talent_2:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes_talent_2:DestroyOnExpire() return false end
function modifier_chaotic_bonus_attributes_talent_2:OnCreated(keys)
    self.line = 100
    self.damage = 3
end

function modifier_chaotic_bonus_attributes_talent_2:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end
function modifier_chaotic_bonus_attributes_talent_2:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then return end
    if keys.attacker:IsRangedAttacker() then return end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
    local cleave_pct = 0.4

	local cleave_damage = keys.damage * cleave_pct
	if self:GetParent():IsIllusion() then
		cleave_damage = 0
	end
	local target = keys.target
    local number = 0
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
								ability = nil, --Optional.
                                hd_flags =  HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
								}
                                
			local damage = ApplyDamage(damageTable)
            number = number+1
            if number>=6 then
                break
            end
		end
	end
end
function modifier_chaotic_bonus_attributes_talent_2:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if keys.damage_category~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end
    if keys.target:GetHealthPercent() <= self.line then
        return math.min(keys.attacker:GetLevel()*self.damage,300)
    end
    return 0
end

function modifier_chaotic_bonus_attributes_talent_2:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_bonus_attributes_talent_2:OnTooltip()
    return math.min(self:GetParent():GetLevel()*self.damage,300)
end


-----------------------------
---
modifier_chaotic_bonus_attributes_talent_3 = advanced_modifier({})
function modifier_chaotic_bonus_attributes_talent_3:IsHidden()return false end
function modifier_chaotic_bonus_attributes_talent_3:IsDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_3:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_3:IsPurgable()return false end
function modifier_chaotic_bonus_attributes_talent_3:GetTexture() return "sven/fiend_cleaver_icons/sven_gods_strength" end
function modifier_chaotic_bonus_attributes_talent_3:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes_talent_3:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes_talent_3:DestroyOnExpire() return false end
function modifier_chaotic_bonus_attributes_talent_3:OnCreated(keys)

    self.bonus_damage_hp = 0.16*0.01
    self.incoming = 15
    self.outgoing = math.min(self.bonus_damage_hp*self:GetParent():GetMaxHealth(),1000)
    if IsServer() then
        self.unit_record = {}
        self:StartIntervalThink(5)
    end
    self.tree_set = 0 
    self.tree_set_2 = nil
    self.tree_set_4 = nil
end
  
function modifier_chaotic_bonus_attributes_talent_3:OnIntervalThink() 
    self.tree_set = 0 
    self.tree_set_2 = nil
    self.tree_set_4 = nil
    local caster = self:GetParent()
    local tModifiers = caster:FindAllModifiers()
	for _, hModifier in pairs(tModifiers) do
		if hModifier:GetName()=="modifier_item_set_tree_amulet" or hModifier:GetName()=="modifier_item_set_tree_boot" or hModifier:GetName()=="modifier_item_set_tree_lance" or hModifier:GetName()=="modifier_item_set_tree_armor" then
			self.tree_set = self.tree_set + 1
		end
	end
    if self.tree_set >= 2 then
        self.tree_set_2 = true
        --print("2件激活")
        if self.tree_set >= 4 then
            self.tree_set_4 = true
            --print("4件激活")
        end
	end
    if self.tree_set_2 == true then
        --print("找人")
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _ , enemy in pairs(enemies) do
            if enemy:IsChaoticEraElite() or enemy:GetUnitName()=="npc_monster_boss_chaoc_form_real_one" then
                --print("找到了！")
                enemy:AddNewModifier(caster,nil,"modifier_item_set_tree_active",{duration = 3,stack = caster:GetHealthRegen()*1000*0.01})
                break
            end
        end
    end
end

function modifier_chaotic_bonus_attributes_talent_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
    
function modifier_chaotic_bonus_attributes_talent_3:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if keys.attacker:IsChaoticEraElite() or keys.attacker:IsChaoticEraBoss() then 
        return -self.incoming
    end
    return 
end

function modifier_chaotic_bonus_attributes_talent_3:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end
    if not self.tree_set_4 then
        return
    end
    local modifier = keys.target:FindModifierByName("modifier_item_set_tree_active")
    if modifier then
        modifier:SafeDestroy()

        local dmg = keys.attacker:GetMaxHealth()*150*0.01
		local pfx = "particles/rebuild/items/set_tree/set_tree_4.vpcf"
		DoIMBACleaveDamage(keys.attacker, keys.target, nil, dmg, 50, 575, 550, pfx)
    end
end

function modifier_chaotic_bonus_attributes_talent_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then
        return
    end
    
    if keys.target then
		if keys.target:IsChaoticEraElite() or keys.target:GetUnitName()=="npc_monster_boss_chaoc_form_real_one" then
            self.outgoing = math.min(self.bonus_damage_hp*self:GetParent():GetMaxHealth(),1000)
            --print("当前增伤为精英，数值为"..math.min(self.bonus_damage*self:GetParent():GetStrength(),1000))
			return self.outgoing
		end
        --print("不是精英，数值为0")
		return 0
	end
	return 0
end

function modifier_chaotic_bonus_attributes_talent_3:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_bonus_attributes_talent_3:OnTooltip()
    return math.min(self.bonus_damage_hp*self:GetParent():GetMaxHealth(),1000)
end

-----------------------------
---
modifier_chaotic_bonus_attributes_talent_4 = advanced_modifier({})
function modifier_chaotic_bonus_attributes_talent_4:IsHidden()return false end
function modifier_chaotic_bonus_attributes_talent_4:IsDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_4:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_4:IsPurgable()return false end
function modifier_chaotic_bonus_attributes_talent_4:GetTexture() return "huskar/husk_2021_immortal_weapon_ability_icon/husk_2021_immortal_burning_spear_gold" end
function modifier_chaotic_bonus_attributes_talent_4:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes_talent_4:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes_talent_4:DestroyOnExpire() return false end
function modifier_chaotic_bonus_attributes_talent_4:OnCreated(keys)
    self.max_line = 100
    self.min_line = 40
    self.max_damage = 2
    self.min_damage = 0
end

function modifier_chaotic_bonus_attributes_talent_4:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_chaotic_bonus_attributes_talent_4:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then
        return
    end

    self.pct = keys.target:GetHealthPercent()
    if self.pct >= self.max_line then
        self.middle_index = self.max_damage
    end
    if self.pct <= self.min_line then
        self.middle_index = self.min_damage
    end
    if self.pct < self.max_line and self.pct > self.min_line then
        self.middle = (self.pct - self.min_line)/(self.max_line - self.min_line)
        self.middle_index = ((self.max_damage - self.min_damage)*self.middle + self.min_damage)
    end
    return math.min(self.middle_index *keys.attacker:GetLevel(),1000)
end

function modifier_chaotic_bonus_attributes_talent_4:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_bonus_attributes_talent_4:OnTooltip()
	return  self.max_damage*self:GetParent():GetLevel()
end
----------------------
modifier_chaotic_bonus_attributes_talent_5 = advanced_modifier({})
function modifier_chaotic_bonus_attributes_talent_5:IsHidden()return false end
function modifier_chaotic_bonus_attributes_talent_5:IsDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_5:IsStunDebuff()return false end
function modifier_chaotic_bonus_attributes_talent_5:IsPurgable()return false end
function modifier_chaotic_bonus_attributes_talent_5:GetTexture() return "dazzle/ti9_immortal_head/dazzle_shadow_wave_immortal" end
function modifier_chaotic_bonus_attributes_talent_5:IsPurgeException() 	return false end
function modifier_chaotic_bonus_attributes_talent_5:RemoveOnDeath() return false end
function modifier_chaotic_bonus_attributes_talent_5:DestroyOnExpire() return false end
function modifier_chaotic_bonus_attributes_talent_5:OnCreated(keys)
    self.conut_max = 6
    self.time = 5    
    self.duration = 25
    self.bonus = 0.8
    self.base = 10
end

function modifier_chaotic_bonus_attributes_talent_5:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_chaotic_bonus_attributes_talent_5:OnTooltip()
    return self:GetParent():GetLevel()*self.bonus + self.base
end
function modifier_chaotic_bonus_attributes_talent_5:OnSummonUnit(keys)
    if (not self:GetParent()) or (not self:GetParent():IsAlive()) then
        return
    end
    local parent = self:GetParent()
    local target = keys.target
    target:AddNewModifier(parent, nil, "modifier_chaotic_bonus_attributes_talent_5_thinker_buff", {bonus = (parent:GetLevel()*self.bonus + self.base)*13})

    local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW,"attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, nil,target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Dazzle.Shadow_Wave", parent)
end
function modifier_chaotic_bonus_attributes_talent_5:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
    if self:GetRemainingTime()<=0 then
        self:SetStackCount(math.min(self:GetStackCount()+1,self.conut_max+1))
        self:SetDuration(self.time, true)
    end

    if self:GetStackCount() >= (self.conut_max+1) then
        self:SetStackCount(0)
    

    self.conut_max = 6
    self.time = 5   
    self.duration = 25

    local caster = keys.unit
	local target_point 	= caster:GetAbsOrigin()

	self.thinker = CreateModifierThinker(
		caster, -- player source
		nil, -- ability source
		"modifier_chaotic_bonus_attributes_talent_5_thinker", 
		{duration = self.duration}, -- kv
		target_point,
		caster:GetTeamNumber(),
		false
	)
	local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW,"attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self.thinker, PATTACH_POINT_FOLLOW, nil,self.thinker:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOnLocationWithCaster(target_point, "Hero_Dazzle.Shadow_Wave", caster)
    end
end

---------------------以下是治疗波部分，MD真tm长啊————————————————————————————
modifier_chaotic_bonus_attributes_talent_5_thinker= modifier_chaotic_bonus_attributes_talent_5_thinker or advanced_modifier({})

function modifier_chaotic_bonus_attributes_talent_5_thinker:IsHidden()		return true end
function modifier_chaotic_bonus_attributes_talent_5_thinker:IsPurgable()		return false end
function modifier_chaotic_bonus_attributes_talent_5_thinker:RemoveOnDeath()	return false end
function modifier_chaotic_bonus_attributes_talent_5_thinker:OnCreated(keys)
	if IsServer() then

		local particle_cast = "particles/rebuild/spell/shadow_wave/unlock2/thinker_effectformation.vpcf"
		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
        ParticleManager:SetParticleShouldCheckFoW( self.effect_cast,false )
		local pos = self:GetParent():GetOrigin()

        self.damage = 6*0.01
        self.interval = 5    
        self.duration = 5
		self.radius =  1200
        self.bonus = 0.8
        self.base = 10
        self.damage_up = self:GetParent():GetLevel()*self.bonus +  self.base

		ParticleManager:SetParticleControl( self.effect_cast, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius, 0, 0 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(9999, 0, 0 ) )


		self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
		ParticleManager:SetParticleControl( self.effect_cast2, 0, pos )
		ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector(0, 0, 0 ) )
		ParticleManager:SetParticleControl( self.effect_cast2, 2, Vector(9999, 0, 0 ) )
		-- ParticleManager:ReleaseParticleIndex( self.effect_cast )
		pos.z  =  pos.z  +200
		self:GetParent():SetOrigin(pos)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_bonus_attributes_talent_5_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast,true	)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		ParticleManager:DestroyParticle(self.effect_cast2,true	)
		ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
		UTIL_Remove( self:GetParent() )
	end
end



function modifier_chaotic_bonus_attributes_talent_5_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if not caster:IsAlive() then
		self:SafeDestroy()
		return
	end
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for _, unit in ipairs(enemies) do
		self:CastSpell(unit,self:GetParent())
		break
	end
end

function modifier_chaotic_bonus_attributes_talent_5_thinker:CastSpell(target,source)
	local caster = self:GetCaster()
	local units = {}
	units[#units + 1] = target
	local max_target = 5
	for _, aunit in pairs(units) do
		local units1 =  FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == caster then  --判断取出的单位是否是施法者或已存在于列表中
					no_yet = false                        --如果是 则纪录
					break
				end
			end
			if no_yet then
				units[#units + 1] = unit1
				break
			end
			if #units > max_target then
				break
			end
		end
	end
	if caster ~= target then   --施法对象不上自身则插入自身
		table.insert(units, 1, caster)
	end

	local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
	local pfx_damage = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_impact_damage.vpcf"

	
	if source then
        local units1 =  FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
        for _, unit1 in pairs(units1) do
            self.unit = unit1
            break
        end
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_POINT_FOLLOW,nil, source:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.unit, PATTACH_POINT_FOLLOW, "attach_hitloc",self.unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	for k, unit in pairs(units) do
		local i = (k == #units) and k or (k + 1)
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		if unit == caster then
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		else
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControlEnt(pfx, 1, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i]:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Dazzle.Shadow_Wave", caster)
		local damageTable = {
			victim = unit,
			attacker = caster,
			--damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = nil, --Optional.
            hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY,
		}
        damageTable.damage = self.damage*unit:GetMaxHealth() 
        ApplyDamage(damageTable)
        unit:AddNewModifier(caster, nil, "modifier_chaotic_bonus_attributes_talent_5_thinker_buff", {duration = self.duration,bonus = (caster:GetLevel()*self.bonus + self.base)*10})

        local pfx2 = ParticleManager:CreateParticle(pfx_damage, PATTACH_CUSTOMORIGIN, unit)
        ParticleManager:SetParticleControlEnt(pfx2, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx2, 1, unit:GetAbsOrigin() + (unit:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * 100)
        ParticleManager:ReleaseParticleIndex(pfx2)
	end
end

modifier_chaotic_bonus_attributes_talent_5_thinker_buff = advanced_modifier({})

function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:IsHidden()		return false end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:IsPurgable()		return false end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:RemoveOnDeath()	return false end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:GetTexture() return "dazzle/ti9_immortal_head/dazzle_shadow_wave_immortal" end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:OnCreated(keys)
    if IsServer() then
        self.bonus = keys.bonus
        self:SetStackCount(self.bonus)
    end
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:ADDeclareFunctions(keys)
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:DeclareFunctions(keys)
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self:GetStackCount()*0.1
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount()*0.1
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end
function modifier_chaotic_bonus_attributes_talent_5_thinker_buff:OnTooltip()
    return self:GetStackCount()*0.1
end