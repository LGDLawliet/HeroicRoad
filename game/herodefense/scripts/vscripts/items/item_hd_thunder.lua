item_hd_thunder = class({})

LinkLuaModifier("modifier_item_hd_thunder", "items/item_hd_thunder", LUA_MODIFIER_MOTION_NONE)

function item_hd_thunder:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", context )

end


function item_hd_thunder:GetIntrinsicModifierName()
	return "modifier_item_hd_thunder"
end

modifier_item_hd_thunder = advanced_modifier({})

function modifier_item_hd_thunder:IsDebuff() return false end
function modifier_item_hd_thunder:IsHidden() return false end
function modifier_item_hd_thunder:IsPurgable() return false end


function modifier_item_hd_thunder:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
	self.bonus_spell_amp = ability:GetSpecialValueFor("bonus_spell_amp")
	self.attack_speed_perspell = ability:GetSpecialValueFor("attack_speed_perspell")
	self.chance = ability:GetSpecialValueFor("chance")
	if IsServer() then
		self.ability = self:GetParent():FindAbilityByName("Advanced_Lightning_Bolt")
		self:StartIntervalThink(0.2)
	end
end


function modifier_item_hd_thunder:OnIntervalThink()
	self.ability = self:GetParent():FindAbilityByName("Advanced_Lightning_Bolt")
	local spell_amp = self:GetCaster():GetSpellAmplification(false)*self.attack_speed_perspell*100
	self:SetStackCount(math.max(spell_amp,0))
end



function modifier_item_hd_thunder:DeclareFunctions()
	return     {            
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
		MODIFIER_EVENT_ON_ATTACK_LANDED

	}
end
function modifier_item_hd_thunder:Advanced_GetModifierBonusStats_Intellect()return self.bonus_int end
function modifier_item_hd_thunder:Advanced_GetModifierSpellAmplifyBonus()return self.bonus_spell_amp end
function modifier_item_hd_thunder:GetModifierAttackSpeedBonus_Constant()return self:GetStackCount() end

function modifier_item_hd_thunder:OnAttackLanded(keys)
	if IsServer() then

		local ability = self:GetAbility()
		if keys.attacker == self:GetParent() and ability:IsCooldownReady() then

			local target =keys.target
			local caster = self:GetCaster()
			local pos = target:GetAbsOrigin()
			if target:IsAlive() and self:GetCaster():GetRandomEffect(self.chance,INT_TYPE,0)  > RandomInt(1, 100) then
		
				-- EmitSoundOnLocationWithCaster(pos "Hero_Zuus.GodsWrath", caster)
	
				self:GetAbility():UseResources(false, false, false, true)
				if self.ability and not self.ability:IsNull() and self.ability:IsCooldownReady() then
					if self.ability.unlock3 then
                        caster:SetCursorPosition(target:GetOrigin())
                        self.ability:OnSpellStart()
                       
                        return
                    else
                        caster:SetCursorCastTarget(target)
                        self.ability:OnSpellStart()
						self.ability:UseResources(false,false,false,true)
                        return
                    end
				else
					local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos)
					ParticleManager:SetParticleControl(pfx, 1, Vector(pos.x,pos.y,0))
					ParticleManager:SetParticleControl(pfx, 6, Vector(pos.x,pos.y,0))
					
					Timers:CreateTimer(0.05, function()
						if not target or target:IsNull() or not caster or caster:IsNull() then
							return
						end
						target:EmitSound("Hero_Disruptor.ThunderStrike.Target")
						local damageTable = {
							victim = target,
							attacker = caster,
							damage =caster:GetIntellect(false) * self:GetAbility():GetSpecialValueFor("damage_index"),
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
						ApplyDamage(damageTable)
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					
					end)
				end


	
			end
			


		end
	end
end

function modifier_item_hd_thunder:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS

    }
end
