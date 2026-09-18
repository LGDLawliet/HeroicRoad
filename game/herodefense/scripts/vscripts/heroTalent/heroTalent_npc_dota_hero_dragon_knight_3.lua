heroTalent_npc_dota_hero_dragon_knight_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dragon_knight_3", "heroTalent/heroTalent_npc_dota_hero_dragon_knight_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_dragon_knight_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dragon_knight_3"
end

function heroTalent_npc_dota_hero_dragon_knight_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"elder_dragon_form_ice",costKeys)
			end
		end)
	end
end

function heroTalent_npc_dota_hero_dragon_knight_3:OnHeroLevelUp()
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_dragon_knight_3")
	if modifier then
		modifier:LevelUpGain()
	end
end

modifier_heroTalent_npc_dota_hero_dragon_knight_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_dragon_knight_3:OnCreated(table)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

	self.base_int = self.ability:GetSpecialValueFor("base_int")
	self.int_grow = self.ability:GetSpecialValueFor("int_grow")
    self.magic_res = self.ability:GetSpecialValueFor("magic_res")
    self.magic_res_max = self.ability:GetSpecialValueFor("magic_res_max")
    self.level = self.ability:GetSpecialValueFor("level")
    self.level2 = self.ability:GetSpecialValueFor("level2")

    self.check = nil
    self.check2 = nil
    if IsServer() then
	    local level = self.parent:GetLevel()-1
	    self.parent:SetBaseIntellect(self.base_int + level*self.int_grow)
        self:StartIntervalThink(1)
    end
end

function modifier_heroTalent_npc_dota_hero_dragon_knight_3:LevelUpGain()
    if not IsServer() then return end
	local int_gain = self.parent:GetIntellectGain()
	self.parent:SetBaseIntellect(self.parent:GetBaseIntellect() + (self.int_grow-int_gain))
end

function modifier_heroTalent_npc_dota_hero_dragon_knight_3:DeclareFunctions()
	return{
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_heroTalent_npc_dota_hero_dragon_knight_3:OnTooltip()
	return self:GetModifierMagicalResistanceBonus()
end

function modifier_heroTalent_npc_dota_hero_dragon_knight_3:GetModifierMagicalResistanceBonus()
    local str = self.parent:GetStrength()
    local magic_res = math.min(math.floor(str/10)*self.magic_res, self.magic_res_max)
	return magic_res
end

function modifier_heroTalent_npc_dota_hero_dragon_knight_3:OnIntervalThink()
    if not self.parent:IsAlive() then return end
    
    if not self.check then
        if self.parent:GetLevel() >= self.level then
            self.check = true
        end
    end

    if not self.check2 then
        if self.parent:GetLevel() >= self.level2 then
            self.check2 = true
        end
    end

    if self.check then
        local ability = self.parent:FindAbilityByName("Primary_elder_dragon_form_ice") or self.parent:FindAbilityByName("Middle_elder_dragon_form_ice") or self.parent:FindAbilityByName("Advanced_elder_dragon_form_ice")
        local modifier = self.parent:FindModifierByName(self.parent.Form_MODIFIER_NAME)
        if ability and not modifier then
            ability:OnSpellStart()
        end
    end
end
