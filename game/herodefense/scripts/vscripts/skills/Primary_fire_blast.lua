Primary_fire_blast = class({})
--modifier_Primary_fire_blast
LinkLuaModifier("modifier_Primary_fire_blast", "Primary_fire_blast", LUA_MODIFIER_MOTION_NONE)
--链接技能与修饰器
function Primary_fire_blast:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local SKlevel = self:GetLevel()
    local damage1 = self:GetSpecialValueFor("spell_damage")
    local stuntime = self:GetSpecialValueFor("stun_time")
    damage1 = caster:GetIntellect(false) * 2 + damage1
--获取施法者，目标，伤害值，眩晕时间

    local damagetable = {  --创建伤害表
        victim = target,
        attacker = caster,
        damage = damage1,
        damage_type = DAMAGE_TYPE_MAGICAL,
 
    }


    ApplyDamage(damagetable)  --造成伤害 由上表提供

  target:AddNewModifier(caster, self, "modifier_Primary_fire_blast", {duration = stuntime})

    --为target添加修饰器（由来单位 由来技能 修饰器名 属性（持续时间） ）
    local particle = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf"
    ParticleManager:CreateParticle(particle,  PATTACH_ROOTBONE_FOLLOW, target)
    particle = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast_cast.vpcf"
    ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, target)
    particle = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf"
    ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, target)
    particle = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf"
    ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, target)
    --添加技能特效
    --以上随着施法触发]]--
    target:EmitSound("Hero_OgreMagi.Fireblast.Target")
    caster:EmitSound("Hero_OgreMagi.Fireblast.Cast")
    --播放声音
end
--以下修饰器触发后的内容

modifier_Primary_fire_blast = class({})
function modifier_Primary_fire_blast:IsDebuff()
    return true
end
--添加debuff
function modifier_Primary_fire_blast:IsStunDebuff()
    return true
end
--添加眩晕debuff
function modifier_Primary_fire_blast:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,  
    }
    return state
end
--添加至状态栏


function modifier_Primary_fire_blast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
--为目标覆写动作
function modifier_Primary_fire_blast:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_Primary_fire_blast:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf" 
    --添加眩晕特效
end

function modifier_Primary_fire_blast:GetEffectAttachType()
      return  PATTACH_OVERHEAD_FOLLOW   
      --添加头顶特效
end  


