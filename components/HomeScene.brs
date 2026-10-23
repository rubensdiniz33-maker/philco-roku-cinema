sub init()
    m.posterRow = m.top.findNode("posterRow")
    m.focusHint = m.top.findNode("focusHint")
    m.sectionTitle = m.top.findNode("sectionTitle")
    m.heroTitle = m.top.findNode("heroTitle")
    m.heroDescription = m.top.findNode("heroDescription")
    m.exploreLabel = m.top.findNode("exploreLabel")
    m.posters = []
    m.apps = []
    m.selectedIndex = 0
    m.visibleCount = 5
    m.cardWidth = 234
    m.rowX = 52
    m.loadError = ""

    loadInstalledApps()
    buildCards()
    updateSelection()
    m.top.setFocus(true)
end sub

sub loadInstalledApps()
    deviceInfo = CreateObject("roDeviceInfo")
    addresses = deviceInfo.GetIPAddrs()
    ipAddress = ""

    if addresses <> invalid
        for each key in addresses
            value = addresses[key]
            if value <> invalid and value <> "" and value <> "0.0.0.0" and Instr(1, value, ".") > 0 and Instr(1, value, ":") = 0
                ipAddress = value
                exit for
            end if
        end for
    end if

    if ipAddress = ""
        m.loadError = "Nao foi possivel identificar o IP IPv4 da TV."
        return
    end if

    transfer = CreateObject("roURLTransfer")
    transfer.SetUrl("http://" + ipAddress + ":8060/query/apps")
    response = transfer.GetToString()

    if response = invalid or response = ""
        m.loadError = "A TV nao respondeu a consulta local de aplicativos."
        return
    end if

    root = CreateObject("roXMLElement")
    if not root.Parse(response)
        m.loadError = "A resposta da TV nao pode ser interpretada."
        return
    end if

    children = root.GetChildElements()
    if children = invalid
        m.loadError = "A TV nao retornou uma lista de aplicativos."
        return
    end if

    for each appNode in children
        if LCase(appNode.GetName()) = "app"
            attrs = appNode.GetAttributes()
            if attrs <> invalid
                appId = attrs["id"]
                appName = Trim(appNode.GetText())
                if appId <> invalid and appId <> "" and appId <> "dev" and appName <> ""
                    item = {
                        id: appId
                        title: appName
                    }
                    m.apps.Push(item)
                end if
            end if
        end if
    end for

    if m.apps.Count() = 0
        m.loadError = "A consulta respondeu, mas nao encontrou canais instalados."
    else
        m.loadError = ""
    end if
end sub

