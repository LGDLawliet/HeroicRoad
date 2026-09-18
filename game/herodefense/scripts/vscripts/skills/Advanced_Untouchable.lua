LinkLuaModifier("modifier_Advanced_Untouchable", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_slow", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_spell_slow", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_slow_stack", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_Count", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_lv20debuff", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Untouchable_unlock2", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Untouchable_unlock3", "skills/Advanced_Untouchable", LUA_MODIFIER_MOTION_NONE)
Advanced_Untouchable				= class({})

function Advanced_Untouchable:CheckKV(key)
	local table = {
        attack_slow=1,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Untouchable:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock1",{})
	return true
end
function Advanced_Untouchable:UnlockSecondCore(key)	
    local caster = self:GetCaster()

	if caster:GetUnitName()~="npc_dota_hero_enchantress" then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock2",{})
	return true
end
function Advanced_Untouchable:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock3",{})
	return true
end


function Advanced_Untouchable:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enchantress/enchantress_loadout.vpcf", context )

end





function Advanced_Untouchable:GetIntrinsicModifierName() 
	return "modifier_Advanced_Untouchable"
end

require("internal/timers")


modifier_Advanced_Untouchable		= class({})

function modifier_Advanced_Untouchable:IsHidden()		return true end
function modifier_Advanced_Untouchable:IsPurgable() 		return false end
function modifier_Advanced_Untouchable:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable:RemoveOnDeath()  return false end

function modifier_Advanced_Untouchable:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
    self.advanced_level =1
	
end



function modifier_Advanced_Untouchable:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_Advanced_Untouchable:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.advanced_level =self.ability:GetSpecialValueFor("advanced_level")

    if keys.unit:GetHealth()<=0 then
        if self.advanced_level>=10 and 9>=RandomInt(1, 10) and not keys.unit.force_die then
            keys.unit:SetHealth(1)
            local fhealing =  HealWithGain(keys.damage, keys.unit, keys.unit,self.ability) --返回治疗的数值
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.unit, fhealing, nil) 

        end
    end


    --不对刃甲伤害做出反映
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end


    if not (bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS) then
     
   
        local damage = keys.damage-keys.damage%1
        if damage >50 then
            local modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_Untouchable_Count", {duration = 10})
            if modifier then
                modifier:SetStackCount(damage)
            end
        end
        
	end
    if not IsEnemy(keys.unit,keys.attacker) then
        return
    end

    if keys.damage_category~=0 then
        return
    end
    if not (self.advanced_level>=15) and keys.attacker:IsMagicImmune() then
        return
    end
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    if keys.attacker.Advanced_Untouchable_trigger ==1 then
        return
    end
    local duration = 20
    if self.advanced_level>=5 then
        duration = 30
    end
    keys.attacker:AddNewModifier(caster, ability, "modifier_Advanced_Untouchable_spell_slow", {duration = duration})
    keys.attacker.Advanced_Untouchable_trigger = 1
    Timers:CreateTimer(3, function()
        keys.attacker.Advanced_Untouchable_trigger = 0
    end)
    -----------------------------------------------

end



function modifier_Advanced_Untouchable:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.parent == keys.target and not self.parent:PassivesDisabled() and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then
		if not (self.advanced_level>=15) and keys.attacker:IsMagicImmune() then
            return
        end
        
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Advanced_Untouchable_slow_stack", {duration = 20})
        keys.attacker:AddNewModifier(self.parent, self.ability, "modifier_Advanced_Untouchable_slow", {})
    end
end



modifier_Advanced_Untouchable_slow	= class({})


function modifier_Advanced_Untouchable_slow:IsDebuff()			return true end
function modifier_Advanced_Untouchable_slow:IsHidden() 			return true end
function modifier_Advanced_Untouchable_slow:IsPurgable() 		  return false end
function modifier_Advanced_Untouchable_slow:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable_slow:OnCreated()

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.advanced_level =self:GetAbility():GetSpecialValueFor("advanced_level")

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
   
	-- AbilitySpecials
	self.slow_attack_speed 			= -self.ability:GetSpecialValueFor("attack_slow")
	--self.slow_duration 			= self.ability:GetSpecialValueFor("slow_duration")
    if not IsServer() then
        return
    end
    local buff = self.parent:FindModifierByName("modifier_Advanced_Untouchable_slow_stack")
    local stack = 1
    if buff then
        stack = stack + buff:GetStackCount()*0.01
        -- print(buff:GetStackCount())
        if self.advanced_level>=20 then
            -- 圣洁效果
            if buff:GetStackCount()%10==0 then
                local pfx = ParticleManager:CreateParticle("particles/addons_gameplay/tower_good_tintable_lamp_end.vpcf", PATTACH_ABSORIGIN, self.parent)
                ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_ABSORIGIN, nil, self.parent:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(pfx)
                self.parent:AddNewModifier(self.caster, self.ability, "modifier_Advanced_Untouchable_lv20debuff", {duration = 3})
            end
            if buff:GetStackCount()==35 and self.ability.unlock1 then
                buff:SetStackCount(10)
                --trigger unlock1 effect
                local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 500, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                self.parent:EmitSound("Hero_Enchantress.EnchantCast")
                local damageTable = {
                    attacker = self.caster,
                    -- damage = self.parent:get(),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self.ability,
                }
                local primary_Attribute =  self.caster:GetPrimaryAttribute()
                damageTable.damage = primary_Attribute==1 and self.caster:GetAgility() or primary_Attribute==2 and self.caster:GetIntellect(false) or self.caster:GetStrength()
                damageTable.damage  = damageTable.damage  *10
                for i, unit in ipairs(units) do
                    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_loadout.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                    ParticleManager:SetParticleControlEnt(effect_cast, 0,unit,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),  true )
                    ParticleManager:ReleaseParticleIndex( effect_cast )



                    damageTable.victim = unit
                    ApplyDamage(damageTable)



                    if i>=3 then
                       break 
                    end
                end
            end
          
        end
        self.slow_attack_speed = self.slow_attack_speed *stack
        self:SetStackCount(self.slow_attack_speed)
    end

