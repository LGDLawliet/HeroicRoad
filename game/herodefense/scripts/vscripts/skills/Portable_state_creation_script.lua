--暂无内容
--该脚本提供为目标单位添加各种状态的函数
Portable_state_creation_script = class({})

function normal_damage(key)
    local caster = key.caster
    local target = key.target
    local damage1 = caster:GetIntellect(false)
    local position = caster:GetCursorPosition()

    DebugDrawText(position, "陈少nmsl", true, 4)
--获取

    local damagetable = {  --创建伤害表
        victim = target,
        attacker = caster,
        damage = damage1,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }

    ApplyDamage(damagetable)  --造成伤害 由上表提供
end