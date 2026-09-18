heroTalent_npc_dota_hero_morphling_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_morphling_4", "heroTalent/heroTalent_npc_dota_hero_morphling_4", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_morphling_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_morphling_4"
end


function heroTalent_npc_dota_hero_morphling_4:Spawn()
	if IsServer() then
		self:GetCaster():GameTimer(0.1, function()
			self:InitModifyWord()
		end)
		
	end
end
function heroTalent_npc_dota_hero_morphling_4:InitModifyWord()
	if IsServer() then
		local parent = self:GetCaster()
		local count =  self:GetSpecialValueFor("count")
		local time_require = self:GetSpecialValueFor("time_require")
		local keys = {
			idKey = "heroTalent_npc_dota_hero_morphling_4",
			icon = "file://{images}/custom_game/chaotic_era/hud/artifact/heroTalent_npc_dota_hero_morphling_4.png",
			title = "heroTalent_npc_dota_hero_morphling_4",
			text = "HUD_heroTalent_npc_dota_hero_morphling_4_Info",
			keys={
		
			}
		}
		-- local parent = self:GetParent()
		chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
		-- 检测是否成功的回调
		function (data)
			if chaotic_era_spawner:CheckHaveSameIdKey(data, "heroTalent_npc_dota_hero_morphling_4") then
				local nPlayerID = parent:GetPlayerOwnerID()
				SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
				return false
			end
			local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
			if kv then
				-- print("time_require=",time_require)
				-- print("kv.interval=",kv.interval)
				if kv.interval>=time_require then
					local nPlayerID = parent:GetPlayerOwnerID()
					-- print("11111111111111")
					SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
					return false
				end
			end
			if data.isCopy==true then
				local nPlayerID = parent:GetPlayerOwnerID()
				-- print("222222222222")
				SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
				return false
			end
			chaotic_era_spawner:CopySpawnData(data)
			return true
		end,
		-- 是否清除(即仅能修饰一次)
		function ()
			count = count - 1
			if count<=0 then
				self:SetActivated(false)
				return true
			end
			return false
		end,
		-- 实例化修饰
		nil

		)
	  -- self:Destroy()
	  
	end
  end


-- modifier_heroTalent_npc_dota_hero_morphling_4 = class({})

-- function modifier_heroTalent_npc_dota_hero_morphling_4:IsHidden()	return false end
-- function modifier_heroTalent_npc_dota_hero_morphling_4:IsDebuff()	return false end
-- function modifier_heroTalent_npc_dota_hero_morphling_4:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_morphling_4:IsPurgeException() return false end
-- function modifier_heroTalent_npc_dota_hero_morphling_4:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_morphling_4:OnCreated(keys)
-- 	if IsServer() then
-- 		self:StartIntervalThink(0.3)
-- 	end
-- end

-- function modifier_heroTalent_npc_dota_hero_morphling_4:OnIntervalThink()
-- 	local caster = self:GetCaster()
-- 	if not caster:IsAlive() then
-- 		return
-- 	end
-- 	local attribute = caster:GetAgility() + caster:GetIntellect(false)
-- 	self:SetStackCount(math.min(2000,attribute))
	
-- end

-- function modifier_heroTalent_npc_dota_hero_morphling_4:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
-- 	}

-- 	return funcs
-- end




-- function modifier_heroTalent_npc_dota_hero_morphling_4:GetModifierBaseAttack_BonusDamage() 
-- 	return self:GetStackCount()
-- end