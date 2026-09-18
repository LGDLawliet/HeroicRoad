heroTalent_npc_dota_hero_kunkka_4 = class({})
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_4", "heroTalent/heroTalent_npc_dota_hero_kunkka_4", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_4_debuff", "heroTalent/heroTalent_npc_dota_hero_kunkka_4", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_kunkka_4:Trigger(damageTable)
	local caster = self:GetCaster()
	local newTable = table.shallowCopy(damageTable)



	caster:GameTimer(0.06, function()
		if IsValid(newTable.victim) and newTable.victim:IsAlive() then
			caster:EmitSound("Hero_Terrorblade.Reflection")
			-- caster:EmitSound("Hero_Sven.Layer.GodsStrength")
		
			local pos = newTable.victim:GetAbsOrigin()
			pos.z = caster:GetOrigin().z
		
			local new_pos = pos + Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		
			local direction = CalculateDirection(new_pos,pos)
			local start_pos = pos + direction * 250+Vector(0,0,128)
			local end_pos = pos - direction * 250+Vector(0,0,128)
			local pfx = ParticleManager:CreateParticle("particles/rebuild/talent/kunkka_4/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, start_pos)
			ParticleManager:SetParticleControl(pfx, 1, end_pos)
			DestroyParticleByDelay(pfx,2)
		
			ApplyDamage(newTable)
		end
	end)



	
end

function heroTalent_npc_dota_hero_kunkka_4:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/kunkka_4/effect.vpcf", context )
end



function heroTalent_npc_dota_hero_kunkka_4:Spawn()
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
