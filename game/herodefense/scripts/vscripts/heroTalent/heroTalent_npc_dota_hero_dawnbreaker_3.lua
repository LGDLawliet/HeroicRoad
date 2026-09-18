heroTalent_npc_dota_hero_dawnbreaker_3 =  heroTalent_npc_dota_hero_dawnbreaker_3 or class({})

LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_dawnbreaker_3", "heroTalent/heroTalent_npc_dota_hero_dawnbreaker_3", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_dawnbreaker_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_dawnbreaker_3"
end
-- function heroTalent_npc_dota_hero_dawnbreaker_3:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/talent/dawnbreaker_3/effect/rebuild/spell/einherjar/einherjar_guardian.vpcf", context )


-- end
function heroTalent_npc_dota_hero_dawnbreaker_3:GetStarbreaker()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Starbreaker")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Starbreaker")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Starbreaker")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_Starbreaker")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_Starbreaker")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_Starbreaker")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end
function heroTalent_npc_dota_hero_dawnbreaker_3:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Starbreaker",costKeys)


			end
		end)
	
	end

end


modifier_heroTalent_npc_dota_hero_dawnbreaker_3 = class({})

function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.hero =  self:GetParent()
		self:GetAbility():StartCooldown(10)
		self:StartIntervalThink(0)
		self.draw = false
		self.modelName = self.hero:GetModelName()
        local model = self.hero:FirstMoveChild()
        -- self.modelName = self.hero:GetModelName()
        self.model = {}
        local index = 0
        while model ~= nil do
            if model:GetClassname() == "dota_item_wearable" then
                index = index + 1
                if index==3 then
                    self.lastModel = model
                    break
                end
                
            end
            model = model:NextMovePeer()
        end
        if self.lastModel then

            for i = 1, 8, 1 do
                local newModel = GameRules:AttachWearableWithScale(self.hero, "models/rebuild/dawnbreaker/weapon_judgment_of_light/single_model_judgment_of_light.vmdl",nil,2)
                table.insert(self.model,newModel)
                newModel:AddEffects(EF_NODRAW)
            end

            -- self.model
            
        end
	
	end
end
--由于这个模型是主动创建 所以单位变身时候需要把这个模型隐藏
function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:OnIntervalThink()
	if self.draw then

		local pos = self.lastModel:GetAbsOrigin()
		local angle = self.lastModel:GetAngles()


        for i, model in ipairs(self.model) do
            model:RemoveEffects(EF_NODRAW)
            model:SetAngles(angle.x+i*36, angle.y+i*36, angle.z)
            model:SetAbsOrigin(pos)
        end
	end
	if self.modelName~=self.hero:GetModelName() then
        for _, model in ipairs(self.model) do
            model:AddEffects(EF_NODRAW)
        end
		
	end
	if self:GetParent():PassivesDisabled() then
		self.draw = false
	else
		self.draw = true
	end
	-- local ability = self:GetAbility()
	-- local cooldown = ability:GetCooldownTimeRemaining()
	-- if cooldown<=6 then
	-- 	self.draw = true
	-- 	self:SetStackCount(_G.GAME_ROUND)
	-- end
end

function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end



function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:OnAttackLanded(keys)
	self.chance= self:GetAbility():GetSpecialValueFor("chance")
	if IsServer() then
		-- if not self:GetParent():IsRealHero() then
		-- 	return false
		-- end
		if keys.attacker==self:GetParent() then
            if not keys.attacker:IsApplyModifier() then
                return
            end
            if keys.attacker:IsInSpecialAttack() then
                return
            end
			local ability = self:GetAbility()
			-- local cooldown = ability:GetCooldownTimeRemaining()
			local pass = false
			if  ability:IsCooldownReady() then
				ability:UseResources(true, true, true, true)
				pass = true
			else
				if keys.attacker:GetRandomEffect(self.chance,INT_TYPE,1)  > RandomInt(1, 100) then
					pass = true
				end
			end
			if pass then
				local Starbreaker = ability:GetStarbreaker()
                if Starbreaker then
                    Starbreaker:TalentEffect(keys.unit or keys.attacker)
					
                end
			end
		end
	end
end










-- function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:OnCreated(keys)
-- 	if IsServer() then
-- 		if not self:GetParent():IsRealHero() then
-- 			return false
-- 		end
-- 		-- self.hero =  self:GetParent()
-- 		-- self:GetAbility():StartCooldown(10)
-- 		-- self:StartIntervalThink(0)
-- 		-- self.draw = false
-- 		-- self.modelName = self.hero:GetModelName()
--         local model = self:GetParent():FirstMoveChild()
--         -- self.modelName = self.hero:GetModelName()
--         local index = 0
--         while model ~= nil do
--             if model:GetClassname() == "dota_item_wearable" then
--                 print(model)
--                 print(model:GetModelName())
--                 index = index + 1
--                 -- 武器是3
--                 if index==3 then
                    
--                     model:SetModel("models/rebuild/dawnbreaker/weapon_judgment_of_light/single_model_judgment_of_light.vmdl")
--                     self.lastModel = model
--                     print("ok")
--                     break
--                 end
                
--             end
--             model = model:NextMovePeer()
--         end
--         self.index = 1
--         self:StartIntervalThink(1)
	
-- 	end
-- end



-- function modifier_heroTalent_npc_dota_hero_dawnbreaker_3:OnIntervalThink()
--     print(self.lastModel)
--     print(self.lastModel:GetModelName())

--     if self.index==1 then
--         self.index = 0
--         self.lastModel:RemoveEffects(EF_NODRAW)
--     else
--         self.index = 1
--         self.lastModel:AddEffects(EF_NODRAW)
--     end
-- end



