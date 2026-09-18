heroTalent_npc_dota_hero_kunkka_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_3_buff", "heroTalent/heroTalent_npc_dota_hero_kunkka_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_3_debuff", "heroTalent/heroTalent_npc_dota_hero_kunkka_3", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_kunkka_3:Trigger(cleaveDamage,pos)
	local caster = self:GetCaster()

	caster:EmitSound("Hero_Terrorblade.Reflection")
	-- caster:EmitSound("Hero_Sven.Layer.GodsStrength")
	pos.z = caster:GetOrigin().z

	local new_pos = pos + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)

	local direction = CalculateDirection(new_pos,pos)
	local start_pos = pos + direction * 600+Vector(0,0,128)
	local end_pos = pos - direction * 600+Vector(0,0,128)
	local pfx = ParticleManager:CreateParticle("particles/rebuild/talent/kunkka_3/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, start_pos)
	ParticleManager:SetParticleControl(pfx, 1, end_pos)
	DestroyParticleByDelay(pfx,5)
	Timers:CreateTimer(1.5, function()
		local damageTable = {
			-- victim = enemy,
			attacker = caster,
			damage = cleaveDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
		if self and not self:IsNull() then
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), start_pos, end_pos, nil, 200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
			EmitSoundOnLocationWithCaster(pos, "Hero_Sven.Layer.GodsStrength", caster)
			for i, enemy in pairs(tTargets) do
				
				damageTable.victim = enemy
				ApplyDamage(damageTable)

				if i>=9 then
					break
				end
			end
			
		end
	end)


	
end

function heroTalent_npc_dota_hero_kunkka_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/kunkka_3/effect.vpcf", context )
end

function heroTalent_npc_dota_hero_kunkka_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Tidebringer",costKeys)
			end
		end)
	
	end

end
