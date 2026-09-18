
LinkLuaModifier("modifier_item_hd_flash_change_brooch_buff", "items/item_hd_flash_change_brooch.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_flash_change_brooch_cooldown", "items/item_hd_flash_change_brooch.lua", LUA_MODIFIER_MOTION_NONE)

require("internal/timers")
item_hd_flash_change_brooch=item_hd_flash_change_brooch or class({})
function item_hd_flash_change_brooch:GetIntrinsicModifierName() 
    return "modifier_item_hd_flash_change_brooch_buff" 
end
function item_hd_flash_change_brooch:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/flash_change_brooch/effect_preimage.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", context )

    
end


modifier_item_hd_flash_change_brooch_buff= modifier_item_hd_flash_change_brooch_buff or class({})

-- function modifier_item_hd_flash_change_brooch_buff:IsPassive()			return true end
function modifier_item_hd_flash_change_brooch_buff:IsDebuff() return false end
function modifier_item_hd_flash_change_brooch_buff:IsHidden() 		return true end
function modifier_item_hd_flash_change_brooch_buff:IsPurgable() 		return false end
function modifier_item_hd_flash_change_brooch_buff:IsPurgeException() return false end
function modifier_item_hd_flash_change_brooch_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_flash_change_brooch_buff:DestroyOnExpire() return false end
function modifier_item_hd_flash_change_brooch_buff:OnCreated()

    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")

end



function modifier_item_hd_flash_change_brooch_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
        MODIFIER_EVENT_ON_ATTACK_START
	}
end



function modifier_item_hd_flash_change_brooch_buff:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_flash_change_brooch_buff:GetModifierManaBonus()	return self.bonus_mana end



function modifier_item_hd_flash_change_brooch_buff:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    local parent = self:GetParent()
    if parent == keys.target  and not keys.attacker:IsOther() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= parent:GetTeamNumber() then
		if keys.attacker:IsMagicImmune() then
            return
        end
		if keys.attacker:IsInvulnerable() then
			return
		end
        if keys.attacker:HasModifier("modifier_item_hd_flash_change_brooch_cooldown") then
            return
        end



        local pos = parent:GetOrigin()
        local targetPos = keys.attacker:GetOrigin()
        local dir = CalculateDirection(pos,targetPos)
        local newPos = targetPos - dir*600


        local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/items/flash_change_brooch/effect_preimage.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0,pos+Vector(0,0,64))

        FindClearSpaceForUnit( keys.attacker, newPos, true )
		ParticleManager:SetParticleControl(nFXIndex, 1,keys.attacker:GetOrigin()+Vector(0,0,64))
		DestroyParticleByDelay(nFXIndex,4)
        keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_flash_change_brooch_cooldown", {duration = 20})


		-- self:GetAbility():CreateSingleEffect(keys.attacker)

        local ability = parent:FindAbilityByName("Default_Move")
        if ability then
            if not ability:IsCooldownReady() then
                local cooldown = ability:GetCooldownTimeRemaining() - 3
                ability:EndCooldown()
                if cooldown>0 then
                    ability:StartCooldown(cooldown)
                end
            end
        end
    end
end



modifier_item_hd_flash_change_brooch_cooldown=modifier_item_hd_flash_change_brooch_cooldown or class({})


function modifier_item_hd_flash_change_brooch_cooldown:IsDebuff() return true end
function modifier_item_hd_flash_change_brooch_cooldown:IsHidden() 		return true end
function modifier_item_hd_flash_change_brooch_cooldown:IsPurgable() 		return false end