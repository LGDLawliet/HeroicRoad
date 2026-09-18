

Primary_Bristle_Back = class({})

LinkLuaModifier("modifier_Primary_Bristle_Back_passive", "skills/Primary_Bristle_Back", LUA_MODIFIER_MOTION_NONE)


function Primary_Bristle_Back:IsHiddenWhenStolen() 		return false end
function Primary_Bristle_Back:IsRefreshable() 			return true end
function Primary_Bristle_Back:IsStealable() 			return false end
function Primary_Bristle_Back:IsNetherWardStealable()	return false end
function Primary_Bristle_Back:GetIntrinsicModifierName() return "modifier_Primary_Bristle_Back_passive" end


modifier_Primary_Bristle_Back_passive = advanced_modifier({})

function modifier_Primary_Bristle_Back_passive:IsDebuff()			return false end
function modifier_Primary_Bristle_Back_passive:IsHidden() 			return true end
function modifier_Primary_Bristle_Back_passive:IsPurgable() 		return false end
function modifier_Primary_Bristle_Back_passive:IsPurgeException() 	return false end




function modifier_Primary_Bristle_Back_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()

	if parent:PassivesDisabled() then
		return 0
	end

	if IsClient() then
		if  parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
			return  (0 - passive:GetSpecialValueFor("back_damage_reduction"))
		end
		return 0
	end
	if not  keys.attacker then
		return 0
	end
	if  keys.attacker:IsBuilding() or parent:IsIllusion() then
		return
	end

	local cast_angle = VectorToAngles(parent:GetForwardVector() * -1)
	local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
	local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
	local min_degree = passive:GetSpecialValueFor("side_angle")/2
	if parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
		degree = 0
	end
	if degree <= min_degree then
		local reduce = 0
		parent:EmitSound("Hero_Bristleback.Bristleback")
		if degree > passive:GetSpecialValueFor("back_angle")/2 then  --如果大于后背的角度进行边减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_side_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)

			reduce = (0 - passive:GetSpecialValueFor("side_damage_reduction"))
		else    --如果是后背角度进行背减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)

			reduce = (0 - passive:GetSpecialValueFor("back_damage_reduction"))
		end
		return reduce
	end
end

function modifier_Primary_Bristle_Back_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




