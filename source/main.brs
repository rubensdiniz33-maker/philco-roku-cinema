sub Main()
    screen = CreateObject("roSGScreen")
    if screen = invalid then return

    port = CreateObject("roMessagePort")
    screen.setMessagePort(port)
    scene = screen.CreateScene("HomeScene")
    if scene = invalid then return
    screen.show()

    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
