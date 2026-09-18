LinkLuaModifier( "modifier_chaotic_qi", "chaotic_spell/class_1/chaotic_flurry_of_blows.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_suspend_origin", "chaotic_spell/class_2/chaotic_suspend_origin.lua", LUA_MODIFIER_MOTION_NONE )

if chaotic_suspend_origin == nil then
    ---@type CDOTABaseAbility
    chaotic_suspend_origin = class({})
end

function chaotic_suspend_origin:GetIntrinsicModifierName()
	return "modifier_chaotic_suspend_origin"
end


if modifier_chaotic_suspend_origin == nil then
    modifier_chaotic_suspend_origin = class({})
end

function modifier_chaotic_suspend_origin:IsHidden() return true end
function modifier_chaotic_suspend_origin:IsDebuff() return false end
function modifier_chaotic_suspend_origin:IsPurgable() return false end

function modifier_chaotic_suspend_origin:OnTakeDamage(params)

    if params.unit == self:GetParent() then
        local damage_threshold = (self.threshold-self:GetParent():FindModifierByName("modifier_chaotic_qi"):GetStackCount()) / 100 * self:GetParent():GetMaxHealth()
        if params.damage > damage_threshold then
            -- Heal the caster for the damage taken
            self:GetParent():Heal(params.damage, self:GetAbility())

            -- Create a timer to deal damage after the delay
            Timers:CreateTimer(1, function()
                local enemies = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, 600, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

                for _, enemy in pairs(enemies) do
                    ApplyDamage({
                        victim = enemy,
                        attacker = self:GetParent(),
                        damage = self:GetAbility():GetSpecialValueFor("mixed_damage"),
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        ability = self:GetAbility()
                    })

                    ApplyDamage({
                        victim = enemy,
                        attacker = self:GetParent(),
                        damage = self:GetAbility():GetSpecialValueFor("magical_damage"),
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility()
                    })

                    
                end
            end)
        end
    end
end

Lei4Xing2 = class({})

Wu3Gong1_E2Mei2Pai4_Qing1Long2Wu2Ya2Heng2Shan1Qing2Na2Shou3 = Lei4Xing2 --//QQ2024114-151357.mp3