Primary_Fireball = class({})
LinkLuaModifier("modifier_Primary_Fireball", "Primary_Fireball", LUA_MODIFIER_MOTION_NONE)
--链接修饰器
function Primary_Fireball:OnSpellStart()  --施法产生投掷物
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
   -- local location = self:GetCursorPosition()
    local info = {
        EffectName = "particles/hw_fx/hw_rosh_fireball.vpcf",
        Ability = self,
        iMoveSpeed = 900,
        Source = caster,
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }
    ProjectileManager:CreateTrackingProjectile(info)
    caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
end

function Primary_Fireball:OnProjectileHit(hTarget, vLocation)  --命中目标
    local target = hTarget
    local caster = self:GetCaster()
    local effectduration = self:GetSpecialValueFor("effect_duration")
    --获取基础数据
    target:AddNewModifier(caster, self, "modifier_Primary_Fireball", {duration = effectduration})
    --施加修饰器
    target:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
    local particle = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast_cast.vpcf"
    ParticleManager:CreateParticle(particle, PATTACH_CENTER_FOLLOW, target)
    local particle = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast_solarfeathers.vpcf"
    ParticleManager:CreateParticle(particle, PATTACH_CENTER_FOLLOW, target)
    ParticleManager:CreateParticle(particle, PATTACH_CENTER_FOLLOW, target)
    
end
--修饰器内容
modifier_Primary_Fireball = class({})
function modifier_Primary_Fireball:IsDebuff()
    return true
end
--添加debuff

function modifier_Primary_Fireball:OnCreated()
    self.caster = self:GetCaster()
    self.condamage = self:GetAbility():GetSpecialValueFor("intelligence_index")  *10* self.caster:GetIntellect(false)

    if IsServer() then
      self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("Injury_interval"))
      self:OnIntervalThink() 
    end
end
function modifier_Primary_Fireball:OnIntervalThink()
    local damagetable1 ={
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.condamage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage( damagetable1 )
end

function modifier_Primary_Fireball:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf" 
    --添加眩晕特效
end

function modifier_Primary_Fireball:GetEffectAttachType()
      return  PATTACH_ROOTBONE_FOLLOW
      --添加头顶特效
end  
