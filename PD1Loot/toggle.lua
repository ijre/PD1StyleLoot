PD1Loot = not PD1Loot
managers.chat:_receive_message(1, "PD1-Style Loot Bags", tostring(PD1Loot):gsub("^%l", string.upper), tweak_data.system_chat_color)