end

function modifier_Advanced_Untouchable_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_Advanced_Untouchable_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_enchantress_untouchable.vpcf"
end

function modifier_Advanced_Untouchable_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_Advanced_Untouchable_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

-- After the attack is complete, remove the slow after a short delay
function modifier_Advanced_Untouchable_slow:OnAttack(keys)
	if self.parent == keys.attacker then
		-- Wait frame time to check if the target is not Enchantress or if she was not killed to properly apply Regret stacks
		Timers:CreateTimer(FrameTime(), function()
			if (keys.target ~= self.caster or self.caster:IsAlive()) and self and not self:IsNull() then
				if self:GetStackCount() > 1 then
					self:DecrementStackCount()
				else 
					self:SetDuration(keys.attacker:GetAttackAnimationPoint(), false) 
				end
			end
		end)
	end
end

modifier_Advanced_Untouchable_slow_stack	= class({})


function modifier_Advanced_Untouchable_slow_stack:IsDebuff()			return true end
function modifier_Advanced_Untouchable_slow_stack:IsHidden() 			return false end
function modifier_Advanced_Untouchable_slow_stack:IsPurgable() 		    return false end
function modifier_Advanced_Untouchable_slow_stack:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable_slow_stack:OnRefresh(table)
    self:IncrementStackCount()
end
function modifier_Advanced_Untouchable_slow_stack:OnCreated(table)
    self:IncrementStackCount()
end




modifier_Advanced_Untouchable_spell_slow	= advanced_modifier({})


function modifier_Advanced_Untouchable_spell_slow:IsDebuff()			return true end
function modifier_Advanced_Untouchable_spell_slow:IsHidden() 			return false end
function modifier_Advanced_Untouchable_spell_slow:IsPurgable() 		    return false end
function modifier_Advanced_Untouchable_spell_slow:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable_spell_slow:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Untouchable_spell_slow:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_CastPoint

    }

	return funcs

end

function modifier_Advanced_Untouchable_spell_slow:Advanced_GetModifier_CastPoint() return -40 end


modifier_Advanced_Untouchable_Count = class({})

function modifier_Advanced_Untouchable_Count:IsDebuff()				return false end
function modifier_Advanced_Untouchable_Count:IsHidden() 				return true end
function modifier_Advanced_Untouchable_Count:IsPurgable() 			return false end
function modifier_Advanced_Untouchable_Count:IsPurgeException() 		return false end
function modifier_Advanced_Untouchable_Count:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Untouchable_Count:RemoveOnDeath() return true end

function modifier_Advanced_Untouchable_Count:OnCreated()

    self.parent = self:GetParent()


    self:StartIntervalThink(1)

end

function modifier_Advanced_Untouchable_Count:OnIntervalThink()
    if not IsServer() then
        return
    end
    local heal = self:GetStackCount() *0.03
    if heal<6 then
        -- print("destroy")
        self:SafeDestroy()
    end
    
    self.parent:Heal(heal, self.parent)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self.parent, heal, nil) 
end




modifier_Advanced_Untouchable_lv20debuff = class({})

function modifier_Advanced_Untouchable_lv20debuff:IsDebuff()			return true end
function modifier_Advanced_Untouchable_lv20debuff:IsHidden() 			return false end
function modifier_Advanced_Untouchable_lv20debuff:IsPurgable() 		return false end
function modifier_Advanced_Untouchable_lv20debuff:IsPurgeException() 	return false end


function modifier_Advanced_Untouchable_lv20debuff:CheckState()
	local state = {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,

    }
	 return state
end







modifier_Advanced_Untouchable_unlock2 = class({})

function modifier_Advanced_Untouchable_unlock2:IsDebuff()			return false end
function modifier_Advanced_Untouchable_unlock2:IsHidden() 			return true end
function modifier_Advanced_Untouchable_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Untouchable_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable_unlock2:RemoveOnDeath() return false end








modifier_Advanced_Untouchable_unlock3 = class({})

function modifier_Advanced_Untouchable_unlock3:IsDebuff()			return false end
function modifier_Advanced_Untouchable_unlock3:IsHidden() 			return true end
function modifier_Advanced_Untouchable_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Untouchable_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Untouchable_unlock3:RemoveOnDeath() return false end