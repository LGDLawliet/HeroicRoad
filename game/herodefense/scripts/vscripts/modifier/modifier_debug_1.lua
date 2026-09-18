modifier_debug_1 = class({})

function modifier_debug_1:IsDebuff()			return false end
function modifier_debug_1:IsHidden() 			return false end
function modifier_debug_1:IsPurgable() 		return false end
function modifier_debug_1:IsPurgeException() 	return false end
function modifier_debug_1:CheckState() return {
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	 } 
	end


	function modifier_debug_1:OnCreated(table)
		if IsServer() then
			print("created")
			self:StartIntervalThink(0.1)

			self.caster = self:GetCaster()
			self.parent = self:GetParent()
		end
	end

	function modifier_debug_1:OnIntervalThink()
		if IsServer() then
			AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 1000, 10, false)
		end
	end