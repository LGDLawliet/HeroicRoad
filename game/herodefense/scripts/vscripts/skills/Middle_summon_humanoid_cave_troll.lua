

Middle_summon_humanoid_cave_troll						= Middle_summon_humanoid_cave_troll or class({})
LinkLuaModifier( "modifier_Middle_summon_humanoid_cave_troll_buff", "skills/Middle_summon_humanoid_cave_troll", LUA_MODIFIER_MOTION_NONE )



function Middle_summon_humanoid_cave_troll:IsSummonSpell()return true end



function Middle_summon_humanoid_cave_troll:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", context )
end

function Middle_summon_humanoid_cave_troll:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_cave_troll",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_humanoid_cave_troll/effect_explosion.vpcf", PATTACH_ABSORIGIN, unit)
		-- ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:SetParticleControlEnt(particle_cast_fx, 3, unit, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		unit:AddNewModifier(caster, self or nil, "modifier_Middle_summon_humanoid_cave_troll_buff", {}) 
		

	end	

end







modifier_Middle_summon_humanoid_cave_troll_buff = class({})

function modifier_Middle_summon_humanoid_cave_troll_buff:IsDebuff() return false end
function modifier_Middle_summon_humanoid_cave_troll_buff:IsHidden() return true end
function modifier_Middle_summon_humanoid_cave_troll_buff:IsPurgable() return false end


function modifier_Middle_summon_humanoid_cave_troll_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	}
end

function modifier_Middle_summon_humanoid_cave_troll_buff:OnAttackLanded(keys)
	if IsServer() then
		local parent = self:GetParent()
		if keys.attacker == parent and self:GetCaster():GetRandomEffect(10,INT_TYPE,1)  > RandomInt(1, 100) then
			if parent:IsInSpecialAttack() or not parent:IsApplyModifier() then
				return
			end
			local ability = self:GetAbility()



			local target =keys.target
			-- local pos = target:GetAbsOrigin()

			local tTargets = FindUnitsInRadius(parent:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 0, false)
			
			local damageTable = {

				attacker = parent,
				damage = keys.damage,
				damage_type = keys.damage_type,
				ability = ability, --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  , --Optional.
			}
			local count = 4
    		for i, hTarget in pairs(tTargets) do
				if hTarget~=target then
					damageTable.victim = hTarget
					ApplyDamage(damageTable)
					count = count - 1
					if count<=0 then
						break
					end
				end

    		end
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  parent )
			ParticleManager:SetParticleControl( nFXIndex, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 300, 300, 300 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			parent:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")

		end
	end
end