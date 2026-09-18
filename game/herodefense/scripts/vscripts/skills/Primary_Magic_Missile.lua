Primary_Magic_Missile = class({})
LinkLuaModifier("modifier_Primary_Magic_Missile", "Primary_Magic_Missile", LUA_MODIFIER_MOTION_NONE)
--链接修饰器
function Primary_Magic_Missile:OnSpellStart()  --施法产生投掷物
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
   -- local location = self:GetCursorPosition()
    local info = {
        EffectName = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf",
        Ability = self,
        iMoveSpeed = 900,
        Source = caster,
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }
    ProjectileManager:CreateTrackingProjectile(info)
    caster:EmitSound("Hero_VengefulSpirit.MagicMissile")
end

function Primary_Magic_Missile:OnProjectileHit(hTarget, vLocation)
    local target = hTarget
    local caster = self:GetCaster()
    local stuntime = self:GetSpecialValueFor("stun_time")
    local damage_b = self:GetSpecialValueFor("spell_damage")
    damage_b = caster:GetIntellect(false) * self:GetSpecialValueFor("intelligence_index") + damage_b
    --获取基础数据
    target:AddNewModifier(caster, self, "modifier_Primary_Magic_Missile", {duration = stuntime})
    --施加修饰器
    local damagetable = {  --创建伤害表
        victim = target,
        attacker = caster,
        damage = damage_b,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(damagetable)  --造成伤害 由上表提供
    target:EmitSound("Hero_VengefulSpirit.MagicMissileImpact")
    
end

modifier_Primary_Magic_Missile = class({})
function modifier_Primary_Magic_Missile:IsDebuff()
    return true
end
--添加debuff
function modifier_Primary_Magic_Missile:IsStunDebuff()
    return true
end
--添加眩晕debuff
function modifier_Primary_Magic_Missile:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,  
    }
    return state
end
--添加至状态栏


function modifier_Primary_Magic_Missile:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
--为目标覆写动作
function modifier_Primary_Magic_Missile:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_Primary_Magic_Missile:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf" 
    --添加眩晕特效
end

function modifier_Primary_Magic_Missile:GetEffectAttachType()
      return  PATTACH_OVERHEAD_FOLLOW   
      --添加头顶特效
end  
