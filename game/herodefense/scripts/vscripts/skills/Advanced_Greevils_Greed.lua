LinkLuaModifier("modifier_Advanced_Greevils_Greed", "skills/Advanced_Greevils_Greed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Greevils_Greed_units_buff", "skills/Advanced_Greevils_Greed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Greevils_Greed_have_father", "skills/Advanced_Greevils_Greed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Greevils_Greed_father", "skills/Advanced_Greevils_Greed", LUA_MODIFIER_MOTION_NONE)
Advanced_Greevils_Greed = class({})
--加金币写在addon_game_mode里了

function Advanced_Greevils_Greed:GetIntrinsicModifierName() return "modifier_Advanced_Greevils_Greed" end
function Advanced_Greevils_Greed:OnAdvancedUpgrade()
	if self.advanced_level>=25 and not self.lv25 then
		-- 25级了
		local modifier = self:GetCaster():FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:GreedLv25()
		end
	end
end
function Advanced_Greevils_Greed:CheckKV(key)
	local table = {

	
		bnous_gold_index =0.005,
		bnous_gold = 20,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Greevils_Greed:UnlockFirstCore(key)
	return true
end
function Advanced_Greevils_Greed:UnlockSecondCore(key)
	return true
end
function Advanced_Greevils_Greed:UnlockThirdCore(key)
	return true
end

function Advanced_Greevils_Greed:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local unlock = self:GetUnlock(3)
	if unlock==3 and not self:GetCaster():HasModifier("modifier_Advanced_Greevils_Greed_have_father") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	--LV20解锁王之宝库
	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET +DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
end

function Advanced_Greevils_Greed:CastFilterResult( vLoc )
	-- check nohammer
	if IsServer() then
		if self:GetAutoCastState() then
			if self:GetCaster():GetGold()<5500 then
				return UF_FAIL_CUSTOM
			end
		
			
		else
			local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Greevils_Greed")
			if modifier then
				local stack = modifier:GetStackCount()
				if stack<=0 then
					return UF_FAIL_CUSTOM
				end
				
			end
		end
	

		return UF_SUCCESS
	end
	
end

function Advanced_Greevils_Greed:GetCustomCastError( vLoc )
	-- check nohammer
	if IsServer() then
		if self:GetAutoCastState() then
			if self:GetCaster():GetGold()<5500 then
				-- return "#dota_hud_error_nohammer"
				return "#dota_hud_greevils_not_enough_gold"
			end
			
		else
			local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Greevils_Greed")
			if modifier then
				local stack = modifier:GetStackCount()
				if stack<=0 then
					return "#dota_hud_greevils_not_enough_energy"
				end
				
			end
		end
		

		return ""
	end

end

function Advanced_Greevils_Greed:CastFilterResultTarget( target )
	-- check nohammer
	if IsServer() then
		if not target:IsRealHero() then
			return UF_FAIL_CUSTOM
		end
		if target==self:GetCaster() then
			return UF_FAIL_CUSTOM
		end
	

		return UF_SUCCESS
	end
	
end
function Advanced_Greevils_Greed:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return "#DOTA_HUB_CANT_CAST_TO_TARGET"
	end

end

function Advanced_Greevils_Greed:OnSpellStart()
	-- self.pull_list = {}

	-- unit identifier
	local caster = self:GetCaster()
	if self.unlock3 and not caster:HasModifier("modifier_Advanced_Greevils_Greed_have_father") then
		local target = self:GetCursorTarget()
		--防止意外事故
		if not caster:IsAlive() or not target:IsAlive() then
			return
		end
		caster:AddItemByName("item_hd_Treasure4")
		caster:AddItemByName("item_hd_Treasure4")
		local modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_Greevils_Greed_have_father", {})
		local modifier2 = target:AddNewModifier(target, self, "modifier_Advanced_Greevils_Greed_father", {})
		modifier.targetModifier = modifier2
		modifier2.targetModifier = modifier

	else
		if self:GetAutoCastState() then
			caster:ModifyGoldFiltered(-5500,true,DOTA_ModifyGold_PurchaseItem  )  --金币
			caster:AddItemByName("item_hd_Treasure4")
		else
			local modifier = caster:FindModifierByName("modifier_Advanced_Greevils_Greed")
			if modifier then
				local stack = modifier:GetStackCount()
				if stack>=5 then
					caster:AddItemByName("item_hd_Treasure4")
					modifier:SetStackCount(stack-5)
				elseif stack>=3 then
					caster:AddItemByName("item_hd_Treasure3")
					modifier:SetStackCount(stack-3)
				else
					caster:AddItemByName("item_hd_Treasure"..RandomInt(1, 2))
					modifier:SetStackCount(stack-1)
				end
			end
		end
	end
	




end



modifier_Advanced_Greevils_Greed = advanced_modifier({})

function modifier_Advanced_Greevils_Greed:IsDebuff()			return false end
function modifier_Advanced_Greevils_Greed:IsHidden() 			return false end
function modifier_Advanced_Greevils_Greed:IsPurgable() 		return false end
function modifier_Advanced_Greevils_Greed:IsPurgeException() 	return false end
function modifier_Advanced_Greevils_Greed:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS} end
function modifier_Advanced_Greevils_Greed:GetModifierBonusStats_Intellect() return self.bonus*4 end
function modifier_Advanced_Greevils_Greed:GetModifierBonusStats_Strength() return self.bonus*4 end
function modifier_Advanced_Greevils_Greed:GetModifierBonusStats_Agility() return self.bonus*4 end
function modifier_Advanced_Greevils_Greed:OnCreated()
	if IsServer() then

		-- self:SetStackCount(0)
		self.bonus =0
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Greevils_Greed:OnWaveStart()


	if IsLastWaveOrBonusWave() then

		return
	end
	if self:GetAbility().unlock2 and _G.GAME_Greevils_Greed<10 then
		_G.GAME_Greevils_Greed = _G.GAME_Greevils_Greed + 1
		self.bonusTrigger = true
		self.hNpcSpawnedGameEvent = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, 'OnNpcSpawn_modifier' ),self )

	end

