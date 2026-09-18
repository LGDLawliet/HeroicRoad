
Middle_Shallow_Grave = class({})

LinkLuaModifier("modifier_Middle_Shallow_Grave", "skills/Middle_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)




function Middle_Shallow_Grave:IsHiddenWhenStolen() 	return false end
function Middle_Shallow_Grave:IsRefreshable() 			return false  end
function Middle_Shallow_Grave:IsStealable() 			return true  end
function Middle_Shallow_Grave:IsNetherWardStealable()	return true end

function Middle_Shallow_Grave:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("cast_range") end



function Middle_Shallow_Grave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:AddNewModifier(caster, self, "modifier_Middle_Shallow_Grave", {duration = self:GetSpecialValueFor("duration")})

	--群体效果
	-- local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- for _,target in pairs(enemies) do
	-- 	target:AddNewModifier(caster, self, "modifier_Middle_Shallow_Grave", {duration = self:GetSpecialValueFor("duration")})
	-- end

end

modifier_Middle_Shallow_Grave = class({})

function modifier_Middle_Shallow_Grave:IsDebuff()				return false end
function modifier_Middle_Shallow_Grave:IsHidden() 			return false end
function modifier_Middle_Shallow_Grave:IsPurgable() 			return false end
function modifier_Middle_Shallow_Grave:IsPurgeException() 	return false end
function modifier_Middle_Shallow_Grave:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf" end
function modifier_Middle_Shallow_Grave:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Middle_Shallow_Grave:OnCreated()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
	end
end

function modifier_Middle_Shallow_Grave:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH}
end

function modifier_Middle_Shallow_Grave:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or self:GetParent():GetHealth()-keys.damage > 1 then
		return
	end

	local damage =(keys.damage-self:GetParent():GetHealth())  *self:GetAbility():GetSpecialValueFor("change_damage")*0.01
	damage = damage - damage%1
	self:SetStackCount(self:GetStackCount() + damage)
	--04_27 add by MysticBug
	-- if self:GetCaster():HasScepter() and self:GetStackCount() >= (self:GetCaster():GetMaxHealth()*2) then 
	-- 	self:Destroy()
	-- end
end

function modifier_Middle_Shallow_Grave:GetMinHealth() return 1 end

function modifier_Middle_Shallow_Grave:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
		-- self:GetParent():Heal(self:GetStackCount(), self:GetCaster())
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetStackCount(), nil)
		local caster = self:GetCaster()
		local unit = self:GetParent()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("damage_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies == 0 or self:GetStackCount() < 1 then
			return
		end
		local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf", caster), PATTACH_CUSTOMORIGIN, unit)
		ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		local damage = math.min(self:GetStackCount(),caster:GetMaxMana()*20)
	    for _,target in pairs(enemies) do
			local damageTable = {
				attacker = caster,
				victim = target,
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			}
			ApplyDamage(damageTable) 
		end
	end
end


function modifier_Middle_Shallow_Grave:KillPre() self:Destroy() end  