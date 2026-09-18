item_hd_goled_gold_effects = class({})
LinkLuaModifier("modifier_item_hd_goled_gold_effects", "player_artifact/item_hd_goled_gold_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_goled_gold_effects_lv100_check", "player_artifact/item_hd_goled_gold_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_goled_gold_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_goled_gold_effects"
end

function item_hd_goled_gold_effects:Precache(context)
    PrecacheResource("particle", "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf", context)
end
modifier_item_hd_goled_gold_effects_lv100_check = advanced_modifier({})

function modifier_item_hd_goled_gold_effects_lv100_check:IsDebuff() return false end
function modifier_item_hd_goled_gold_effects_lv100_check:IsHidden() return true end
function modifier_item_hd_goled_gold_effects_lv100_check:IsPurgable() return false end
function modifier_item_hd_goled_gold_effects_lv100_check:RemoveOnDeath() return false end
function modifier_item_hd_goled_gold_effects_lv100_check:DestroyOnExpire() return false end

modifier_item_hd_goled_gold_effects = advanced_modifier({})

function modifier_item_hd_goled_gold_effects:IsDebuff() return false end
function modifier_item_hd_goled_gold_effects:IsHidden() return self.level < 40 end
function modifier_item_hd_goled_gold_effects:IsPurgable() return false end
function modifier_item_hd_goled_gold_effects:RemoveOnDeath() return false end
function modifier_item_hd_goled_gold_effects:GetTexture() return "item_artifact_70" end
function modifier_item_hd_goled_gold_effects:DestroyOnExpire() return false end

function modifier_item_hd_goled_gold_effects:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.move_speed = self.ability:GetArtifactSpecialValueFor("move_speed")
    self.gold = self.ability:GetArtifactSpecialValueFor("gold")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_goled_gold_effects")

    self.gold_1 = self.ability:GetArtifactSpecialValueFor("gold_1")
    self.gold_bonus_2 = self.ability:GetArtifactSpecialValueFor("gold_bonus_2")
    self.gold_3 = self.ability:GetArtifactSpecialValueFor("gold_3")
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.down_4 = self.ability:GetArtifactSpecialValueFor("down_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.gold_10 = self.ability:GetArtifactSpecialValueFor("gold_10")

    if self.level >= 10 then
        self.gold = self.gold_1
    end
    if self.level >= 30 then
        self.gold = self.gold_3
        self.chance = self.chance_3
    end
    if self.level >= 70 then
       self.chance = self.chance_7 
    end
    if self.level >= 100 then
        if IsServer() then
            if self.parent:IsAlive() and not self.parent:HasModifier("modifier_item_hd_goled_gold_effects_lv100_check") then
                chaotic_era_spawner:PlayerGetGoldBounty(self.parent, self.gold_10, self.ability)
                SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_GOLD  ,self.parent, self.gold_10, nil)
                self:PlayEffect(self.parent)
                self.parent:AddNewModifier(self.parent, nil, "modifier_item_hd_goled_gold_effects_lv100_check", {})
            end
        end
    end
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_goled_gold_effects:OnRefresh()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.move_speed = self.ability:GetArtifactSpecialValueFor("move_speed")
    self.gold = self.ability:GetArtifactSpecialValueFor("gold")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_goled_gold_effects")

    self.gold_1 = self.ability:GetArtifactSpecialValueFor("gold_1")
    self.gold_bonus_2 = self.ability:GetArtifactSpecialValueFor("gold_bonus_2")
    self.gold_3 = self.ability:GetArtifactSpecialValueFor("gold_3")
    self.chance_3 = self.ability:GetArtifactSpecialValueFor("chance_3")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.index_4 = self.ability:GetArtifactSpecialValueFor("index_4")*0.01
    self.down_4 = self.ability:GetArtifactSpecialValueFor("down_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    if self.level >= 10 then
        self.gold = self.gold_1
    end
    if self.level >= 30 then
        self.gold = self.gold_3
        self.chance = self.chance_3
    end
    if self.level >= 70 then
        self.chance = self.chance_7 
     end
end

function modifier_item_hd_goled_gold_effects:OnIntervalThink()
    if self.level >= 40 then
        self:SetStackCount(math.min(self:GetStackCount()+1, self.interval_4))
        if self:GetStackCount() >= self.interval_4 then
            self:GiveGold()
            self:SetStackCount(0)
        end
    end
end

function modifier_item_hd_goled_gold_effects:GiveGold()
    if not IsServer() then return end
    local parent = self:GetParent()
    local bonus =  math.floor(parent:GetGold()*self.index_4)
        
    if bonus and bonus > 0 then
        chaotic_era_spawner:PlayerGetGoldBounty(parent,math.min(bonus,2500),self:GetAbility())
        SendOverheadEventMessage(parent, OVERHEAD_ALERT_GOLD  ,parent, bonus, nil)
        self:PlayEffect(parent)
    end
end

function modifier_item_hd_goled_gold_effects:ADDeclareFunctions()
    return {
        --advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus
    }
end

function modifier_item_hd_goled_gold_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_hd_goled_gold_effects:GetModifierMoveSpeedBonus_Constant()
    return self.move_speed
end

function modifier_item_hd_goled_gold_effects:Advanced_GetChaotic_Era_BountyBonus()
    if self.level < 20 then return 0 end
    return self.gold_bonus_2
end

function modifier_item_hd_goled_gold_effects:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		local parent = self:GetParent()
		if attacker and attacker:GetPlayerOwnerID() == parent:GetPlayerOwnerID() and IsEnemy(unit,attacker) then
			local nPlayerID = attacker:GetPlayerOwnerID()
			local bonus = self.gold
			local random = math.random
			if self.chance*5>=random(1, 1000) then
                if self.level < 70 then
				    parent:AddItemByName("item_chaotic_gold_bag")
                else
                    chaotic_era_spawner:PlayerGetGoldBounty(parent,400,self:GetAbility())
                    SendOverheadEventMessage(parent, OVERHEAD_ALERT_GOLD  ,parent, 400, nil)
                    self:PlayEffect(parent) 
                end
			end

			chaotic_era_spawner:PlayerGetGoldBounty(attacker,bonus,self:GetAbility()) 
			SendOverheadEventMessage( PlayerResource:GetPlayer(nPlayerID), OVERHEAD_ALERT_GOLD  ,attacker, bonus, nil)
			self:PlayEffect(unit)

            if self.level >= 40 then
                self:SetStackCount(math.min(self:GetStackCount()+1, self.interval_4))
                if self:GetStackCount() >= self.interval_4 then
                    self:GiveGold()
                    self:SetStackCount(0)
                end
            end
		end
	end
end

function modifier_item_hd_goled_gold_effects:PlayEffect(target)
	local particle_cast = "particles/econ/events/newbloom_2020/high_five_newbloom_golden.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,1.5)
end
