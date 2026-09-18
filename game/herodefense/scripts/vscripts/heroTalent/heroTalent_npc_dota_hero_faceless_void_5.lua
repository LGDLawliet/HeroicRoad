heroTalent_npc_dota_hero_faceless_void_5 = class({})

function heroTalent_npc_dota_hero_faceless_void_5:Precache( context )
	PrecacheResource( "particle", "particles/items2_fx/refresher.vpcf", context )
end
function heroTalent_npc_dota_hero_faceless_void_5:IsRefreshable() return false end
function heroTalent_npc_dota_hero_faceless_void_5:OnSpellStart()
	local heroes = GetAllRealHeroes()
	for _,hero in pairs(heroes)do
		self:Refresh(hero)
	end
end
function heroTalent_npc_dota_hero_faceless_void_5:Refresh(unit)
	local caster = unit
	for i=0, 11 do
		local Ability = caster:GetAbilityByIndex(i)
		if Ability ~= nil and Ability~=self then
			Ability:EndCooldown()
		end
	end

	for i=0, 8 do
		local Ability = caster:GetItemInSlot(i)
		if Ability ~= nil and not Ability:IsCooldownReady()  then
			Ability:EndCooldown()
		end
	end
	local modifier = caster:FindModifierByName("modifier_time_already")
	if modifier then
		modifier:SafeDestroy()
	end
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	caster:EmitSound("DOTA_Item.Refresher.Activate")

	return false
end

