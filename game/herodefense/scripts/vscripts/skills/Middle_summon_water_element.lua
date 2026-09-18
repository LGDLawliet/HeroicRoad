
LinkLuaModifier( "modifier_Middle_summon_water_element_buff", "skills/Middle_summon_water_element", LUA_MODIFIER_MOTION_NONE )
Middle_summon_water_element						= Middle_summon_water_element or class({})
require("internal/timers")
function Middle_summon_water_element:IsSummonSpell()return true end
function Middle_summon_water_element:IsElementSummon()return true end

function Middle_summon_water_element:OnSpellStart()

	
	local caster =self:GetCaster()


	
	



	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 



	-- Add spawn particles in spawn location
	EmitSoundOn("Hero_Morphling.Waveform", caster)	
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
	for i = 1, 10, 1 do
		local pos =  unit_pos  + Vector(RandomInt(-1000, 1000),RandomInt(-1000, 1000),0)
		local new_pos = unit_pos+(pos-unit_pos):Normalized()*300
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, new_pos)
		ParticleManager:SetParticleControl(pfx, 1, (unit_pos - new_pos):Normalized() * 300)
		Timers(1.3, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex( pfx )
		end)	

	end
	
	local ability = self
	Timers(1.0, function()
		if not ability or ability:IsNull() then
			return
		end
		local unit = caster:SummonUnit("npc_hd_water_element",life_duration,
		unit_pos,
		self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
		unit:AddNewModifier(caster, self, "modifier_Middle_summon_water_element_buff", 
		{})
	end)




end





modifier_Middle_summon_water_element_buff= class({})

function modifier_Middle_summon_water_element_buff:IsDebuff()			return false end
function modifier_Middle_summon_water_element_buff:IsHidden() 			return false end
function modifier_Middle_summon_water_element_buff:IsPurgable() 		return false end
function modifier_Middle_summon_water_element_buff:IsPurgeException() 	return false end

function modifier_Middle_summon_water_element_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(3)
		self:StartIntervalThink(0.1)
	end
end

function modifier_Middle_summon_water_element_buff:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetHealthPercent()<=10 then
		local heal = parent:GetMaxHealth()*0.4
		local healing = HealWithGain(heal,self:GetCaster(),parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		self:DecrementStackCount()
		EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Target", parent)	
		local attachment = parent:ScriptLookupAttachment( "attach_attack1" )
		local info = 
							{
							Target = parent,
							Source = parent,
							Ability = self:GetAbility(),
							EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
							iMoveSpeed = 1000,
							vSourceLoc = parent:GetAttachmentOrigin(attachment),
							bDodgeable = false,
							bProvidesVision = false,
							flExpireTime = GameRules:GetGameTime() + 4,
							}

						ProjectileManager:CreateTrackingProjectile( info )
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end