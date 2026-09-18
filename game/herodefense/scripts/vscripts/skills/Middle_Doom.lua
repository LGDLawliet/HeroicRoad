
Middle_Doom = Middle_Doom or class({})

LinkLuaModifier("modifier_Middle_Doom", "skills/Middle_Doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Doom_damage", "skills/Middle_Doom", LUA_MODIFIER_MOTION_NONE)

function Middle_Doom:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_aura.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/doom/origin/domm_aura.vpcf", context )--新增：我做的,为了区分所以我特地写反名字，记得看清楚
	
end

function Middle_Doom:GetHealthCost(iLevel)--新增：切换时消耗自身生命值
	return self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor("max_hp_percent") * 0.01
end

function Middle_Doom:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Middle_Doom:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_Doom", self:GetCaster())
	self:GetCaster():StopSound("Hero_DoomBringer.Doom")
end

function Middle_Doom:OnToggle()
	if not IsServer() then
		return 
	end
	if self:GetToggleState() then
		--self:GetCaster():EmitSound("Hero_DoomBringer.Doom")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_Doom", {})
	else
		--self:GetCaster():StopSound("Hero_DoomBringer.Doom")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_Doom", self:GetCaster())
	end
	
end

function Middle_Doom:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end
---------------------------------------------------------------------------------------------------
modifier_Middle_Doom = advanced_modifier({})

function modifier_Middle_Doom:IsDebuff()				return false end
function modifier_Middle_Doom:IsHidden() 			return false end
function modifier_Middle_Doom:IsPurgable() 			return true end
function modifier_Middle_Doom:IsPurgeException() 	return true end

function modifier_Middle_Doom:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.limit = self.ability:GetSpecialValueFor("limit")
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
		self.heal = self.ability:GetSpecialValueFor("bonus_heal")*0.01
		self.think = self.ability:GetSpecialValueFor("hit_time")
		
		self.nFXIndex = ParticleManager:CreateParticle("particles/rebuild/spell/doom/origin/domm_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_ABSORIGIN_FOLLOW, "", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.nFXIndex, 0,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 1,Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 3, Vector(self.radius,1,1))
		ParticleManager:SetParticleControl(self.nFXIndex, 62, Vector(0,0,0))
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		self:GetParent():EmitSound("Hero_DoomBringer.Doom")

		self:StartIntervalThink(self.think)--修改：改为kv方便调整
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,--修改：对自身造成魔法伤害
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
	end
end

function modifier_Middle_Doom:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end


function modifier_Middle_Doom:OnIntervalThink()
	if not self.ability then
		self:SafeDestroy()
		return
	end
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.limit = self.ability:GetSpecialValueFor("limit")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.think = self.ability:GetSpecialValueFor("hit_time")
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01
	self.heal = self.ability:GetSpecialValueFor("bonus_heal")*0.01

	local damage = self.ability:GetSpecialValueFor( "basic_damage" ) + self.caster:HDGetPrimaryStatValue() * self.ability:GetSpecialValueFor( "bonus_damage" )--修改：改为力量技能
	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)

	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i,enemy in pairs(units) do
		enemy:AddNewModifier(self.caster, self.ability, "modifier_Middle_Doom_damage", {duration = self.think + 0.03,duration_stack = self.think + 0.03})--修改：因kv化，调整了写法
		if i>=self.limit then
			break
		end
	end
end

function modifier_Middle_Doom:ADDeclareFunctions()
	return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self.parent,nil},	
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
	}
end

-- function modifier_Middle_Doom:DeclareFunctions()
-- 	return 
-- 	{
-- 		MODIFIER_EVENT_ON_DEATH,
-- 	}
-- end

function modifier_Middle_Doom:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		if tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL		--伤害类型是技能伤害
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 		--不带反甲伤害标签
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 		--不带不造成吸血标签

			--该生命吸血受到吸血增强影响
            local life_steal_gain = self:GetParent():GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.bonus_life_steal*life_steal_gain
            hp = hp-hp%1
			-- print("hp="..hp)
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            self.parent:Heal(hp, self.ability)

        end 
    end 
end


function modifier_Middle_Doom:OnDeath(keys)
    if not IsServer() then
        return
    end
	--print("敌人死亡函数-生效")
    if keys.attacker == self.parent then
        keys.attacker:Heal(self.heal * keys.attacker:GetMaxHealth(), self.ability)
	--	print("敌人死亡生命回复-生效")
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, self.heal * keys.attacker:GetMaxHealth(), nil)
    end
   
end
---------------------------------------------------------------------------------------------------

modifier_Middle_Doom_damage = modifier_Middle_Doom_damage or class({})

function modifier_Middle_Doom_damage:IsDebuff()				return true end
function modifier_Middle_Doom_damage:IsHidden() 			return false end
function modifier_Middle_Doom_damage:IsPurgable() 			return true end
function modifier_Middle_Doom_damage:IsPurgeException() 	return true end
function modifier_Middle_Doom_damage:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_Middle_Doom_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Doom_damage:OnCreated(keys)
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


function modifier_Middle_Doom_damage:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = GameRules:GetGameTime() +keys.duration_stack })
		self:IncrementStackCount()
		self.think =self:GetAbility():GetSpecialValueFor("hit_time")
	end
end

function modifier_Middle_Doom_damage:OnIntervalThink()
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