sub buildCards()
    if m.loadError <> ""
        m.heroTitle.text = "CENTRAL DE APLICATIVOS"
        m.heroDescription.text = m.loadError
        m.sectionTitle.text = "TESTE DE ACESSO AOS APLICATIVOS"
        m.exploreLabel.text = "CONSULTA INDISPONIVEL"
        m.focusHint.text = "ERRO"
        return
    end if

    colors = ["0x35101DFF", "0x14283FFF", "0x42131AFF", "0x12342EFF", "0x211B46FF"]
    accentColors = ["0xF04450FF", "0x47A7E8FF", "0xF04450FF", "0x3CC7A0FF", "0x9A83FFFF"]

    for i = 0 to m.apps.Count() - 1
        app = m.apps[i]
        card = CreateObject("roSGNode", "Group")
        card.id = "appCard" + i.ToStr()
        card.translation = [i * m.cardWidth, 0]

        panel = CreateObject("roSGNode", "Rectangle")
        panel.width = 218
        panel.height = 142
        panel.color = colors[i mod colors.Count()]
        panel.opacity = 1.0
        card.AppendChild(panel)

        topLine = CreateObject("roSGNode", "Rectangle")
        topLine.width = 218
        topLine.height = 4
        topLine.color = accentColors[i mod accentColors.Count()]
        card.AppendChild(topLine)

        number = CreateObject("roSGNode", "Label")
        number.translation = [16, 14]
        number.width = 52
        number.height = 24
        number.text = Right("0" + (i + 1).ToStr(), 2)
        number.color = accentColors[i mod accentColors.Count()]
        number.font = "font:SmallBoldSystemFont"
        card.AppendChild(number)

        label = CreateObject("roSGNode", "Label")
        label.translation = [16, 48]
        label.width = 188
        label.height = 48
        label.text = app.title
        label.color = "0xFFFFFFFF"
        label.font = "font:MediumBoldSystemFont"
        label.wrap = true
        card.AppendChild(label)

        tag = CreateObject("roSGNode", "Label")
        tag.translation = [16, 116]
        tag.width = 184
        tag.height = 18
        tag.text = "CANAL INSTALADO"
        tag.color = "0xD0D1D8FF"
        tag.font = "font:SmallBoldSystemFont"
        card.AppendChild(tag)

        m.posterRow.AppendChild(card)
        m.posters.Push(card)
    end for

    m.heroTitle.text = "SEUS APLICATIVOS"
    m.heroDescription.text = m.apps.Count().ToStr() + " canais encontrados na consulta local da TV."
    m.sectionTitle.text = "APLICATIVOS INSTALADOS"
    m.exploreLabel.text = "OK  •  ABRIR APLICATIVO"
end sub

sub updateSelection()
    if m.posters.Count() = 0
        return
    end if

    for i = 0 to m.posters.Count() - 1
        card = m.posters[i]
        panel = card.GetChild(0)
        topLine = card.GetChild(1)
        if i = m.selectedIndex
            card.scale = [1.04, 1.04]
            panel.opacity = 1.0
            topLine.opacity = 1.0
        else
            card.scale = [1.0, 1.0]
            panel.opacity = 0.52
            topLine.opacity = 0.55
        end if
    end for

    firstVisible = 0
    if m.selectedIndex >= m.visibleCount
        firstVisible = m.selectedIndex - m.visibleCount + 1
    end if
    m.posterRow.translation = [m.rowX - (firstVisible * m.cardWidth), 500]

    if m.focusHint <> invalid
        m.focusHint.text = (m.selectedIndex + 1).ToStr() + " / " + m.posters.Count().ToStr()
    end if
end sub

sub launchSelectedApp()
    if m.apps.Count() = 0
        return
    end if

    selectedApp = m.apps[m.selectedIndex]
    deviceInfo = CreateObject("roDeviceInfo")
    addresses = deviceInfo.GetIPAddrs()
    ipAddress = ""

    if addresses <> invalid
        for each key in addresses
            value = addresses[key]
            if value <> invalid and value <> "" and value <> "0.0.0.0" and Instr(1, value, ".") > 0 and Instr(1, value, ":") = 0
                ipAddress = value
                exit for
            end if
        end for
    end if

    if ipAddress = ""
        m.heroDescription.text = "Nao foi possivel identificar o IP IPv4 da TV."
        return
    end if

    transfer = CreateObject("roURLTransfer")
    transfer.SetUrl("http://" + ipAddress + ":8060/launch/" + selectedApp.id)
    result = transfer.PostFromString("")
    if result
        m.heroDescription.text = "Comando enviado para: " + selectedApp.title
    else
        m.heroDescription.text = "O sistema nao aceitou o comando de abertura para: " + selectedApp.title
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        if m.selectedIndex < m.posters.Count() - 1
            m.selectedIndex = m.selectedIndex + 1
            updateSelection()
        end if
        return true
    else if key = "left"
        if m.selectedIndex > 0
            m.selectedIndex = m.selectedIndex - 1
            updateSelection()
        end if
        return true
    else if key = "OK"
        launchSelectedApp()
        return true
    else if key = "back"
        m.selectedIndex = 0
        updateSelection()
        return true
    end if
    return false
end function
