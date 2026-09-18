
Middle_Shadow_Wave = class({})


function Middle_Shadow_Wave:IsHiddenWhenStolen() 		return false end
function Middle_Shadow_Wave:IsRefreshable() 			return true  end
function Middle_Shadow_Wave:IsStealable() 				return true  end
function Middle_Shadow_Wave:IsNetherWardStealable()	return true end

function Middle_Shadow_Wave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local units = {}
	local radius = self:GetSpecialValueFor("bounce_radius")
	units[#units + 1] = target
	local max_target = self:GetSpecialValueFor("bounce_number")
	for _, aunit in pairs(units) do
		local units1 = FindUnitsInRadius(caster:GetTeamNumber(), aunit:GetAbsOrigin(), nil, radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == caster then  --判断取出的单位是否是施法者或已存在于列表中
					no_yet = false                        --如果是 则纪录
					break
				end
			end
			if no_yet then
				units[#units + 1] = unit1
				break
			end
			if #units > max_target then
				break
			end
		end
	end
	if caster ~= target then   --施法对象不上自身则插入自身
		table.insert(units, 1, caster)
	end

	local pfx_wave = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9.vpcf"
	local pfx_damage = "particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_impact_damage.vpcf"

	for k, unit in pairs(units) do
		local i = (k == #units) and k or (k + 1)
		local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
		if unit == caster then
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		else
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControlEnt(pfx, 1, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i]:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		local health = ((unit:GetMaxHealth() - unit:GetHealth()) * (self:GetSpecialValueFor("bonus_hp") / 100) + self:GetSpecialValueFor("basic_damage")+self:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false))
		local healing = HealWithGain(health,caster,unit,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Dazzle.Shadow_Wave", caster)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self:GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = health,
					damage_type = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
					}
                ApplyDamage(damageTable)
                local pfx2 = ParticleManager:CreateParticle(pfx_damage, PATTACH_CUSTOMORIGIN, enemy)
                ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(pfx2, 1, enemy:GetAbsOrigin() + (enemy:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * 100)
                ParticleManager:ReleaseParticleIndex(pfx2)
			end
		end
	end
end

