
Primary_Doom = Primary_Doom or class({})

LinkLuaModifier("modifier_Primary_Doom", "skills/Primary_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Doom_damage", "skills/Primary_Doom", LUA_MODIFIER_MOTION_NONE)
function Primary_Doom:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_aura.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/doom/origin/domm_aura.vpcf", context )--新增：我做的,为了区分所以我特地写反名字，记得看清楚
	
end

function Primary_Doom:GetHealthCost(iLevel)--新增：切换时消耗自身生命值
	return self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor("max_hp_percent") * 0.01
end

function Primary_Doom:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Primary_Doom:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_Primary_Doom", self:GetCaster())
	self:GetCaster():StopSound("Hero_DoomBringer.Doom")
end

function Primary_Doom:OnToggle()
	if not IsServer() then
		return 
	end
	if self:GetToggleState() then
		--self:GetCaster():EmitSound("Hero_DoomBringer.Doom")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_Doom", {})
	else
		--self:GetCaster():StopSound("Hero_DoomBringer.Doom")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Primary_Doom", self:GetCaster())
	end
	
end

function Primary_Doom:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end

--注释：因功能更改，帮助错误提示被取消-------------------------------------------------------------------------------
--function Primary_Doom:GetCustomCastErrorTarget(target)
--	return "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
--end

--function Primary_Doom:CastFilterResultTarget(target)
--	if IsServer() then
--		local caster = self:GetCaster()
--		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
--			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
--				return UF_FAIL_CUSTOM
--			end
--			
--		end
--		return UF_SUCCESS
--	end
--end
--注释：因功能更改，帮助错误提示被取消-------------------------------------------------------------------------------

--注释：因功能更改，主动释放取消-------------------------------------------------------------------------------------
--function Primary_Doom:OnSpellStart(scepter)
--	local caster = self:GetCaster()
--	local target = self:GetCursorTarget()	
--	target:AddNewModifier(caster, self, "modifier_Primary_Doom", {duration = self:GetSpecialValueFor("duration")})

	-- caster:EmitSound("Hero_DoomBringer.Doom")
--end
--注释：因功能更改，主动释放取消-------------------------------------------------------------------------------------

modifier_Primary_Doom = modifier_Primary_Doom or class({})

function modifier_Primary_Doom:IsDebuff()				return false end
function modifier_Primary_Doom:IsHidden() 			return false end
function modifier_Primary_Doom:IsPurgable() 			return true end
function modifier_Primary_Doom:IsPurgeException() 	return true end

function modifier_Primary_Doom:OnCreated()
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.caster = self:GetCaster()
		
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/spell/doom/origin/domm_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_ABSORIGIN_FOLLOW, "", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 0,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 1,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 62, Vector(0,0,0))

		self:AddParticle(self.nFXIndex, false, false, -1, false, false)

		self.think = self:GetAbility():GetSpecialValueFor("hit_time")
		self:GetParent():EmitSound("Hero_DoomBringer.Doom")
		self:StartIntervalThink(self.think)--修改：改为kv方便调整
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,--修改：对自身造成魔法伤害
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self:GetAbility(), --Optional.
		}
	end
end

function modifier_Primary_Doom:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end


function modifier_Primary_Doom:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local radius = ability:GetSpecialValueFor("radius")
	local limit = ability:GetSpecialValueFor("limit")
	self.think = ability:GetSpecialValueFor("hit_time")
	local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:HDGetPrimaryStatValue() * ability:GetSpecialValueFor( "bonus_damage" )--修改：改为力量技能
	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i,enemy in pairs(units) do
		enemy:AddNewModifier(caster, ability, "modifier_Primary_Doom_damage", {duration = self.think + 0.03,duration_stack = self.think + 0.03})--修改：因kv化，调整了写法
		if i>=limit then
			break
		end
	end
end


modifier_Primary_Doom_damage = modifier_Primary_Doom_damage or class({})

function modifier_Primary_Doom_damage:IsDebuff()				return true end
function modifier_Primary_Doom_damage:IsHidden() 			return false end
function modifier_Primary_Doom_damage:IsPurgable() 			return true end
function modifier_Primary_Doom_damage:IsPurgeException() 	return true end
function modifier_Primary_Doom_damage:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_Primary_Doom_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Doom_damage:OnCreated(keys)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = GameRules:GetGameTime() +keys.duration_stack})
		self:IncrementStackCount()
		self:StartIntervalThink(0.06)
		self.timer = GameRules:GetGameTime()+0.5
		self.think =self:GetAbility():GetSpecialValueFor("hit_time")		
		-- self:StartIntervalThink(1)
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}
	end
end


function modifier_Primary_Doom_damage:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = GameRules:GetGameTime() +keys.duration_stack })
		self:IncrementStackCount()
		self.think =self:GetAbility():GetSpecialValueFor("hit_time")
	end
end

function modifier_Primary_Doom_damage:OnIntervalThink()
	if IsServer() then

		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
		if self.timer<=fGameTime then
			local ability = self:GetAbility()
			if not ability then
				self:SafeDestroy()
				return
			end
			self.timer = fGameTime + self.think--修改：匹配伤害间隔
		
			local caster = self:GetCaster()
			local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:HDGetPrimaryStatValue() * ability:GetSpecialValueFor( "bonus_damage" )--修改：改为力量技能
			local damage_enemy_index = ability:GetSpecialValueFor( "damage_mul" )*0.01
			self.damageTable.damage = damage * damage_enemy_index * self:GetStackCount()
			ApplyDamage(self.damageTable)
		end
	end
end


