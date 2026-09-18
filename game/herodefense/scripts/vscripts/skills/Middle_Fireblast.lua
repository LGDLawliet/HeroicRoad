Middle_Fireblast = class({})
--modifier_Middle_Fireblast
LinkLuaModifier("modifier_Middle_Fireblast", "skills/Middle_Fireblast", LUA_MODIFIER_MOTION_NONE)
--链接技能与修饰器
function Middle_Fireblast:GetAOERadius()
	return self:GetSpecialValueFor( "range" )
end

function Middle_Fireblast:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local damage1 = self:GetSpecialValueFor("spell_damage")
    local stuntime = self:GetSpecialValueFor("stun_time")
    local range = self:GetSpecialValueFor("range")
    damage1 = caster:GetIntellect(false) * 2 + damage1
--获取施法者，目标，伤害值，眩晕时间




 

    --为target添加修饰器（由来单位 由来技能 修饰器名 属性（持续时间） ）

    --添加技能特效
    --以上随着施法触发]]--
    target:EmitSound("Hero_OgreMagi.Fireblast.Target")
    caster:EmitSound("Hero_OgreMagi.Fireblast.Cast")
    --播放声音
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), slef, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    --队伍数字 搜索坐标 技能本身 搜寻范围  搜索队伍（敌人） 类型-英雄与普通 
    if #enemies > 0 then
      for a, enemy in pairs(enemies) do
          if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
              enemy:AddNewModifier(caster, self, "modifier_Middle_Fireblast", {duration = stuntime})
              local damagetable = {  --创建伤害表
              victim = enemy,
              attacker = caster,
              damage = damage1,
              damage_type = DAMAGE_TYPE_MAGICAL,
          }
      
      
          ApplyDamage(damagetable)  --造成伤害 由上表提供
          local particle = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf"
          ParticleManager:CreateParticle(particle,  PATTACH_ROOTBONE_FOLLOW, enemy)
          particle = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast_cast.vpcf"
          ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, enemy)
          particle = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf"
          ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, enemy)
          particle = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf"
          ParticleManager:CreateParticle(particle, PATTACH_ROOTBONE_FOLLOW, enemy)
          end
      end
    end
end
--以下修饰器触发后的内容

modifier_Middle_Fireblast = class({})
function modifier_Middle_Fireblast:IsDebuff()
    return true
end
--添加debuff
function modifier_Middle_Fireblast:IsStunDebuff()
    return true
end
--添加眩晕debuff
function modifier_Middle_Fireblast:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,  
    }
    return state
end
--添加至状态栏


function modifier_Middle_Fireblast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
--为目标覆写动作
function modifier_Middle_Fireblast:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_Middle_Fireblast:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf" 
    --添加眩晕特效
end

function modifier_Middle_Fireblast:GetEffectAttachType()
      return  PATTACH_OVERHEAD_FOLLOW   
      --添加头顶特效
end  


