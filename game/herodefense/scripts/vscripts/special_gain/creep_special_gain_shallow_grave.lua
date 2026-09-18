creep_special_gain_shallow_grave = class({})
-- LinkLuaModifier("modifier_creep_special_gain_shallow_grave_arua", "skills/creep_special_gain_shallow_grave", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_shallow_grave_arua_effect", "skills/creep_special_gain_shallow_grave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_shallow_grave", "special_gain/creep_special_gain_shallow_grave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_shallow_grave_active", "special_gain/creep_special_gain_shallow_grave", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_shallow_grave:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_shallow_grave"
end


modifier_creep_special_gain_shallow_grave = class({})




function modifier_creep_special_gain_shallow_grave:IsHidden() 
	return false
end
function modifier_creep_special_gain_shallow_grave:IsPurgable() return false end
function modifier_creep_special_gain_shallow_grave:IsDebuff() return false end

function modifier_creep_special_gain_shallow_grave:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end





function modifier_creep_special_gain_shallow_grave:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit

		if unit~=self:GetParent() then	return end
		local ability = self:GetAbility()
		-- if keys.damage>=unit:GetHealth() and self:GetAbility():IsCooldownReady() then

		--腐尸毒新LV10
		local modifier_sp = unit:FindModifierByName("modifier_Advanced_Caustic_Finale")
		if modifier_sp and modifier_sp:GetAbility().advanced_level >= 10 then
			return
		end
		if unit:GetHealth()<=0 and ability:IsCooldownReady() then

			ability:StartCooldown(10)
			unit:SetHealth(1)
			unit:AddNewModifier(unit, ability, "modifier_creep_special_gain_shallow_grave_active", {duration = ability:GetSpecialValueFor("duration")})
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")


		end
		
    end 
end



modifier_creep_special_gain_shallow_grave_active = class({})

function modifier_creep_special_gain_shallow_grave_active:IsDebuff()				return false end
function modifier_creep_special_gain_shallow_grave_active:IsHidden() 			return false end
function modifier_creep_special_gain_shallow_grave_active:IsPurgable() 			return false end
function modifier_creep_special_gain_shallow_grave_active:IsPurgeException() 	return false end
function modifier_creep_special_gain_shallow_grave_active:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf" end
function modifier_creep_special_gain_shallow_grave_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_shallow_grave_active:KillPre()
	self:SafeDestroy()
	return
end



function modifier_creep_special_gain_shallow_grave_active:OnCreated()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
	end
end

function modifier_creep_special_gain_shallow_grave_active:DeclareFunctions()
	return { MODIFIER_PROPERTY_MIN_HEALTH}
end



function modifier_creep_special_gain_shallow_grave_active:GetMinHealth() return 1 end

function modifier_creep_special_gain_shallow_grave_active:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
		-- self:GetParent():Heal(self:GetStackCount(), self:GetCaster())
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetStackCount(), nil)

	end
end


function modifier_creep_special_gain_shallow_grave_active:KillPre() self:SafeDestroy() end  