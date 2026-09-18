
Primary_Voodoo_Restoration = class({})
LinkLuaModifier("modifier_Primary_Voodoo_Restoration", "skills/Primary_Voodoo_Restoration", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Voodoo_Restoration_heal", "skills/Primary_Voodoo_Restoration", LUA_MODIFIER_MOTION_NONE)




function Primary_Voodoo_Restoration:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function Primary_Voodoo_Restoration:Spawn()
	if IsServer() then
		self.healingStack = 0
	end
end
function Primary_Voodoo_Restoration:StackHealing(stack)
	self.healingStack = self.healingStack + stack
end

function Primary_Voodoo_Restoration:GetHealingStackAndRefresh()
	local stack = self.healingStack
	self.healingStack = 0
	return stack
end


function Primary_Voodoo_Restoration:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_Voodoo_Restoration", {})
		self.healingStack = 0
	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_Primary_Voodoo_Restoration")
	end
end







modifier_Primary_Voodoo_Restoration = modifier_Primary_Voodoo_Restoration or class({})
function modifier_Primary_Voodoo_Restoration:IsDebuff() return false end
function modifier_Primary_Voodoo_Restoration:IsHidden() return true end
function modifier_Primary_Voodoo_Restoration:IsPurgable() return false end
function modifier_Primary_Voodoo_Restoration:IsPurgeException() return false end
function modifier_Primary_Voodoo_Restoration:IsAura()	return true end
function modifier_Primary_Voodoo_Restoration:IsAuraActiveOnDeath()	return false end
function modifier_Primary_Voodoo_Restoration:GetAuraRadius()	return self.radius end
function modifier_Primary_Voodoo_Restoration:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_Voodoo_Restoration:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Voodoo_Restoration:GetModifierAura()	return "modifier_Primary_Voodoo_Restoration_heal" end
function modifier_Primary_Voodoo_Restoration:OnCreated()
	if IsServer() and self:GetAbility():IsTrained() then
		local ability = self:GetAbility()
		self.interval = 1
		self.manacost = ability:GetSpecialValueFor("mana_cost_tick") * self.interval
		self.radius = ability:GetSpecialValueFor("radius")
		self:StartIntervalThink( self.interval )
		local name = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_witch_doctor_2") then
			name = "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf"
			self.talentToggle = true
		end
		self.mainParticle = ParticleManager:CreateParticle(name, PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_Primary_Voodoo_Restoration:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle then
			ParticleManager:DestroyParticle(self.mainParticle, false)
			ParticleManager:ReleaseParticleIndex(self.mainParticle)
		end
	end
end

function modifier_Primary_Voodoo_Restoration:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end

	local hAbility = self:GetAbility()
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	self.manacost = hAbility:GetSpecialValueFor("mana_cost_tick") * self.interval
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_witch_doctor_2") then
		self.manacost = self.manacost *0.3
	end
	if caster:GetMana() >= hAbility:GetManaCost(-1) then
		caster:Script_ReduceMana(self.manacost,self:GetAbility())
		if self.talentToggle then
			local stack = hAbility:GetHealingStackAndRefresh()
			if stack>0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for i, enemy in pairs(enemies) do
					self:PlayEffect(enemy)
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local damageTable = {
						-- victim = enemy,
						attacker = caster,
						damage = stack,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = hAbility, --Optional.
					}
					for i, enemy in pairs(enemies) do
						damageTable.victim = enemy
						ApplyDamage(damageTable)
					end

					break
				end
			end
		end
	else
		hAbility:ToggleAbility()
	end
end


function modifier_Primary_Voodoo_Restoration:PlayEffect(target)
	-- local caster = self:GetCaster()
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 50, 50, 0 ) )
	DestroyParticleByDelay(effect_cast,2)
end






-------------------------------------------
modifier_Primary_Voodoo_Restoration_heal = class({})
function modifier_Primary_Voodoo_Restoration_heal:IsDebuff() return false end
function modifier_Primary_Voodoo_Restoration_heal:IsHidden() return true end
function modifier_Primary_Voodoo_Restoration_heal:IsPurgable() return false end
function modifier_Primary_Voodoo_Restoration_heal:IsPurgeException() return false end
function modifier_Primary_Voodoo_Restoration_heal:IsStunDebuff() return false end
function modifier_Primary_Voodoo_Restoration_heal:RemoveOnDeath() return true end


-- function modifier_Primary_Voodoo_Restoration_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Why was this made to stack
-------------------------------------------
function modifier_Primary_Voodoo_Restoration_heal:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end
	if IsServer() then
		self.interval = 1
		self:StartIntervalThink( self.interval )
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_witch_doctor_2") then
			self.talentToggle = true
			
		end
	end
end

function modifier_Primary_Voodoo_Restoration_heal:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:SafeDestroy() return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local caster = self:GetCaster()
	local health = hParent:GetHealth()
	local heal	= hAbility:GetSpecialValueFor("basic_heal")+hAbility:GetSpecialValueFor("bonus_heal")*caster:GetIntellect(false)
	local healing = HealWithGain(heal,caster,hParent,hAbility)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, healing, nil)

	if self.talentToggle then
		hAbility:StackHealing(heal)
	end
end

