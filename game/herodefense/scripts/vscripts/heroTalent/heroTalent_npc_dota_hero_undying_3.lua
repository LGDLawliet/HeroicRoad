heroTalent_npc_dota_hero_undying_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_undying_3", "heroTalent/heroTalent_npc_dota_hero_undying_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_undying_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_undying_3"
end


--function heroTalent_npc_dota_hero_undying_3:Spawn()
--	if IsServer() then
--		self:GetCaster():GameTimer(0.1, function()
--			self:InitModifyWord()
--		end)
--		
--	end
--end




modifier_heroTalent_npc_dota_hero_undying_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_undying_3:IsHidden()return false end
function modifier_heroTalent_npc_dota_hero_undying_3:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_undying_3:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_undying_3:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_undying_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_undying_3:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_undying_3:DestroyOnExpire() return false end
function modifier_heroTalent_npc_dota_hero_undying_3:GetTexture() return "undying_tombstone_zombie_deathstrike" end
function modifier_heroTalent_npc_dota_hero_undying_3:OnCreated(keys)
    if IsServer() then
      local parent = self:GetParent()
      local time_require = self:GetAbility():GetSpecialValueFor("time_require")
      local count =  1
  
      self:SetStackCount(count)
      local keys = {
          idKey = "modifier_heroTalent_npc_dota_hero_undying_3",
          icon = "file://{images}/custom_game/chaotic_era/hud/artifact/heroTalent_npc_dota_hero_undying_3.png",
          title = "modifier_heroTalent_npc_dota_hero_undying_3",
          text = "HUD_modifier_heroTalent_npc_dota_hero_undying_3_Info",
          keys={
              time_require = {
                  text= time_require,
                  bLocalize = 0,
              },
          }
      }


      chaotic_era_spawner:InsetTaskModifyOption(parent:GetPlayerOwnerID(),keys,
      -- 检测是否成功的回调
        function (data)
            if chaotic_era_spawner:CheckHaveSameIdKey(data, "modifier_heroTalent_npc_dota_hero_undying_3") then
                local nPlayerID = parent:GetPlayerOwnerID()
                SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error2","General.Cancel")
                return false
            end
            if not self:GetAbility():IsActivated() then
                return false
            end
            local kv =  KeyValues.chaotic_era_creep_attribute[data.id]
            if kv then
                if kv.interval>=time_require then
                    local nPlayerID = parent:GetPlayerOwnerID()
                    SendCustomErrorToPlayer(nPlayerID,"HUD_Chaotic_Era_TaskModify_Error","General.Cancel")
                    return false
                end
            end
            
            data.count = data.count +self:GetAbility():GetSpecialValueFor("count")
            return true
        end,
      -- 是否清除(即仅能修饰一次)
      function ()
        self:DecrementStackCount()
		if self:GetStackCount()<=0 then
            self:GetAbility():SetActivated(false)
            return true
        end
        return false
        end,
      nil
      )
    end
end
  
  