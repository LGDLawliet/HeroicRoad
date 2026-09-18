LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ancient_apparition_2", "heroTalent/heroTalent_npc_dota_hero_ancient_apparition_2", LUA_MODIFIER_MOTION_NONE )
-- 定义技能类
heroTalent_npc_dota_hero_ancient_apparition_2 = class({})

function heroTalent_npc_dota_hero_ancient_apparition_2:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_ancient_apparition_2"
end

function heroTalent_npc_dota_hero_ancient_apparition_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/finger_of_death_unlock3/effect.vpcf", context )
end
-- 定义修饰器类

modifier_heroTalent_npc_dota_hero_ancient_apparition_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:RemoveOnDeath() return false end

-- 声明变量用于追踪消耗的魔法值
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:OnCreated()
    if IsServer() then
        self.consumed_mana = 0
		self:SetStackCount(self.consumed_mana)
    end
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.mana_cost = self:GetAbility():GetSpecialValueFor("mana_cost")*0.01
	self.heal = self:GetAbility():GetSpecialValueFor("heal")*0.01
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")*0.01
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

-- 增加魔法值上限
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
    }
    return funcs
end

function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:GetModifierExtraManaPercentage()
    return self.bonus_mana
end

-- 处理受到伤害时的魔法消耗和治疗
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:OnTakeDamage(keys)
    if IsServer() then
        if keys.unit == self:GetParent() then
            local parent = self:GetParent()
            local damage = keys.damage
            local current_mana = parent:GetMana()
            local mana_cost = math.max(current_mana * self.mana_cost,30)
            
            if current_mana >= mana_cost then
                local heal_amount = damage * self.heal
                parent:SetMana(current_mana - mana_cost)
                parent:Heal(heal_amount, self:GetAbility())
                
                
                -- 累计消耗的魔法值
                self.consumed_mana = self.consumed_mana + mana_cost
				self:SetStackCount(self.consumed_mana)
                
                -- 检查是否达到触发条件
                if self.consumed_mana >= parent:GetMaxMana() then
                    self:TriggerInstantKill()
                    self.consumed_mana = 0
					self:SetStackCount(self.consumed_mana)
                end
            end
        end
    end
end

-- 处理即死效果
function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:TriggerInstantKill()
    if IsServer() then
        local parent = self:GetParent()
        local radius = self.radius
        local parent_pos = parent:GetOrigin()

        -- 创建主要的冰爆特效
        local particle2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, parent) 
        ParticleManager:SetParticleControl( particle2, 0,parent:GetAbsOrigin())
        ParticleManager:SetParticleControl( particle2, 3,parent:GetAbsOrigin())

        EmitSoundOnLocationWithCaster(parent:GetAbsOrigin(), "Hero_Ancient_Apparition.IceBlast.Target", parent)
        EmitSoundOn("Hero_Ancient_Apparition.IceBlastRelease", parent)
        EmitSoundOnLocationWithCaster(parent_pos, "Hero_Ancient_Apparition.IceBlast.Target", parent)
        
        -- 寻找范围内的敌人
        local enemies = FindUnitsInRadius(
            parent:GetTeamNumber(),
            parent_pos,
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )
        
        for _, enemy in pairs(enemies) do
            local health_percent = enemy:GetHealthPercent()
            if health_percent <= self.line then
                -- 即死效果
                local kill_particle = ParticleManager:CreateParticle(
                    "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf",
                    PATTACH_ABSORIGIN_FOLLOW,
                    enemy
                )
                ParticleManager:ReleaseParticleIndex(kill_particle)
                
                enemy:ForceKill(false)
                -- 播放即死音效
                EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Kill", enemy)
            else
                -- 造成伤害
                local damageTable = {
                        attacker = parent,
                        victim = enemy,
                        damage = self.damage*parent:GetIntellect(false),
                        damage_type = self:GetAbility():GetAbilityDamageType(),
                        ability = self:GetAbility(),
                        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
                    }
                ApplyDamage(damageTable)
                -- 回复魔法值
                local mana = (parent:GetMaxMana() - parent:GetMana()) * self.mana_regen
                parent:GiveMana(mana)
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, parent, mana, nil)
            end
        end
    end
end


function modifier_heroTalent_npc_dota_hero_ancient_apparition_2:OnDestroy()
    if IsServer() then
        -- 清理所有可能的计时器和特效
        self.consumed_mana = 0
    end
end