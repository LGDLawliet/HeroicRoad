heroTalent_npc_dota_hero_sand_king = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_sand_king", "heroTalent/heroTalent_npc_dota_hero_sand_king", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_sand_king:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_sand_king:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_sand_king:IsStealable() 				return true end
function heroTalent_npc_dota_hero_sand_king:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_sand_king:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_sand_king" end


function heroTalent_npc_dota_hero_sand_king:AddCount()
    self.achievement_count =  self.achievement_count+  1
end



function heroTalent_npc_dota_hero_sand_king:OnCustomDataSettlement()
	-- if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomDataWithValue("mobile_earthquake_source_1",self.achievement_count)
		end
	-- end

end
function heroTalent_npc_dota_hero_sand_king:Spawn()
    self.achievement_count = 0
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 750,
					to_level2_cost = 1500,
					to_level3_cost = 2200,
					upgrade_cost = 750,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Epicenter",costKeys)
			end
		end)
	
	end

end

modifier_heroTalent_npc_dota_hero_sand_king = class({})

function modifier_heroTalent_npc_dota_hero_sand_king:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_sand_king:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_sand_king:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_sand_king:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sand_king:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_sand_king:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        local interval = 0.85
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"mobile_earthquake_source_1") then
			-- print("获得奖励")
			interval = 0.8
		end
        self:StartIntervalThink(interval)     

    end
end
function modifier_heroTalent_npc_dota_hero_sand_king:OnIntervalThink()
    if self.parent:HasModifier("modifier_Advanced_Epicenter_unlock3") then
        return
    end
    local ability = self.parent:FindAbilityByName("Advanced_Epicenter")
    if not ability then
        ability = self.parent:FindAbilityByName("Middle_Epicenter")
        if not ability then
            ability = self.parent:FindAbilityByName("Primary_Epicenter")
            if not ability then
                return
            end
        end
    end

    self.dis =self.dis+ CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    self.currentPos = self.parent:GetAbsOrigin()
    if self.dis>=700 then
        local selfAbility = self:GetAbility()
        local cooldown = selfAbility:GetCooldownTimeRemaining()
       
        if cooldown>=10 then
            return
        end
        selfAbility:StartCooldown(cooldown+selfAbility:GetCooldown(selfAbility:GetLevel())* self:GetParent():GetCooldownReduction() )
        self.dis = 0
        ability:SandKingEffect()
        selfAbility:AddCount()
    end
end
