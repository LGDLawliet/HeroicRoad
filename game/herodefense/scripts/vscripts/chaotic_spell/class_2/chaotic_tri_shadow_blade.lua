chaotic_tri_shadow_blade = class({})

LinkLuaModifier("modifier_chaotic_tri_shadow_blade", "chaotic_spell/class_2/chaotic_tri_shadow_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_shadow_blade_active", "chaotic_spell/class_2/chaotic_tri_shadow_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_shadow_blade_rune_3", "chaotic_spell/class_2/chaotic_tri_shadow_blade", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_shadow_blade:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_shadow_blade"
end
function chaotic_tri_shadow_blade:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spectre/spectre_desolate.vpcf", context )
end
-------------------
modifier_chaotic_tri_shadow_blade = advanced_modifier({})

function modifier_chaotic_tri_shadow_blade:IsDebuff() return false end
function modifier_chaotic_tri_shadow_blade:IsHidden() return true end
function modifier_chaotic_tri_shadow_blade:IsPurgable() 		return false end
function modifier_chaotic_tri_shadow_blade:IsPurgeException() 	return false end
function modifier_chaotic_tri_shadow_blade:RemoveOnDeath()  return false end
function modifier_chaotic_tri_shadow_blade:OnCreated(keys)
    self.ability = self:GetAbility()
    self.cost = self:GetAbility():GetSpecialValueFor("cost") 
    self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
    self.no_armor = self:GetAbility():GetSpecialValueFor("no_armor")
    self.bonus_no_armor = self:GetAbility():GetSpecialValueFor("bonus_no_armor")*0.01
    self.cd = self:GetAbility():GetSpecialValueFor("cd")
    if self:GetAbility():GetRuneType()==1 then
        self.cd = self:GetAbility():GetSpecialValueFor("cd") - self:GetAbility():GetSpecialValueFor("rune_1_cd")
    end
end

function modifier_chaotic_tri_shadow_blade:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算
	}
end

function modifier_chaotic_tri_shadow_blade:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	
    }
end

function modifier_chaotic_tri_shadow_blade:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.attacker:IsInSpecialAttack() then
            -- 普攻获取出发层数
            keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_hd_trigger",{cost_get = self.cost_get})
            
            local trigger = keys.attacker:FindModifierByName("modifier_hd_trigger")
            if trigger and trigger:GetStackCount() >= self.cost then
                if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() then
                    -- 检测触发层数，足够，冷却完成，自动施法，执行幽影刃
                    local no_armor = self.no_armor + self.bonus_no_armor*self:GetParent():GetAverageTrueAttackDamage(nil)
				    self:ShadowBlade(keys.attacker,keys.target,no_armor)

                    if self:GetAbility():GetRuneType()==2 then
                        local random = math.random
                        if self:GetAbility():GetSpecialValueFor("rune_2_chance") < random(1,100) then
                            trigger:SetStackCount(trigger:GetStackCount() - self.cost)
                        end
                        self:GetAbility():StartCooldown(self.cd)
                    else
                        trigger:SetStackCount(trigger:GetStackCount() - self.cost)
                        self:GetAbility():StartCooldown(self.cd)
                    end
                end
            end
		end
	end
end

function modifier_chaotic_tri_shadow_blade:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			if self:GetStackCount()==0 then
				local modifier = keys.target:FindAllModifiersByName("modifier_chaotic_tri_shadow_blade_active")
				if #modifier>0 then
					modifier[1]:Destroy()
				end
			end

		end
	end
end

function modifier_chaotic_tri_shadow_blade:ShadowBlade(attacker,target,no_armor)
    if IsServer() then
        local attacker = attacker
        local target = target
        local no_armor = no_armor
        target:AddNewModifier(attacker, self:GetAbility(), "modifier_chaotic_tri_shadow_blade_active", {duration = 0.1,no_armor = no_armor})
        if self:GetAbility():GetRuneType()==3 then
            target:AddNewModifier(attacker, self:GetAbility(), "modifier_chaotic_tri_shadow_blade_rune_3", {duration = self:GetAbility():GetSpecialValueFor("rune_3_duration")})
        end

        self:GetParent():EmitSound("Hero_Spectre.Desolate")
        local particle_cast = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
        local forward = (-target:GetOrigin()+self:GetCaster():GetOrigin()):Normalized()
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW , target )
        ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_CENTER_FOLLOW,nil,Vector(0,0,0),true)
        ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
        ParticleManager:SetParticleControlForward( effect_cast, 0, forward )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end
end
-------------------

modifier_chaotic_tri_shadow_blade_active = advanced_modifier({})

function modifier_chaotic_tri_shadow_blade_active:IsDebuff() return true end
function modifier_chaotic_tri_shadow_blade_active:IsHidden() return true end
function modifier_chaotic_tri_shadow_blade_active:IsPurgable() return false end
function modifier_chaotic_tri_shadow_blade_active:OnCreated(keys)
    if IsServer() then
       self.no_armor = keys.no_armor or 0 
    end
end
function modifier_chaotic_tri_shadow_blade_active:OnRefresh(keys)
    if IsServer() then
       self.no_armor = keys.no_armor or 0 
    end
end

function modifier_chaotic_tri_shadow_blade_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_chaotic_tri_shadow_blade_active:Advanced_GetModifierPhysicalArmorBonus()
    return -self.no_armor
end

-------------------

modifier_chaotic_tri_shadow_blade_rune_3 = advanced_modifier({})

function modifier_chaotic_tri_shadow_blade_rune_3:IsDebuff() return true end
function modifier_chaotic_tri_shadow_blade_rune_3:IsHidden() return true end
function modifier_chaotic_tri_shadow_blade_rune_3:IsPurgable() return false end
function modifier_chaotic_tri_shadow_blade_rune_3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_chaotic_tri_shadow_blade_rune_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self:GetAbility():GetSpecialValueFor("rune_3_outgoing")
end

