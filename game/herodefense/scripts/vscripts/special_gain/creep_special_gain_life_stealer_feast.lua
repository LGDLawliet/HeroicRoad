creep_special_gain_life_stealer_feast = class({})

LinkLuaModifier("modifier_creep_special_gain_life_stealer_feast", "special_gain/creep_special_gain_life_stealer_feast", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_life_stealer_feast:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_life_stealer_feast"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_life_stealer_feast = class({})

function modifier_creep_special_gain_life_stealer_feast:IsDebuff() return false end
function modifier_creep_special_gain_life_stealer_feast:IsHidden() return false end
function modifier_creep_special_gain_life_stealer_feast:IsPurgable() return false end
-- function modifier_creep_special_gain_life_stealer_feast:GetEffectName() return "particles/new_effect/creep_gain_effect/energy_gain_body_ambient.vpcf" end
-- function modifier_creep_special_gain_life_stealer_feast:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_life_stealer_feast:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	

	-- local shackle_particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_swoop_parent.vpcf", PATTACH_POINT_FOLLOW, parent)
	-- ParticleManager:SetParticleControlEnt(shackle_particle, 0, parent, PATTACH_CENTER_FOLLOW, nil, parent:GetAbsOrigin(), true)
	-- self:AddParticle(shackle_particle, true, false, -1, true, false)

	
end


function modifier_creep_special_gain_life_stealer_feast:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE

		

	}
end


function modifier_creep_special_gain_life_stealer_feast:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是技能伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		-- print("tg.damage_category="..tg.damage_category)

		local parent = self:GetParent()
		if not parent:IsAlive() then
			return
		end
        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
			local hp = 0
			hp=(tg.unit:GetMaxHealth()*0.002 + self:GetParent():GetMaxHealth()*0.01)*life_steal_gain
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
            parent:Heal(hp, self.ability)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, hp, nil)

        end 
    end 
end