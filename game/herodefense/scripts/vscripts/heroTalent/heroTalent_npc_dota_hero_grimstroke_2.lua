heroTalent_npc_dota_hero_grimstroke_2 = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke_2_passive", "heroTalent/heroTalent_npc_dota_hero_grimstroke_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke_2_active2", "heroTalent/heroTalent_npc_dota_hero_grimstroke_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke_2_active", "heroTalent/heroTalent_npc_dota_hero_grimstroke_2", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke_2", "heroTalent/heroTalent_npc_dota_hero_grimstroke_2", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_heroTalent_npc_dota_hero_grimstroke_2_effect", "heroTalent/heroTalent_npc_dota_hero_grimstroke_2", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_grimstroke_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_grimstroke_2_passive"

end
function heroTalent_npc_dota_hero_grimstroke_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_grimstroke_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_grimstroke_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_grimstroke_2:IsNetherWardStealable()		return true end

-- function heroTalent_npc_dota_hero_grimstroke_2:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_grimstroke_2")
--     if modifier then
--         modifier.count = modifier.count +1
--     end
-- end
function heroTalent_npc_dota_hero_grimstroke_2:CreatePhantom(target_pos)
	local caster = self:GetCaster()
	local ability = self
	local pos = caster:GetOrigin()
	-- local forward = caster:GetForwardVector()

    local index = RandomInt(1, 2)==1 and 1 or -1
    local new_caster_pos = RotatePosition(pos, QAngle(0, 90*index, 0), target_pos) 
    local new_dir = (new_caster_pos - pos):Normalized()
    local new_pos = pos+new_dir*128
    local new_forward = (target_pos - new_pos):Normalized()


	local duration = 1.5
	local unit  = CreateUnitByName("npc_hd_double", new_pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_grimstroke_2", {duration=duration})
	unit:SetForwardVector(new_forward)
	unit:SetOriginalModel(caster.origin_model_name)
	unit:SetModelScale(caster:GetModelScale())
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = unit:GetAbsOrigin() })
			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			hWearable:FollowEntity(unit, true)
		end
		hModel = hModel:NextMovePeer()
	end
    return unit
end
--------------------------------
modifier_heroTalent_npc_dota_hero_grimstroke_2_passive = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:OnCreated(table)
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_res = self:GetAbility():GetSpecialValueFor("magic_res")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
	}
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, 40000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _,hero in pairs(heroes) do
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_grimstroke_2_active",{duration = self.duration})
			if hero ~= self:GetParent() then
				hero:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_grimstroke_2_active",{duration = self.duration})
				break
			end
		end
	end

	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		local heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, 40000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
		for _,hero in pairs(heroes) do
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_grimstroke_2_active2",{duration = self.duration})
			if hero ~= self:GetParent() then
				hero:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_grimstroke_2_active2",{duration = self.duration})
				break
			end
		end
	end
end
---------------------------------------
modifier_heroTalent_npc_dota_hero_grimstroke_2_active = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active:Advanced_GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end
---------------------------------------
modifier_heroTalent_npc_dota_hero_grimstroke_2_active2 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:OnCreated()
	self.res = self:GetAbility():GetSpecialValueFor("magic_res")
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2_active2:GetModifierMagicalResistanceBonus()
	return self.res
end



modifier_heroTalent_npc_dota_hero_grimstroke_2 = modifier_heroTalent_npc_dota_hero_grimstroke_2 or advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_grimstroke_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:AllowIllusionDuplicate()	return false end


function modifier_heroTalent_npc_dota_hero_grimstroke_2:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)

        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
        UTIL_Remove( self:GetParent() )
	end
end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:CheckState()
	return {
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_grimstroke_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end


function modifier_heroTalent_npc_dota_hero_grimstroke_2:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().origin_model_name
	end
	
end
-- function modifier_Advanced_Phantom_Strike_unlock3:GetOverrideAnimation(params)
-- 	return ACT_DOTA_ATTACK
-- end
-- function modifier_Advanced_Phantom_Strike_unlock3:GetOverrideAnimationRate()	return 50 end
function modifier_heroTalent_npc_dota_hero_grimstroke_2:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end



function modifier_heroTalent_npc_dota_hero_grimstroke_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_heroTalent_npc_dota_hero_grimstroke_2:Advanced_GetModifier_FlyingPathing()	
	return 1
end

