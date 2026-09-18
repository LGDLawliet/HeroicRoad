heroTalent_npc_dota_hero_bounty_hunter = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip", "heroTalent/heroTalent_npc_dota_hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bounty_hunter", "heroTalent/heroTalent_npc_dota_hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_bounty_hunter:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", context )
end
function heroTalent_npc_dota_hero_bounty_hunter:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip"
end

function heroTalent_npc_dota_hero_bounty_hunter:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	self.gold_max = self:GetSpecialValueFor("gold_max")
	self.bonus_gold_max = self:GetSpecialValueFor("bonus_gold_max")
	self.talentgain = self:GetTalentGain(0.5)
	self.gold_max_t = self.gold_max * self.talentgain
	self.bonus_gold_max_t = self.bonus_gold_max * self.talentgain

	local buff = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_bounty_hunter")
	if buff then
		buff:Destroy()
	end
	local newbuff = target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_bounty_hunter", {duration = self:GetSpecialValueFor("duration")})
	local current_wave = GetWave()
	local gold_max = self.gold_max_t + self.bonus_gold_max_t*current_wave
	newbuff:SetStackCount(math.floor(gold_max))

	self:SetActivated(false)
end
modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.gold_max = self.ability:GetSpecialValueFor("gold_max")
	self.bonus_gold_max = self.ability:GetSpecialValueFor("bonus_gold_max")
	self.talentgain = self.ability:GetTalentGain(0.5)
	self.gold_max_t = self.gold_max * self.talentgain
	self.bonus_gold_max_t = self.bonus_gold_max * self.talentgain

	if not IsServer() then return end
	self:SetStackCount(GetWave())
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:OnWaveStart()
	if not IsServer() then return end
	if Game_State:IsInChaoticEra() then return end
	self:SetStackCount(GetWave())
    self:GetAbility():SetActivated(true)
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:OnChaoticEraRoundChange(keys)
	if not IsServer() then return end
	if not Game_State:IsInChaoticEra() then return end
	self:SetStackCount(GetWave())
    self:GetAbility():SetActivated(true)
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter_tooltip:OnTooltip()
	self.gold_max = self.ability:GetSpecialValueFor("gold_max")
	self.bonus_gold_max = self.ability:GetSpecialValueFor("bonus_gold_max")
	self.talentgain = self.ability:GetTalentGain(0.5)
	self.gold_max_t = self.gold_max * self.talentgain
	self.bonus_gold_max_t = self.bonus_gold_max * self.talentgain
	local current_wave = self:GetStackCount()

	self._tooltip = (self._tooltip or 0) % 1 + 1
    if self._tooltip == 1 then
        return math.floor(self.gold_max_t + self.bonus_gold_max_t*current_wave)
    end
end
modifier_heroTalent_npc_dota_hero_bounty_hunter = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bounty_hunter:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.gold = self.ability:GetSpecialValueFor("gold")*0.01
	self.gold_ally = self.ability:GetSpecialValueFor("give_ally")*0.01

	self.give_parent = 0
	self.give_caster = 0
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
    }
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:OnTakeDamage(tg)
    if IsServer() then   
		local attacker = tg.attacker	
		local unit = tg.unit
		if attacker ~= self.parent then return end
		if not IsEnemy(unit, attacker) then return end
		-- 没有余额了就直接结算
		if self:GetStackCount() <= 0 then self:Destroy() return end
		-- 有余额造成伤害就记录金币，先不分配
		local gold = math.min(math.floor(tg.damage*self.gold), self:GetStackCount())
		if gold <= 0 then return end
		-- 存储造成伤害时获取的金币，事先分配好
		local gold_ally = math.floor(gold*self.gold_ally)
		local gold_self = gold - gold_ally
		self.give_parent = self.give_parent + gold_ally
		self.give_caster = self.give_caster + gold_self
		-- print("总金币"..gold.."，友军已累计"..self.give_parent.."自己累计"..self.give_caster)
		-- 扣除余额，再次检查是否有余额
		self:SetStackCount(self:GetStackCount() - gold)
		if self:GetStackCount() <= 0 then self:Destroy() return end
    end 
end
function modifier_heroTalent_npc_dota_hero_bounty_hunter:OnDestroy()
	if not IsServer() then return end
	if self.parent ~= self.caster then
		self.parent:ModifyGoldFiltered(self.give_parent, true, DOTA_ModifyGold_PurchaseItem ) 
		self.caster:ModifyGoldFiltered(self.give_caster, true, DOTA_ModifyGold_PurchaseItem ) 
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self.parent, self.give_parent, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self.caster, self.give_caster, nil)
	
		local gameEvent={}
		gameEvent["player_id"] = self.caster:GetPlayerOwnerID()
		gameEvent["message"] = "#DOTA_HUD_bh_talent_ally_info"
		gameEvent["locstring_value"] = self.give_parent
		gameEvent["locstring_value2"] = self.give_caster
		gameEvent["teamnumber"] = -1
		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		self.caster:ModifyGoldFiltered(self.give_caster + self.give_parent, true, DOTA_ModifyGold_PurchaseItem ) 
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,self.caster, self.give_caster + self.give_parent, nil)

		local gameEvent={}
		gameEvent["player_id"] = self.caster:GetPlayerOwnerID()
		gameEvent["message"] = "#DOTA_HUD_bh_talent_self_info"
		gameEvent["locstring_value"] = self.give_caster + self.give_parent
		gameEvent["teamnumber"] = -1
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
	DestroyParticleByDelay(nFXIndex,5)
end


-- cy老赏金天赋
-- function modifier_heroTalent_npc_dota_hero_bounty_hunter:OnCreated(keys)
-- 	if IsServer() then
-- 		if not self:GetParent():IsRealHero() then
-- 			return 
-- 		end
-- 		_G.GAME_Challenge_gold_bonus_index = _G.GAME_Challenge_gold_bonus_index + 0.2
-- 		print("++++++++++++++++++")
-- 	end
-- end
-- function modifier_heroTalent_npc_dota_hero_bounty_hunter:OnDestroy(keys)
-- 	if IsServer() then
-- 		if not self:GetParent():IsRealHero() then
-- 			return 
-- 		end
-- 		_G.GAME_Challenge_gold_bonus_index = _G.GAME_Challenge_gold_bonus_index - 0.2
-- 		print("-----------------")
-- 	end
-- end

