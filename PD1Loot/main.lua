PD1Loot = true

local Disallow =
{
  alex_2 =
  { "meth" }
}

local function CheckDisallowed(id)
  local heistInDisallowedList = Disallow[managers.job:current_level_id()]

  return PD1Loot or (heistInDisallowedList and table.contains(heistInDisallowedList, id))
end

local origInteract = CarryInteractionExt.interact
function CarryInteractionExt:interact(plyr)
  local data = self._unit:carry_data()

  if tweak_data.carry[data:carry_id()].skip_exit_secure or CheckDisallowed(data:carry_id()) or not LuaNetworking:IsHost() or managers.player:player_id(plyr) ~= LuaNetworking:LocalPeerID() then
    return origInteract(self, plyr)
  end

  if self._unit:damage():has_sequence("interact") then
		self._unit:damage():run_sequence_simple("interact", { unit = plyr })
	end

	if self._unit:damage():has_sequence("load") then
		self._unit:damage():run_sequence_simple("load", { unit = plyr })
	end

  managers.mission:call_global_event("on_picked_up_carry", self._unit)

  if self._remove_on_interact then
    if self._unit == managers.interaction:active_unit() then
      self:interact_interupt(managers.player:player_unit(), false)
    end

    self:remove_interact()
    self:set_active(false, true)

    if alive(plyr) then
      self._unit:carry_data():trigger_load(plyr)
    end

    self._unit:set_slot(0)
  end

  managers.loot:server_secure_loot(data:carry_id(), data:multiplier(), false, LuaNetworking:LocalPeerID())
end