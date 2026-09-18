--特效优化 √
Advanced_Nether_Blast = class({})

LinkLuaModifier("modifier_Advanced_Nether_Blast_debuff", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Blast_debuff2", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Blast_debuff_pre", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Blast_buff", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Blast_buff2", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Blast_unlock1_thinker", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Nether_Blast_unlock3", "skills/Advanced_Nether_Blast", LUA_MODIFIER_MOTION_NONE)
function Advanced_Nether_Blast:IsHiddenWhenStolen() 		return false end
function Advanced_Nether_Blast:IsRefreshable() 			return true end
function Advanced_Nether_Blast:IsStealable() 				return true end
function Advanced_Nether_Blast:IsNetherWardStealable()	return true end
function Advanced_Nether_Blast:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Advanced_Nether_Blast:CheckKV(key)
	local table = {

	


		basic_damage = 10,
		intelligence_index = 0.15,





	}
	local value = table[key] or -1
	return value

end


function Advanced_Nether_Blast:Precache( context )
	PrecacheResource( "particle", "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast_preview.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast.vpcf", context )
end

function Advanced_Nether_Blast:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Impetus_unlock2",{})
	return true
end
function Advanced_Nether_Blast:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Life_Drain_unlock2",{})
	return true
end
function Advanced_Nether_Blast:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Nether_Blast_unlock3",{})
	return true
end
function Advanced_Nether_Blast:GetChannelAnimation() return ACT_DOTA_GENERIC_CHANNEL_1 end
function Advanced_Nether_Blast:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED+DOTA_ABILITY_BEHAVIOR_AOE
		end
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end

	end
	return self.BaseClass.GetBehavior(self)
	
end
function Advanced_Nether_Blast:GetChannelTime()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return 9999
		end
	end
	return self.BaseClass.GetChannelTime(self)
end

function Advanced_Nether_Blast:OnSpellStart()

	local pos = self:GetCursorPosition()
	if self.unlock2 then
		self.think = 0
		self.count = 0
		self.mana_cost = self:GetManaCost(-1)
		self.pos = pos
		self.interval = 2
	end
	self:CastEffect(pos)


	if self.unlock1 then
		local kv = {}
		kv[ "duration" ] = 1.5
		kv[ "ring_count" ] = 1
		kv[ "preview_duration" ] = 1.5
		kv[ "max_rings" ] = 5
		kv[ "ring_now" ] =  self:GetSpecialValueFor("radius")
		kv[ "ring_step" ] = 150
		kv[ "ring_width" ] = 200
		CreateModifierThinker( self:GetCaster(), self, "modifier_Advanced_Nether_Blast_unlock1_thinker", kv, pos, self:GetCaster():GetTeamNumber(), false )

	end

end

