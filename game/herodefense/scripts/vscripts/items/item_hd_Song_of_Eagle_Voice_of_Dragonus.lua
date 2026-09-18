item_hd_Song_of_Eagle_Voice_of_Dragonus = class({})

LinkLuaModifier("modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus", "items/item_hd_Song_of_Eagle_Voice_of_Dragonus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff", "items/item_hd_Song_of_Eagle_Voice_of_Dragonus", LUA_MODIFIER_MOTION_NONE)

-- require('internal/timers')   --计时器功能
function item_hd_Song_of_Eagle_Voice_of_Dragonus:GetIntrinsicModifierName()
	return "modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus"
end

function item_hd_Song_of_Eagle_Voice_of_Dragonus:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_bolt_advanced_unlock3/effect.vpcf", context )
end
----------------------------------------------------------------------------------------
modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus = advanced_modifier({})

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:IsDebuff() return false end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:IsHidden() return true end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:IsPurgable() return false end


function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_cast_range")
    if IsServer() then

	end
end

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff")
	end
end

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,        --施法距离
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,


	}
end


function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:GetModifierManaBonus()	return self.bonus_mana end
-- function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:GetModifierCastRangeBonusStacking() return self.bonus_spell_range end



function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:OnAbilityFullyCast(keys)

	if IsServer() then
		local parent = self:GetParent()
		if keys.unit ==parent then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
			return
		end
		if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
			return 
		end
		if IsEnemy(keys.unit,parent) then
			return
		end
		if CalculateDistance(keys.unit,parent)>=1500 then
			return
		end
		local gain =  parent:GetModifierDurationGainIndex(1)
		parent:AddNewModifier(parent,self:GetAbility(),"modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff",{duration = 20*gain})	
	
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/arcane_bolt_advanced_unlock3/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		keys.unit:EmitSound("Hero_VoidSpirit.AetherRemnant.Destroy")
		
	end
end


-- advanced_modifier
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus:Advanced_GetModifierCastRangeBonusStacking(keys)

	return self.bonus_spell_range 
end

------------------------------------------------------------------------------------------------------------
modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff = advanced_modifier({})

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:IsHidden()	return false end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:IsDebuff()	return false end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:IsPurgable()	return false end

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:Advanced_GetModifierSpellAmplifyBonus()	return math.min(2*self:GetStackCount(),100) end

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
	end
end
function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:OnRefresh(params)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = self:GetDieTime() 
		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_item_hd_Song_of_Eagle_Voice_of_Dragonus_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end