end

function modifier_Advanced_Greevils_Greed:OnWaveEnd()
	if IsServer() then
		self:IncrementStackCount()
		if self:GetAbility().advanced_level>=10 and 1==RandomInt(1, 2) then
			self:IncrementStackCount()
		end



		if self.bonusTrigger then
			self.bonusTrigger = false
			_G.GAME_BONUS_BOOK = _G.GAME_BONUS_BOOK +1
			
			if self.hNpcSpawnedGameEvent then
				StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
				self.hNpcSpawnedGameEvent = nil
			end
		end



	end

end

function modifier_Advanced_Greevils_Greed:OnDestroy()
	if IsServer() then
		if self.hNpcSpawnedGameEvent then
			StopListeningToGameEvent(self.hNpcSpawnedGameEvent)
			self.hNpcSpawnedGameEvent = nil
		end
	end
end
function modifier_Advanced_Greevils_Greed:OnIntervalThink()
	if IsServer() then
		if self:GetUnlock(1)==1 then
			local gold = self:GetParent():GetGold()
			local max_bonus = 90
			gold = math.min((gold - gold %1000)/1000,max_bonus)  --获得增益
			self.bonus = gold
		else
			self.bonus = 0
		end

        
	end
end

function modifier_Advanced_Greevils_Greed:OnNpcSpawn_modifier( keys )
    local unit = EntIndexToHScript(keys.entindex)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster or not ability then
		return
	end
	if unit:GetTeamNumber()~=caster:GetTeamNumber() then
		if caster:IsRealHero() then
			local ability = caster:FindAbilityByName("Default_Move")
			unit:AddNewModifier(unit, ability, "modifier_Advanced_Greevils_Greed_units_buff", {})
		end
	end
end

function modifier_Advanced_Greevils_Greed:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end







modifier_Advanced_Greevils_Greed_units_buff = advanced_modifier({})

