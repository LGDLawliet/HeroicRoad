-- 重做完成
item_hd_douqi_effects = class({})
LinkLuaModifier("modifier_item_hd_douqi_effects", "player_artifact/item_hd_douqi_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_douqi_effects_buff1", "player_artifact/item_hd_douqi_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_douqi_effects_buffcheck", "player_artifact/item_hd_douqi_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_douqi_effects_cd", "player_artifact/item_hd_douqi_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_douqi_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_douqi_effects"
end

function item_hd_douqi_effects:Precache( context )
	PrecacheResource( "particle", "particles/chakra_status/main.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_era/item_hd_douqi_effects/lightning.vpcf", context )
end

modifier_item_hd_douqi_effects = advanced_modifier({})

function modifier_item_hd_douqi_effects:IsDebuff() return false end
function modifier_item_hd_douqi_effects:IsHidden() return true end
function modifier_item_hd_douqi_effects:IsPurgable() return false end
function modifier_item_hd_douqi_effects:RemoveOnDeath() return false end
function modifier_item_hd_douqi_effects:DestroyOnExpire() return false end
function modifier_item_hd_douqi_effects:GetTexture() return "item_artifact_13" end

function modifier_item_hd_douqi_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_steal = self.ability:GetArtifactSpecialValueFor("bonus_spell_steal")*0.01
    self.stack = self.ability:GetArtifactSpecialValueFor("stack")
    self.stack_max = self.ability:GetArtifactSpecialValueFor("stack_max")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.phy_outgoing = self.ability:GetArtifactSpecialValueFor("phy_outgoing")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")

    self.douqi = 0

    self.cdback_1 = self.ability:GetArtifactSpecialValueFor("cdback_1")
    self.stack_max_1 = self.ability:GetArtifactSpecialValueFor("stack_max_1")
    self.chance_max_2 = self.ability:GetArtifactSpecialValueFor("chance_max_2")
    self.phy_outgoing_2 = self.ability:GetArtifactSpecialValueFor("phy_outgoing_2")
    self.cost_back_2 = self.ability:GetArtifactSpecialValueFor("cost_back_2")
    self.stack_max_3 = self.ability:GetArtifactSpecialValueFor("stack_max_3")
    self.stack_4 = self.ability:GetArtifactSpecialValueFor("stack_4")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.outoging_10 = self.ability:GetArtifactSpecialValueFor("outoging_10")
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")

    if self.level >= 10 then
        self.stack_max = self.stack_max_1
    end
    if self.level >= 20 then
        self.phy_outgoing = self.phy_outgoing_2
    end
    if self.level >= 30 then
        self.stack_max = self.stack_max_3
    end
    if self.level >= 70 then
        if not IsServer() then return end
        if self:GetParent():GetLevel() < 24 then return end
        if self:GetParent():HasAbility("chaotic_physkill_master") then return end
        if not self.checkingAbility then
			local parent = self:GetParent()
			local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
			if not parent:IsAlive() then
                return
            end
            if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
				return
			end
			self.checkingAbility = true
			if parent:HasModifier("chaotic_physkill_master") then
				return
			end
			chaotic_era:LearnChaoticEraSpell(parent,"chaotic_physkill_master")
		end
    end
end

function modifier_item_hd_douqi_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.bonus_spell_steal = self.ability:GetArtifactSpecialValueFor("bonus_spell_steal")*0.01
    self.stack = self.ability:GetArtifactSpecialValueFor("stack")
    self.stack_max = self.ability:GetArtifactSpecialValueFor("stack_max")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.phy_outgoing = self.ability:GetArtifactSpecialValueFor("phy_outgoing")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")

    if not self.douqi then
        self.douqi = 0
    end

    self.cdback_1 = self.ability:GetArtifactSpecialValueFor("cdback_1")
    self.stack_max_1 = self.ability:GetArtifactSpecialValueFor("stack_max_1")
    self.chance_max_2 = self.ability:GetArtifactSpecialValueFor("chance_max_2")
    self.phy_outgoing_2 = self.ability:GetArtifactSpecialValueFor("phy_outgoing_2")
    self.cost_back_2 = self.ability:GetArtifactSpecialValueFor("cost_back_2")
    self.stack_max_3 = self.ability:GetArtifactSpecialValueFor("stack_max_3")
    self.stack_4 = self.ability:GetArtifactSpecialValueFor("stack_4")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.outoging_10 = self.ability:GetArtifactSpecialValueFor("outoging_10")
    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_douqi_effects")

    if self.level >= 10 then
        self.stack_max = self.stack_max_1
    end
    if self.level >= 20 then
        self.phy_outgoing = self.phy_outgoing_2
    end
    if self.level >= 30 then
        self.stack_max = self.stack_max_3
    end
end

function modifier_item_hd_douqi_effects:ADDeclareFunctions()
    return{

        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
end

function modifier_item_hd_douqi_effects:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_item_hd_douqi_effects:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then return end
    
    if self.level < 40 then
        return
    end
    local cd = attacker:FindModifierByName("modifier_item_hd_douqi_effects_cd")
    if cd then
        return
    end

    self:GetDouqi(self.stack_4)
    attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_item_hd_douqi_effects_cd", {duration=self.interval_4})
end

function modifier_item_hd_douqi_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then return end

    if self.level < 10 then
        return
    end

    local step = attacker:FindAbilityByName("chaotic_step")
    local aura = attacker:FindAbilityByName("chaotic_area")
    if step and not step:IsCooldownReady() then
        local newcooldown = step:GetCooldownTimeRemaining() - self.cdback_1
        step:EndCooldown()
        step:StartCooldown(newcooldown)
    end
    if aura and not aura:IsCooldownReady() then
        local newcooldown = aura:GetCooldownTimeRemaining() - self.cdback_1
        aura:EndCooldown()
        aura:StartCooldown(newcooldown)
    end
    
end

function modifier_item_hd_douqi_effects:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		local parent = self:GetParent()
        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.bonus_spell_steal*life_steal_gain
            hp = hp-hp%1
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            parent:Heal(hp, self.ability)
        end 
    end 
end

function modifier_item_hd_douqi_effects:OnAbilityExecuted(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    local unit = keys.unit
    local ability = keys.ability
    if not unit or not ability then return end
    local move = unit:FindAbilityByName("Default_Move")
    local step = unit:FindAbilityByName("chaotic_step")
    local aura = unit:FindAbilityByName("chaotic_area")
    local evasion = unit:FindAbilityByName("chaotic_protection_of_dodge")

    local stack = self.stack
    if ability == step or aura or evasion or move then
       self:GetDouqi(stack) 
    end
end

function modifier_item_hd_douqi_effects:GetDouqi(stack)
    if not IsServer() then return end

    local max = self.stack_max

    local bonus = stack
    if self.level >= 20 and bonus < 0 then
        if self.level >= 30 then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_douqi_effects_buffcheck", {stack = -bonus})
        end
        local random = math.random
        local chance = self.chance_max_2*(-bonus)
        if chance >= random(1,100) then
            bonus = bonus + self.cost_back_2
        end
    end
    self.douqi = math.min(math.max(self.douqi + bonus , 0),max)

    if not self.particle then
        self.particle = ParticleManager:CreateParticle("particles/chakra_status/main.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControl( self.particle, 1, Vector(max,self.douqi,0) )
	    self:AddParticle(self.particle, false, false, -1, false, false)
    else
        ParticleManager:SetParticleControl( self.particle, 1, Vector(max,self.douqi,0) )
    end
end

function modifier_item_hd_douqi_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return
	end
	if keys.attacker~=self:GetParent() then
		return
	end
    if not keys.inflictor then 
        return 
    end
	if keys.inflictor:GetChaoticSpellType() ~= "EraListSubdivision_checking_Skill" then
		return
	end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK  then
		return
    end
	if self.douqi <= 0 then
       return 
    end
    
    local attacker = keys.attacker
    local target = keys.target
    local phy_outgoing = self.phy_outgoing*self.douqi
    local duration = self.duration
    if self.level >= 100 and target:HasModifier("modifier_hd_elecshocking") then
        phy_outgoing = phy_outgoing + self.outoging_10
    end

    local buff1 = attacker:FindModifierByName("modifier_item_hd_douqi_effects_buff1")
    if buff1 and buff1:GetStackCount() > phy_outgoing then
        self:GetDouqi(-self.douqi)
        return 
    end
    
    attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_item_hd_douqi_effects_buff1", {duration=duration, outgoing = phy_outgoing})
    self:GetDouqi(-self.douqi)

	return phy_outgoing
end



-------------------
modifier_item_hd_douqi_effects_buff1 = advanced_modifier({})

function modifier_item_hd_douqi_effects_buff1:IsDebuff() return false end
function modifier_item_hd_douqi_effects_buff1:IsHidden() return false end
function modifier_item_hd_douqi_effects_buff1:IsPurgable() return false end
function modifier_item_hd_douqi_effects_buff1:GetTexture() return "item_artifact_13" end
function modifier_item_hd_douqi_effects_buff1:OnCreated(keys)
    if IsServer() then
        self.outgoing = keys.outgoing 
        self:SetStackCount(self.outgoing)

        local particle = "particles/rebuild/chaotic_era/item_hd_douqi_effects/lightning.vpcf"
        if not self.pfx then
            self.pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_CENTER_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
		    self:AddParticle(self.pfx, false, false, 15, false, false)
        end
    end
end

function modifier_item_hd_douqi_effects_buff1:OnRefresh(keys)
    if IsServer() then
        self.outgoing = keys.outgoing 
        self:SetStackCount(self.outgoing)

        local particle = "particles/rebuild/chaotic_era/item_hd_douqi_effects/lightning.vpcf"
        if not self.pfx then
            self.pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_CENTER_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
		    self:AddParticle(self.pfx, false, false, 15, false, false)
        end
    end
end
function modifier_item_hd_douqi_effects_buff1:OnDestroy()
    if not IsServer() then return end
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx, false)
    end
end
function modifier_item_hd_douqi_effects_buff1:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_item_hd_douqi_effects_buff1:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return
	end

	if keys.attacker~=self:GetParent() then
		return
	end

	if keys.ability and keys.ability:GetChaoticSpellType() ~= "EraListSubdivision_checking_Skill" then
		return
	end

	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK  then
		return
    end


	return self:GetStackCount()
end

----------------------------------------------
modifier_item_hd_douqi_effects_buffcheck = advanced_modifier({})

function modifier_item_hd_douqi_effects_buffcheck:IsDebuff()			return false end
function modifier_item_hd_douqi_effects_buffcheck:IsHidden() 			return false end
function modifier_item_hd_douqi_effects_buffcheck:IsPurgable() 		return false end
function modifier_item_hd_douqi_effects_buffcheck:IsPurgeException() 	return false end
function modifier_item_hd_douqi_effects_buffcheck:GetTexture() return "item_artifact_13" end

function modifier_item_hd_douqi_effects_buffcheck:OnCreated(keys)
    self.duration = self:GetAbility():GetArtifactSpecialValueFor("time_3")
    self.cost_3 = self:GetAbility():GetArtifactSpecialValueFor("cost_3")
	if IsServer() then
		self:SetStackCount(keys.stack)

        if self:GetStackCount() >= self.cost_3 then
            local time_cleave = self:GetParent():FindAbilityByName("chaotic_time_cleave")
            if time_cleave and not time_cleave:IsCooldownReady() then
                time_cleave:EndCooldown()
            end

            local getsuga_tenshou = self:GetParent():FindAbilityByName("chaotic_getsuga_tenshou")
            if getsuga_tenshou and not getsuga_tenshou:IsCooldownReady() then
                getsuga_tenshou:EndCooldown()
            end
            self:SafeDestroy() 
        end

		self:StartIntervalThink(self.duration)
	end
end

function modifier_item_hd_douqi_effects_buffcheck:OnRefresh(keys)
    self.duration = self:GetAbility():GetArtifactSpecialValueFor("time_3")
    self.cost_3 = self:GetAbility():GetArtifactSpecialValueFor("cost_3")
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

        if self:GetStackCount() >= self.cost_3 then
            local time_cleave = self:GetParent():FindAbilityByName("chaotic_time_cleave")
            if time_cleave and not time_cleave:IsCooldownReady() then
                time_cleave:EndCooldown()
            end

            local getsuga_tenshou = self:GetParent():FindAbilityByName("chaotic_getsuga_tenshou")
            if getsuga_tenshou and not getsuga_tenshou:IsCooldownReady() then
                getsuga_tenshou:EndCooldown()
            end
            self:SafeDestroy() 
        end
	end
end

function modifier_item_hd_douqi_effects_buffcheck:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end

    if self:GetStackCount() >= self.cost_3 then
        if self:GetStackCount() >= self.cost_3 then
            local time_cleave = self:GetParent():FindAbilityByName("chaotic_time_cleave")
            if time_cleave and not time_cleave:IsCooldownReady() then
                time_cleave:EndCooldown()
            end

            local getsuga_tenshou = self:GetParent():FindAbilityByName("chaotic_getsuga_tenshou")
            if getsuga_tenshou and not getsuga_tenshou:IsCooldownReady() then
                getsuga_tenshou:EndCooldown()
            end
            self:SafeDestroy() 
        end
    end

	self:SafeDestroy()
end




modifier_item_hd_douqi_effects_cd = advanced_modifier({})

function modifier_item_hd_douqi_effects_cd:IsDebuff() return true end
function modifier_item_hd_douqi_effects_cd:IsHidden() return true end
function modifier_item_hd_douqi_effects_cd:IsPurgable() return false end
