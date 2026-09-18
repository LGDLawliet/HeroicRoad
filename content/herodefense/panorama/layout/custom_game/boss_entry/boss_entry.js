GameEvents.Subscribe( "Boss_entry_send",Boss_entry_send)
function Boss_entry_send(data){
    $.Msg("Boss_entry_send test")
    $.Msg(data)
}