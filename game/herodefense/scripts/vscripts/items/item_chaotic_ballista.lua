LinkLuaModifier("modifier_item_chaotic_ballista", "items/item_chaotic_ballista", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_ballista_active", "items/item_chaotic_ballista", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_ballista_weakness", "items/item_chaotic_ballista", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_ballista_count", "items/item_chaotic_ballista", LUA_MODIFIER_MOTION_NONE)
item_chaotic_ballista = class({})

function item_chaotic_ballista:GetIntrinsicModifierName()
    return "modifier_item_chaotic_ballista"
end
function item_chaotic_ballista:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/chaotic_ballista/crush.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/items/chaotic_ballista/stack.vpcf", context )

end
-----------------------------------------------------------------
modifier_item_chaotic_ballista = advanced_modifier({})

function modifier_item_chaotic_ballista:IsDebuff() return false end
function modifier_item_chaotic_ballista:IsHidden() return true end
function modifier_item_chaotic_ballista:IsPurgable() return false end
function modifier_item_chaotic_ballista:RemoveOnDeath() return false end

function modifier_item_chaotic_ballista:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
    self.reward_count = self.ability:GetSpecialValueFor("count")
    self.need_hits = self.ability:GetSpecialValueFor("need")
    self.armor_ignore = self.ability:GetSpecialValueFor("armor_ignore")

    -- 初始化攻击计数
    self.attack_count = 0
    self.last_target = nil
end
function modifier_item_chaotic_ballista:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_DAMAGE_CALCULATED
    }
end
function modifier_item_chaotic_ballista:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil}
    }
end
function modifier_item_chaotic_ballista:Advanced_GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end
function modifier_item_chaotic_ballista:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack
end

function modifier_item_chaotic_ballista:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self.parent then return end
    if attacker:IsInSpecialAttack() then return end
    if target and not target:IsBuilding() and not target:IsOther() then
        -- 锐利目光
        if self.ability:IsCooldownReady() then
            self.ability:UseResources(true, true, true, true)
            for i=0, 1 do
                local modifier_keys = {
                    duration = 0.1,
                    iSpecialAttack = 1,
                    iDisableApplyModifier = 1,
                    iDisableCleave =1,
                    iDisableSplit = 1,
                }
                local attackEffectRecord = self.parent:AddAttackEffectModifier(self.ability,modifier_keys)
                self.parent:PerformAttack(target, false, false, true, false, false, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
                if IsValid(attackEffectRecord) then
                    attackEffectRecord:Destroy()
                end
            end
        end
        if not target:IsAlive() then return end
        -- 处理弱点突破效果
        if self.last_target ~= target then
            self.attack_count = 0
            if IsValid(self.last_target) then
                if self.last_target:IsAlive() then
                    local effect = self.last_target:FindModifierByNameAndCaster("modifier_item_chaotic_ballista_count", attacker)
                    if effect then
                       effect:Destroy() 
                    end
                end
            end
            self.last_target = target
        end
        
        local modifier = target:FindModifierByNameAndCaster("modifier_item_chaotic_ballista_count", attacker)
        if self.attack_count >= self.reward_count+1 then
            self.attack_count = 0
            local particle_cast_fx2 = ParticleManager:CreateParticle("particles/rebuild/items/chaotic_ballista/crush.vpcf", PATTACH_ABSORIGIN, target)
            ParticleManager:SetParticleControl(particle_cast_fx2, 0, target:GetAbsOrigin()+Vector(0,0,364))

            ParticleManager:ReleaseParticleIndex(particle_cast_fx2)
            if modifier then
               modifier:Destroy() 
            end

            target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_ballista_weakness", {duration = 0.1} )
        else
            self.attack_count = self.attack_count + 1
            if not modifier then
                modifier = target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_ballista_count", {})
                modifier:SetStackCount(1)
            else
                modifier:SetStackCount(math.min(self.attack_count, self.reward_count+1))
            end
        end
    end
end

function modifier_item_chaotic_ballista:OnDamageCalculated(keys)
	if IsServer() then
		if keys.attacker == self.parent then
			if self.attack_count == 0 then
				local modifier = keys.target:FindAllModifiersByName("modifier_item_chaotic_ballista_weakness")
				if #modifier>0 then
					modifier[1]:Destroy()
				end
			end
		end
	end
end

-----------------------------------------------------------------
modifier_item_chaotic_ballista_active = advanced_modifier({})

function modifier_item_chaotic_ballista_active:IsDebuff() return false end
function modifier_item_chaotic_ballista_active:IsHidden() return false end
function modifier_item_chaotic_ballista_active:IsPurgable() return false end
-----------------------------------------------------------------
modifier_item_chaotic_ballista_weakness = advanced_modifier({})

function modifier_item_chaotic_ballista_weakness:IsDebuff() return false end
function modifier_item_chaotic_ballista_weakness:IsHidden() return true end
function modifier_item_chaotic_ballista_weakness:IsPurgable() return false end

function modifier_item_chaotic_ballista_weakness:OnCreated(keys)
    self.ability = self:GetAbility()
    self.armor_ignore = self.ability:GetSpecialValueFor("armor_ignore")
end
function modifier_item_chaotic_ballista_weakness:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_chaotic_ballista_weakness:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then self:Destroy() return end
    return -self.armor_ignore
end
----------
modifier_item_chaotic_ballista_count = advanced_modifier({})
function modifier_item_chaotic_ballista_count:IsHidden() return true end
function modifier_item_chaotic_ballista_count:IsPurgable() return false end
function modifier_item_chaotic_ballista_count:OnCreated(params)
	if IsServer() then
		local parent = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/items/chaotic_ballista/stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
		ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self:GetStackCount(),0) )
		self:AddParticle(self.particle, false, false, -1, false, false)
        self:StartIntervalThink(2)
	end
end
function modifier_item_chaotic_ballista_count:OnDestroy()
	if IsServer() then
        if self.particle then
           ParticleManager:DestroyParticle(self.particle, true)
           ParticleManager:ReleaseParticleIndex(self.particle)
        end
	end
end
function modifier_item_chaotic_ballista_count:OnStackCountChanged(old_count)
    if IsServer() and self.particle then
        ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
    end
end
function modifier_item_chaotic_ballista_count:OnIntervalThink()
    if IsServer() then
        if not self:GetAbility() or self:GetStackCount() <= 0 then
            self:Destroy()
        end
    end
end
