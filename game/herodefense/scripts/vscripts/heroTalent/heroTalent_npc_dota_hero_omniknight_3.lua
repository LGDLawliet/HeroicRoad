heroTalent_npc_dota_hero_omniknight_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_3", "heroTalent/heroTalent_npc_dota_hero_omniknight_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_3_healed", "heroTalent/heroTalent_npc_dota_hero_omniknight_3", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_3_debuff", "heroTalent/heroTalent_npc_dota_hero_omniknight_3", LUA_MODIFIER_MOTION_HORIZONTAL  )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_omniknight_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_omniknight_3"
end
--全能天赋：天使的守护：全能失去所有吸血和回血能力，但是治疗效果增强300%。并且可以过量治疗，过量的治疗会产生虚假生命并使目标体型变大，虚假生命值超过目标本身的生命值后会开始对目标造成伤害，伤害值为10%的当前最大生命值。
modifier_heroTalent_npc_dota_hero_omniknight_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_omniknight_3:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_omniknight_3:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_HEAL_RECEIVED,
    }

    return funcs
end
--ON_HEAL_RECEIVED给目标添加一个modifier_heroTalent_npc_dota_hero_omniknight_3_healed
function modifier_heroTalent_npc_dota_hero_omniknight_3:OnHealReceived(keys)
    if not IsServer()  then
        return
    end
    --获取治疗量
    local heal = keys.gain
    if not keys.gain  then
        return
    end
    --keys.unit 为队友且不是幻象且存活
    if  keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and not keys.unit:IsIllusion() and keys.unit:IsAlive() then
        --给目标添加modifier_heroTalent_npc_dota_hero_omniknight_3_healed
        keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_omniknight_3_healed", {target = keys.unit,nHphealed =keys.gain    })
    end
end

function modifier_heroTalent_npc_dota_hero_omniknight_3:ADDeclareFunctions()
    return 
    {
        
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_Zero_Override,
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE
    }
end


function modifier_heroTalent_npc_dota_hero_omniknight_3:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -1000  --吸血无效化
end
function modifier_heroTalent_npc_dota_hero_omniknight_3:AdvancedGetModifierConstantHealthRegen_Zero_Override(keys)
    return 1       --回血无效化
end
function modifier_heroTalent_npc_dota_hero_omniknight_3:Advanced_GetModifierHealAMP_Percentage(keys)
    return 300      --治疗效果增强300%
end

modifier_heroTalent_npc_dota_hero_omniknight_3_healed = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:RemoveOnDeath() return true end

-- Initializations
function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:OnCreated( kv )
	if IsServer() then
        --记录最大生命值
        self.maxhealth = self:GetParent():GetMaxHealth()
        print("最大生命值",self.maxhealth)
		local hpbonus = math.min(kv.nHphealed,self.maxhealth)
		self:SetStackCount(hpbonus)
       
		
	end

end
function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:OnRefresh( kv )
	if IsServer() then
		local hpbonus = math.min(kv.nHphealed+ self:GetStackCount(),self.maxhealth)
       
		self:SetStackCount(hpbonus )
        --如果hpbonus值大于目标的最大生命值则开始计时
        --print("记录的最大生命值",self.maxhealth,"当前最大生命值",self:GetParent():GetHealth(),"虚假生命值",hpbonus)
        if hpbonus >= self.maxhealth then
           --如果没有则添加一个modifier_heroTalent_npc_dota_hero_omniknight_3_debuff
            if  not self:GetParent():FindModifierByName("modifier_heroTalent_npc_dota_hero_omniknight_3_debuff") then
                self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_omniknight_3_debuff", {oraginHp = self.maxhealth})
            end
        end
	end

end




function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:ADDeclareFunctions()
    return 
    {

		-- 临时生命值需要组合使用
		MODIFIER_SPECIAL_Temporary_Health_Points = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,


    }
end


function modifier_heroTalent_npc_dota_hero_omniknight_3_healed:AdvancedGetModifierTemporaryHealth(keys)
	local stack = self:GetStackCount()
	-- 作为临时生命值加成效果时直接返回
	if keys.temporaryHealthLogic then
		return stack
	end

    self.maxhealth  = self:GetParent():GetMaxHealth()-stack
	if IsClient() then
		return 0
	end
    if stack <= 0 then
        --记录最大生命值
        self.maxhealth = self:GetParent():GetMaxHealth()
        self:SafeDestroy()
        return 0
    end
    
	--虚假生命受到伤害会被放大三倍
    keys.damage = keys.damage * 3
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack

end

modifier_heroTalent_npc_dota_hero_omniknight_3_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_omniknight_3_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_3_debuff:RemoveOnDeath() return true end
--oncreated后开始计时
function modifier_heroTalent_npc_dota_hero_omniknight_3_debuff:OnCreated( kv )
    if IsServer() then
        self.oraginHp = kv.oraginHp
        self.timer = 0
        self.interval = 0.1
        self:StartIntervalThink(self.interval)
    end

end
--每0.1秒检查一次
function modifier_heroTalent_npc_dota_hero_omniknight_3_debuff:OnIntervalThink()
    if IsServer() then
        if not self:GetParent():FindModifierByName("modifier_heroTalent_npc_dota_hero_omniknight_3_healed") then
            self:SafeDestroy()
        end
        self.timer = self.timer + self.interval
        --寻找1000范围内的最近的敌方单位
        local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
        --enemies【1】不为空则attacker = enemies【1】
        local attacker = enemies[1] or self:GetCaster()
        --如果时间大于1秒则开始造成当前总血量的10%的伤害
        if self.timer >= 1 and self:GetParent():GetHealth() >self.oraginHp then
            local damage =  self:GetParent():GetMaxHealth()*0.1
            local damageTable = {
                victim = self:GetParent(),
                attacker = attacker,
                damage = damage,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags =  DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY  ,    --护盾穿透
                ability = self:GetAbility(),
            }
            ApplyDamage(damageTable)
            self.timer = 0
        end
        -- find modifier_heroTalent_npc_dota_hero_omniknight_3_healed在不在，不在就safeDestroy
        
        
    end
end