function modifier_Advanced_Greevils_Greed_units_buff:IsDebuff()			return false end
function modifier_Advanced_Greevils_Greed_units_buff:IsHidden() 			return false end
function modifier_Advanced_Greevils_Greed_units_buff:IsPurgable() 		return false end
function modifier_Advanced_Greevils_Greed_units_buff:IsPurgeException() 	return false end
function modifier_Advanced_Greevils_Greed_units_buff:RemoveOnDeath() return false end
function modifier_Advanced_Greevils_Greed_units_buff:GetTexture() return "life_stealer/ls_ti10_immortal_ability_icons/life_stealer_infest_ti10" end
function modifier_Advanced_Greevils_Greed_units_buff:DeclareFunctions() return {
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
} 
end
function modifier_Advanced_Greevils_Greed_units_buff:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_Greevils_Greed_units_buff:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_Advanced_Greevils_Greed_units_buff:AdvancedGetModifierExtraHealthPercentage() return self:GetStackCount()* 200 end
function modifier_Advanced_Greevils_Greed_units_buff:GetModifierBaseDamageOutgoing_Percentage() return self:GetStackCount()*200 end
function modifier_Advanced_Greevils_Greed_units_buff:Advanced_GetModifierPhysicalArmorBonus() return self:GetStackCount()*70 end
function modifier_Advanced_Greevils_Greed_units_buff:GetModifierMagicalResistanceBonus() return self:GetStackCount()*60 end


function modifier_Advanced_Greevils_Greed_units_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }
end




modifier_Advanced_Greevils_Greed_have_father = class({})

function modifier_Advanced_Greevils_Greed_have_father:IsDebuff()			return false end
function modifier_Advanced_Greevils_Greed_have_father:IsHidden() 			return false end
function modifier_Advanced_Greevils_Greed_have_father:IsPurgable() 		return false end
function modifier_Advanced_Greevils_Greed_have_father:IsPurgeException() 	return false end
function modifier_Advanced_Greevils_Greed_have_father:RemoveOnDeath() return false end
function modifier_Advanced_Greevils_Greed_have_father:OnDestroy()
	if IsServer() then
		if self.targetModifier and not self.targetModifier:IsNull() then
			self.targetModifier:SafeDestroy()
		end
	end
end	

function modifier_Advanced_Greevils_Greed_have_father:CallFather()
	if self.targetModifier and not self.targetModifier:IsNull() then
		local father = self.targetModifier:GetParent()
		local caster = self:GetCaster()
		local maxGold = 99999

		local father_Gold = father:GetGold()
		local self_gold = caster:GetGold()
		if self_gold==maxGold or father_Gold==0 then
			return
		end

		if self_gold+father_Gold<=maxGold then

			father:ModifyGoldFiltered(-(father_Gold),true,DOTA_ModifyGold_PurchaseItem ) 
			caster:ModifyGoldFiltered((father_Gold),true,DOTA_ModifyGold_PurchaseItem ) 
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,caster, father_Gold, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_XP  ,father, father_Gold, nil)
			father:EmitSound("CallFather.01")
		else
			local gold = maxGold-self_gold  --取到最大值的插值
			father:ModifyGoldFiltered(-(gold),true,DOTA_ModifyGold_PurchaseItem ) 
			caster:ModifyGoldFiltered((gold),true,DOTA_ModifyGold_PurchaseItem ) 
			father:EmitSound("CallFather.01")
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,caster, gold, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_XP  ,father, gold, nil)
			 
		end


		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_ABSORIGIN_FOLLOW, father )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, father, PATTACH_POINT_FOLLOW, "attach_hitloc", father:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
		DestroyParticleByDelay(nFXIndex,5)
		
		
	end
end

modifier_Advanced_Greevils_Greed_father = class({})

function modifier_Advanced_Greevils_Greed_father:IsDebuff()			return false end
function modifier_Advanced_Greevils_Greed_father:IsHidden() 			return false end
function modifier_Advanced_Greevils_Greed_father:IsPurgable() 		return false end
function modifier_Advanced_Greevils_Greed_father:IsPurgeException() 	return false end
function modifier_Advanced_Greevils_Greed_father:RemoveOnDeath() return false end
function modifier_Advanced_Greevils_Greed_father:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Greevils_Greed_father:OnDestroy()
	if IsServer() then
		if self.targetModifier and not self.targetModifier:IsNull() then
			self.targetModifier:SafeDestroy()
		end
	end
end	