
Primary_Shallow_Grave = class({})

LinkLuaModifier("modifier_Primary_Shallow_Grave", "skills/Primary_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)




function Primary_Shallow_Grave:IsHiddenWhenStolen() 	return false end
function Primary_Shallow_Grave:IsRefreshable() 			return false  end
function Primary_Shallow_Grave:IsStealable() 			return true  end
function Primary_Shallow_Grave:IsNetherWardStealable()	return true end

function Primary_Shallow_Grave:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("cast_range") end



function Primary_Shallow_Grave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, self, "modifier_Primary_Shallow_Grave", {duration = self:GetSpecialValueFor("duration")})

	--群体效果
	-- local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- for _,target in pairs(enemies) do
	-- 	target:AddNewModifier(caster, self, "modifier_Primary_Shallow_Grave", {duration = self:GetSpecialValueFor("duration")})
	-- end

end

modifier_Primary_Shallow_Grave = class({})

function modifier_Primary_Shallow_Grave:IsDebuff()				return false end
function modifier_Primary_Shallow_Grave:IsHidden() 			return false end
function modifier_Primary_Shallow_Grave:IsPurgable() 			return false end
function modifier_Primary_Shallow_Grave:IsPurgeException() 	return false end
function modifier_Primary_Shallow_Grave:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf" end
function modifier_Primary_Shallow_Grave:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_Shallow_Grave:OnCreated()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
	end
end

function modifier_Primary_Shallow_Grave:DeclareFunctions()
	return { MODIFIER_PROPERTY_MIN_HEALTH}
end



function modifier_Primary_Shallow_Grave:GetMinHealth() return 1 end

function modifier_Primary_Shallow_Grave:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
		-- self:GetParent():Heal(self:GetStackCount(), self:GetCaster())
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetStackCount(), nil)

	end
end

function modifier_Primary_Shallow_Grave:KillPre() self:SafeDestroy() end  
