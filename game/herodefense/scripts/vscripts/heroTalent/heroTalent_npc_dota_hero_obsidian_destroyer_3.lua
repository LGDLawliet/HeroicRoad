--
heroTalent_npc_dota_hero_obsidian_destroyer_3 = heroTalent_npc_dota_hero_obsidian_destroyer_3 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer_3", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_obsidian_destroyer_3:Spawn()
	self.bonusDamage = {}
	self.bonusDamage["Advanced_astral_imprisonment"] = 0.3
	self.bonusDamage["Middle_astral_imprisonment"] = 0.2
	self.bonusDamage["Primary_astral_imprisonment"] = 0.1
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
				skillshop:LearnTalentDefaultAbility(caster,"astral_imprisonment",costKeys)

			end
		end)
	
	end
end
function heroTalent_npc_dota_hero_obsidian_destroyer_3:GetBonusDamage(abilityName)
	return self.bonusDamage[abilityName] * self:GetCaster():GetMaxMana()
end
function heroTalent_npc_dota_hero_obsidian_destroyer_3:GetIntrinsicModifierName(abilityName)
	return "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive"
end






modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive = class({})

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3_passive:GetModifierManaBonus()
	if not IsServer() then
		return 
	end

	local ability = self:GetCaster():FindAbilityByName("Primary_astral_imprisonment")
	local ability2 = self:GetCaster():FindAbilityByName("Middle_astral_imprisonment")
	local ability3 = self:GetCaster():FindAbilityByName("Advanced_astral_imprisonment")
	local bonusMana = 0
	if ability then
		bonusMana = 800
	end
	if ability2 then
		bonusMana = 1600
	end
	if ability3 then
		bonusMana = 3000
	end
	
	return bonusMana
end




modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3 = class({})

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:GetModifierManaBonus()


	return mana + bonusMana
end


function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
		local stack = self:GetStackCount()
		if (stack-self.tData[1].stack)>20000 then
			self:SetStackCount(self:GetStackCount()-self.tData[1].stack)
			table.remove(self.tData, 1)
		end

	end
end

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_3:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end