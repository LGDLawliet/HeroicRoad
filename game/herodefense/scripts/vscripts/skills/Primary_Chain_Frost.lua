Primary_Chain_Frost = class({})
LinkLuaModifier("modifier_Primary_Chain_Frost", "Primary_Chain_Frost", LUA_MODIFIER_MOTION_NONE)
function Primary_Chain_Frost:OnSpellStart()  --施法产生投掷物
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
-----------------------------------
    if self.instance == nil then
        self.instance = 0
        self.jump_count = {}
        self.target = {}
    elseif self.instance > 100 then   --当施法次数大于100时释放内存进行重置
            self.jump_count =nil
            self.target = nil
            self.instance = 0
            self.jump_count = {}
            self.target = {}
    else 
        self.instance = self.instance + 1
    end
    print(self.instance)
    --创建自定义属性 包含施法次数 跳跃次数（字典） 目标（字典）
    --第一次施法 instance = 0
    self.target[self.instance] = target
    --将第一个目标添加至当前施法次数里
    --第一次施法 self.target[0] = target
    self.jump_count[self.instance] = self:GetSpecialValueFor("Number_of_Bounces")
    --获取技能属性（弹跳次数）
    -- self.jump_count[0] = 10

    local info = {
        EffectName = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf",
        Ability = self,
        iMoveSpeed = 800,
        Source = caster,
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }
    ProjectileManager:CreateTrackingProjectile(info) --产生第一个投掷物
    caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")  --施法音效
end

function Primary_Chain_Frost:OnProjectileHit(hTarget, vLocation)  --命中目标

    hTarget:EmitSound("Hero_SkeletonKing.Hellfire_Blast")  --命中音效

    local caster = self:GetCaster()
    local range = self:GetSpecialValueFor("Bounce_Distance")
    local damage1 = self:GetSpecialValueFor("spell_damage")
    local i_index = self:GetSpecialValueFor("intelligence_index")
    local effectduration = self:GetSpecialValueFor("effect_duration")
    damage1 = caster:GetIntellect(false) * i_index + damage1   --伤害获取
    local damagetable = {  --创建伤害表
    victim = hTarget,
    attacker = caster,
    damage = damage1,
    damage_type = DAMAGE_TYPE_MAGICAL,
   }
   ApplyDamage(damagetable)  --造成伤害 由上表提供
   hTarget:AddNewModifier(caster, self, "modifier_Primary_Chain_Frost", {duration = effectduration})

    -----------------------------------------------------------
    local current
    for i=0,self.instance do  --获取目标是被第几次技能命中
        if self.target[i] ~= nil then
            if self.target[i] == hTarget then
                current = i
            end
        end
    end
    self.jump_count[current] = self.jump_count[current] - 1  --减少一次计数
    

    if self.jump_count[current] > 0 then
        local next_target
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vLocation, self, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
         0, false)
        --找到满足条件的目标
        for _, enemy in pairs(enemies) do
            if enemy ~= hTarget then
                if enemy.hit == nil and enemy:GetHealth() > 0 then
                    next_target = enemy
                    break
                end
            end
        end
    
        if next_target ~= nil then
            self.target[current] = next_target
            local info = {
                EffectName = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf",
                Ability = self,
                iMoveSpeed = 800,
                Source = hTarget,
                Target = next_target,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            }
            ProjectileManager:CreateTrackingProjectile(info)            
    
        else
            self.target[current] =nil
        end
    --如果没有弹跳次数了释放内存
    else 
             self.target[current] = nil
    end
end


--修饰器内容
modifier_Primary_Chain_Frost = class({})
function modifier_Primary_Chain_Frost:IsDebuff()
    return true
end
--添加debuff
function modifier_Primary_Chain_Frost:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf" 
    --添加特效
end

function modifier_Primary_Chain_Frost:GetEffectAttachType()
      return  PATTACH_ROOTBONE_FOLLOW
      --添加头顶特效
end  

--------------------------------------------------------------------------------

function modifier_Primary_Chain_Frost:OnCreated()  --基础设置
	self.Chain_Frost_attackspeed = self:GetAbility():GetSpecialValueFor( "Attack_Speed_Slow" )
	self.Chain_Frost_movespeed = self:GetAbility():GetSpecialValueFor( "effect_slow(%)" )
end

--------------------------------------------------------------------------------

function modifier_Primary_Chain_Frost:OnRefresh( )
	self.Chain_Frost_attackspeed = self:GetAbility():GetSpecialValueFor( "Attack_Speed_Slow" )
	self.Chain_Frost_movespeed = self:GetAbility():GetSpecialValueFor( "effect_slow(%)" )
end

--------------------------------------------------------------------------------

function modifier_Primary_Chain_Frost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Primary_Chain_Frost:GetModifierMoveSpeedBonus_Percentage( params )
	return self.Chain_Frost_movespeed
end

--------------------------------------------------------------------------------

function modifier_Primary_Chain_Frost:GetModifierAttackSpeedBonus_Constant( params )
	return self.Chain_Frost_attackspeed
end