function Advanced_Nether_Blast:CastEffect(pos)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local delay = self:GetSpecialValueFor("delay")
	local pfx_pre_name = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	local pfx_main_name = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
	local pfx_min = ParticleManager:CreateParticle(pfx_pre_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_min, 0, Vector(pos.x, pos.y, pos.z + 128))
	ParticleManager:SetParticleControl(pfx_min, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx_min)
	local ability = self
	Timers:CreateTimer(delay, function()
		if not ability or ability:IsNull() then
            return
        end
		local pfx_main = ParticleManager:CreateParticle(pfx_main_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_main, 0, Vector(pos.x, pos.y, pos.z + 128))
		ParticleManager:SetParticleControl(pfx_main, 1, Vector(radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(pfx_main)
		caster:EmitSound("Hero_Pugna.NetherBlast")
		local enemies_balst = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		self:BlastDamage(enemies_balst)
		return nil
	end
	)
end


function Advanced_Nether_Blast:OnChannelThink(time)

	self.think = self.think + time
	if self.think >=self.interval then
		self.think = 0
		local caster = self:GetCaster()
		local current_mana = caster:GetMana()
		self.count = self.count + 1
		self.interval = math.max(self.interval-0.05,0.2)
		local total_need = self.mana_cost * (1+0.5*self.count)
		local pass=  true
		if total_need>current_mana then
			local health_need = total_need- current_mana  --需求的血量
			if health_need>=caster:GetHealth() then
				pass =  false
			else
				caster:SpendMana( current_mana, self )
				caster:ModifyHealth(caster:GetHealth()  -health_need, self, false, 0)
			end
		else
			caster:SpendMana( total_need, self )
		end
		if pass then
			self:CastEffect(self.pos)
		else
			self:EndChannel(true)
		end

		

	end
end




function Advanced_Nether_Blast:BlastDamage(units)
	local caster = self:GetCaster()
	-- local enemies_balst = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local dmg = self:GetSpecialValueFor("basic_damage") + (self:GetSpecialValueFor("intelligence_index")) * caster:GetIntellect(false)
	for _, ememy_balst in pairs(units) do
		local buff = ememy_balst:AddNewModifier(caster, self, "modifier_Advanced_Nether_Blast_debuff_pre", {duration = 0.01})
		
		local damageTable = {
							victim = ememy_balst,
							attacker = self:GetCaster(),
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		buff:SafeDestroy()
		ememy_balst:AddNewModifier(caster, self, "modifier_Advanced_Nether_Blast_debuff", {duration = self:GetSpecialValueFor("buff_duration")})
		--LV15解锁分魂
		if self.advanced_level>=15 then
			ememy_balst:AddNewModifier(caster, self, "modifier_Advanced_Nether_Blast_debuff2", {duration = self:GetSpecialValueFor("buff_duration")})
		end

	end
end
modifier_Advanced_Nether_Blast_debuff = class({})

function modifier_Advanced_Nether_Blast_debuff:IsDebuff()			return true end
function modifier_Advanced_Nether_Blast_debuff:IsHidden() 			return false end
function modifier_Advanced_Nether_Blast_debuff:IsPurgable() 		return true end
function modifier_Advanced_Nether_Blast_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Nether_Blast_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end

function modifier_Advanced_Nether_Blast_debuff:GetModifierMagicalResistanceBonus() return self.reduce*self:GetStackCount() end
function modifier_Advanced_Nether_Blast_debuff:GetEffectName() return "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_wake.vpcf" end
function modifier_Advanced_Nether_Blast_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_Advanced_Nether_Blast_debuff:OnCreated(keys)
	self.reduce = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		self:IncrementStackCount()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Nether_Blast_buff", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
	end
end


function modifier_Advanced_Nether_Blast_debuff:OnRefresh(keys)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Nether_Blast_buff", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
		local max_stack = self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_stack")
		if self:GetAbility().advanced_level>=10 then
			max_stack =max_stack+4
		end
		if self:GetStackCount() < max_stack then
			self:IncrementStackCount()
		end
	end
end



modifier_Advanced_Nether_Blast_buff = class({})

function modifier_Advanced_Nether_Blast_buff:IsDebuff()			    return false end
function modifier_Advanced_Nether_Blast_buff:IsHidden() 			return false end
function modifier_Advanced_Nether_Blast_buff:IsPurgable() 		return true end
function modifier_Advanced_Nether_Blast_buff:IsPurgeException() 	return true end
function modifier_Advanced_Nether_Blast_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end

function modifier_Advanced_Nether_Blast_buff:GetModifierMagicalResistanceBonus() return (self:GetAbility():GetSpecialValueFor("magic_resistance_gain")*self:GetStackCount()) end
function modifier_Advanced_Nether_Blast_buff:GetEffectName() return "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6_wake.vpcf" end
function modifier_Advanced_Nether_Blast_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_Advanced_Nether_Blast_buff:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Nether_Blast_buff:OnRefresh(keys)
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("magic_resistance_gain_stack") then
			self:IncrementStackCount()
		end
	end
end



modifier_Advanced_Nether_Blast_debuff_pre = class({})

function modifier_Advanced_Nether_Blast_debuff_pre:IsDebuff()			return true end
function modifier_Advanced_Nether_Blast_debuff_pre:IsHidden() 			return false end
function modifier_Advanced_Nether_Blast_debuff_pre:IsPurgable() 		return false end
function modifier_Advanced_Nether_Blast_debuff_pre:IsPurgeException() 	return false end
function modifier_Advanced_Nether_Blast_debuff_pre:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Nether_Blast_debuff_pre:OnCreated(table)
	if IsServer() then
		self.magic_resistance_reduce =-self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_pre")
		if self:GetAbility().advanced_level>=5 then
			self.magic_resistance_reduce = -80
		end
		if self:GetAbility().advanced_level>=20 then
			self.magic_resistance_reduce = -120
		end
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_pugna_2") then
			self.magic_resistance_reduce = self.magic_resistance_reduce * 2
		end
	end
end


function modifier_Advanced_Nether_Blast_debuff_pre:GetModifierMagicalResistanceBonus() return self.magic_resistance_reduce end








modifier_Advanced_Nether_Blast_debuff2 = advanced_modifier({})

function modifier_Advanced_Nether_Blast_debuff2:IsDebuff()			return true end
function modifier_Advanced_Nether_Blast_debuff2:IsHidden() 			return false end
function modifier_Advanced_Nether_Blast_debuff2:IsPurgable() 		return true end
function modifier_Advanced_Nether_Blast_debuff2:IsPurgeException() 	return true end
function modifier_Advanced_Nether_Blast_debuff2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_Nether_Blast_debuff2:Advanced_GetModifierSpellAmplifyBonus() return (0 - 3*self:GetStackCount()) end


function modifier_Advanced_Nether_Blast_debuff2:OnCreated(keys)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		self:IncrementStackCount()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Nether_Blast_buff2", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
	end
end


function modifier_Advanced_Nether_Blast_debuff2:OnRefresh(keys)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Nether_Blast_buff2", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
		if self:GetStackCount() < 5 then
			self:IncrementStackCount()
		end
	end
end



modifier_Advanced_Nether_Blast_buff2 = advanced_modifier({})

function modifier_Advanced_Nether_Blast_buff2:IsDebuff()			    return false end
function modifier_Advanced_Nether_Blast_buff2:IsHidden() 			return false end
function modifier_Advanced_Nether_Blast_buff2:IsPurgable() 		return true end
function modifier_Advanced_Nether_Blast_buff2:IsPurgeException() 	return true end
function modifier_Advanced_Nether_Blast_buff2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_Nether_Blast_buff2:Advanced_GetModifierSpellAmplifyBonus() return (self:GetStackCount()) end


function modifier_Advanced_Nether_Blast_buff2:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Nether_Blast_buff2:OnRefresh(keys)
	if IsServer() then
		if self:GetStackCount() < 25 then
			self:IncrementStackCount()
		end
	end
end


modifier_Advanced_Nether_Blast_unlock1_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_Advanced_Nether_Blast_unlock1_thinker:OnCreated( kv )
	if IsServer() then
		self.bProcessDestruction = true
		self.max_rings = kv.max_rings
		self.preview_duration = kv.preview_duration
		self.current_ring = kv.ring_count
		self.ring_step = kv.ring_step
		self.ring_width = kv.ring_width
		self.ring_radius = self.ring_step +kv.ring_now
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast_preview.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.ring_radius, self.ring_width, self.preview_duration ) )

		EmitSoundOn( "Hero_Pugna.NetherBlastPreCast", self:GetCaster() )
	end
end

function modifier_Advanced_Nether_Blast_unlock1_thinker:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and self:GetCaster() ~= nil then
			local ability = self:GetAbility()
			if ability then
				ParticleManager:DestroyParticle( self.nPreviewFX, false )

				local nDamageFX = ParticleManager:CreateParticle( "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
				ParticleManager:SetParticleControl( nDamageFX, 0, self:GetParent():GetOrigin() )
				ParticleManager:SetParticleControl( nDamageFX, 1, Vector( self.ring_radius, self.ring_width, 0) )

				EmitSoundOn( "Hero_Pugna.NetherBlast", self:GetCaster() )


				local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.ring_radius + self.ring_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				local units = {}
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil then
						if (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length() >= self.ring_radius - self.ring_width then
							table.insert(units,enemy)
						end
					end
				end
				ability:BlastDamage(units)


				if self.current_ring <= self.max_rings then
					local kv = {}
					kv[ "duration" ] = self.preview_duration
					kv[ "ring_count" ] = self.current_ring + 1
					kv[ "preview_duration" ] = self.preview_duration
					kv[ "max_rings" ] = self.max_rings
					kv[ "ring_now" ] = self.ring_radius
					kv[ "ring_step" ] = self.ring_step
					kv[ "ring_width" ] = self.ring_width

					self.hThinker = CreateModifierThinker( self:GetCaster(), ability, "modifier_Advanced_Nether_Blast_unlock1_thinker", kv, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
				end
			end
		end
		UTIL_Remove( self:GetParent() )
	end
end









modifier_Advanced_Nether_Blast_unlock3 = class({})

function modifier_Advanced_Nether_Blast_unlock3:IsDebuff()			return false end
function modifier_Advanced_Nether_Blast_unlock3:IsHidden() 			return true end
function modifier_Advanced_Nether_Blast_unlock3:IsPurgable() 		    return false end
function modifier_Advanced_Nether_Blast_unlock3:IsPurgeException() return false end
function modifier_Advanced_Nether_Blast_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Nether_Blast_unlock3:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(FrameTime()*2)     

    end
end
function modifier_Advanced_Nether_Blast_unlock3:OnIntervalThink()
	local selfAbility = self:GetAbility()
    if selfAbility:IsCooldownReady() and   CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)>=350 then
		selfAbility:StartCooldown(0.3)
		selfAbility:CastEffect(self.currentPos)
        selfAbility:CastEffect(self.parent:GetAbsOrigin())
    end

	self.currentPos = self.parent:GetAbsOrigin()
end
