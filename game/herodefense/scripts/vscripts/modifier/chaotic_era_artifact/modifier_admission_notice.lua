LinkLuaModifier("modifier_admission_notice_buff", "modifier/chaotic_era_artifact/modifier_admission_notice", LUA_MODIFIER_MOTION_NONE)

modifier_admission_notice = advanced_modifier({})

function modifier_admission_notice:IsHidden()return false end
function modifier_admission_notice:IsDebuff()return true end
function modifier_admission_notice:IsPurgable()return false end
function modifier_admission_notice:IsPurgeException() 	return false end
function modifier_admission_notice:RemoveOnDeath() return false end
function modifier_admission_notice:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_admission_notice:DestroyOnExpire() return false end
-- function modifier_admission_notice:GetTexture() return self.texture end
function modifier_admission_notice:GetTexture() return "chaotic_era_spell/admission_notice" end
-- function modifier_admission_notice:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/artifact/admission_notice/main/effect.vpcf", context )
-- end



function modifier_admission_notice:OnCreated(keys)
  
  self.bonus_damage = -GetChaticEra_Artifact_Special(self,"damage_reduction")
  if IsServer() then
    local parent = self:GetParent()
    local data = customDataManager:GetTargetData(tostring(PlayerResource:GetSteamID( parent:GetPlayerOwnerID())),"admission_notice_bonus")
   
    self.bonus_damage_max = GetChaticEra_Artifact_Special(self,"bonus_damage_max")
    if data and data.valueOne>=self.bonus_damage_max then
      parent:AddNewModifier(parent, nil, "modifier_admission_notice_buff", {stack = GetChaticEra_Artifact_Special(self,"bonus_damage_2") })
      self:Destroy()
    end

    self:StartIntervalThink(60)
    self:SetStackCount(GetChaticEra_Artifact_Special(self,"wave_require"))
  end
end

function modifier_admission_notice:OnIntervalThink()
  self:SetStackCount(math.max(self:GetStackCount()-1,0))
  if self:GetStackCount()<=0 then
    local parent = self:GetParent()
    customDataManager:ModifySingleCustomData(tostring(PlayerResource:GetSteamID( parent:GetPlayerOwnerID())),"admission_notice_bonus",1,nil) 
    self:StartIntervalThink(-1)
  end
end


function modifier_admission_notice:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_admission_notice:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if IsServer() and IsElementDamage(keys) then
		return self.bonus_damage
	end
	return 0
end
function modifier_admission_notice:ADDeclareFunctions()
    return 
    {
      advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,

    }
end



function modifier_admission_notice:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus_damage
	end
end








modifier_admission_notice_buff = advanced_modifier({})

function modifier_admission_notice_buff:IsHidden()return false end
function modifier_admission_notice_buff:IsDebuff()return false end
function modifier_admission_notice_buff:IsPurgable()return false end
function modifier_admission_notice_buff:IsPurgeException() 	return false end
function modifier_admission_notice_buff:RemoveOnDeath() return false end
function modifier_admission_notice_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_admission_notice_buff:GetTexture() return "chaotic_era_spell/admission_notice" end
function modifier_admission_notice_buff:OnCreated(keys)
	if IsServer() then
    self:SetStackCount(keys.stack+self:GetStackCount())
	end
end
function modifier_admission_notice_buff:OnRefresh(keys)
	if IsServer() then
    
    self:SetStackCount(keys.stack+self:GetStackCount())
	end
end
function modifier_admission_notice_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_admission_notice_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)	
	if IsServer() and IsElementDamage(keys) then
		return self:GetStackCount()
	end
	return 0
end
function modifier_admission_notice_buff:ADDeclareFunctions()
    return 
    {
      advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end




function modifier_admission_notice_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:GetStackCount()
	end
end
