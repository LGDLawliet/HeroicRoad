function Chaofeng() {
    // 发送数据到Lua请求打开UI
    // 即使没有数据第二个参数也要填
    GameEvents.SendCustomGameEventToServer( "chaofengta", {} );
}

function Chaofeng2() {
    // 发送数据到Lua请求打开UI
    // 即使没有数据第二个参数也要填

    // formatDateTime(1630216677)
    // $.Msg(formatDateTime(1630216677111));

    GameEvents.SendCustomGameEventToServer( "chaofengta2", {} );
}

