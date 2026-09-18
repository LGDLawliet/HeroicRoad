Primary_Double_Hit = class({})

LinkLuaModifier("modifier_Primary_Double_Hit_passive", "skills/Primary_Double_Hit", LUA_MODIFIER_MOTION_NONE)
function Primary_Double_Hit:GetIntrinsicModifierName() return "modifier_Primary_Double_Hit_passive" end

modifier_Primary_Double_Hit_passive = class({})
function modifier_Primary_Double_Hit_passive:IsDebuff()			return false end
function modifier_Primary_Double_Hit_passive:IsHidden() 			return true end
function modifier_Primary_Double_Hit_passive:IsPurgable() 		return false end  --不可驱散
function modifier_Primary_Double_Hit_passive:IsPurgeException() 	return false end

function modifier_Primary_Double_Hit_passive:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_Primary_Double_Hit_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
    if  self:GetAbility():IsCooldownReady() then
       if self:GetAbility():GetSpecialValueFor("bash_chance") > RandomInt(0,100) then

       
        self:GetAbility():UseResources(true, true, true,true)
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
	
		local attackEffectRecord = self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
        self:GetParent():PerformAttack(keys.target, false, true, true, true, false, false, true)--对一单位执行攻击。
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
        local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_crit_b.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		--DoCleaveAttack( self:GetParent(), keys.target, self:GetAbility(),50, 1,0,0, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
		ParticleManager:SetParticleControl(particle,0,self:GetParent():GetOrigin())
	
	     end
     end
end


