heroTalent_npc_dota_hero_phoenix = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phoenix", "heroTalent/heroTalent_npc_dota_hero_phoenix", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_phoenix:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_phoenix"
end
function heroTalent_npc_dota_hero_phoenix:Spawn()
	if IsServer() then
		local unit = self:GetCaster()
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID(unit:GetPlayerOwnerID())),"Nirvana_1") then
			unit:InitAchievement("Nirvana_1")
		end
	end
end


modifier_heroTalent_npc_dota_hero_phoenix = class({})

function modifier_heroTalent_npc_dota_hero_phoenix:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_phoenix:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phoenix:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phoenix:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_phoenix:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_phoenix:BuyBackTarget(target)
	if IsServer() then
		local pos = target:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 60, Vector(5,207,243))
		ParticleManager:SetParticleControl(pfx, 1, Vector(1200,1200,1200))
		ParticleManager:SetParticleControl(pfx, 3, pos)
		ParticleManager:SetParticleControl(pfx, 61, Vector(1200,1200,1200))
		ParticleManager:ReleaseParticleIndex(pfx)
		target:EmitSound("Hero_Phoenix.SuperNova.Explode")
	end
end



