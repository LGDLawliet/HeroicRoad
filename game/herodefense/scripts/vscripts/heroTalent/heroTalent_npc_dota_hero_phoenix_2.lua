heroTalent_npc_dota_hero_phoenix_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phoenix_2", "heroTalent/heroTalent_npc_dota_hero_phoenix_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phoenix_2_buff", "heroTalent/heroTalent_npc_dota_hero_phoenix_2", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_phoenix_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/fall_2022/bottle/bottle_fall2022.vpcf", context )

end
function heroTalent_npc_dota_hero_phoenix_2:Spawn()
	if IsClient() then
		return
	end
    local heroes = GetAllRealHeroes()
    for  _, hero in pairs(heroes) do
        if hero:IsRealHero() then
			hero:AddNewModifier(hero, self, "modifier_heroTalent_npc_dota_hero_phoenix_2", {})
        end
    end
end


modifier_heroTalent_npc_dota_hero_phoenix_2 = class({})

function modifier_heroTalent_npc_dota_hero_phoenix_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2:DestroyOnExpire() return false end
-- function heroTalent_npc_dota_hero_phoenix_2:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_phoenix_2:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent.hd_bottle_water==nil then
			parent.hd_bottle_water = 1
		end
		parent.hd_bottle_water = parent.hd_bottle_water +0.7
		self:StartIntervalThink(0.1)
	end
end


function modifier_heroTalent_npc_dota_hero_phoenix_2:OnIntervalThink()
	-- local ability = self:GetAbility()
	if self:GetRemainingTime()<=0  then
		local parent = self:GetParent()
		local item = parent:FindItemInInventory("item_new_bottle")
		if item ~=nil then
			local charge = item:GetCurrentCharges()
			if charge<item:GetBottleMaxCharge() then
				item:SetCurrentCharges(charge+1)
				self:SetDuration(30, true)
				parent:EmitSound("Hero_Phoenix.FireSpirits.Launch")

				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, parent )
				ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector(128,0,0))
				ParticleManager:ReleaseParticleIndex( effect_cast )
				-- particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf
			end

		end
	end
	

end






modifier_heroTalent_npc_dota_hero_phoenix_2_buff =modifier_heroTalent_npc_dota_hero_phoenix_2_buff or  class({})

function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:GetModifierBonusStats_Agility()	return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:GetModifierBonusStats_Strength()	return self:GetStackCount() end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:OnCreated(params)
	-- self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:SetStackCount(5)
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 50 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else

			table.insert(self.tData, {dieTime = dieTime })
			self:SetStackCount(self:GetStackCount()+5)
		end
	end
end

function modifier_heroTalent_npc_dota_hero_phoenix_2_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:SetStackCount(self:GetStackCount()-5)
			end
		end
	end
end

