sub init()
    m.posterRow = m.top.findNode("posterRow")
    m.focusHint = m.top.findNode("focusHint")
    m.sectionTitle = m.top.findNode("sectionTitle")
    m.sectionKicker = m.top.findNode("sectionKicker")
    m.posters = []
    m.selectedIndex = 0

    titles = ["NOITE ELETRICA", "ULTIMO HORIZONTE", "CODIGO VERMELHO", "MUNDO SELVAGEM", "ORBITA"]
    tags = ["AÇÃO  •  DESTAQUE", "AVENTURA", "SUSPENSE", "NATUREZA", "FICÇÃO"]
    numbers = ["01", "02", "03", "04", "05"]
    colors = ["0x35101DFF", "0x14283FFF", "0x42131AFF", "0x12342EFF", "0x211B46FF"]
    accentColors = ["0xF04450FF", "0x47A7E8FF", "0xF04450FF", "0x3CC7A0FF", "0x9A83FFFF"]

    for i = 0 to titles.count() - 1
        card = createObject("roSGNode", "Group")
        card.id = "card" + i.toStr()
        card.translation = [i * 226, 0]

        panel = createObject("roSGNode", "Rectangle")
        panel.width = 208
        panel.height = 132
        panel.color = colors[i]
        panel.opacity = 1.0
        card.appendChild(panel)

        topLine = createObject("roSGNode", "Rectangle")
        topLine.width = 208
        topLine.height = 4
        topLine.color = accentColors[i]
        card.appendChild(topLine)

        number = createObject("roSGNode", "Label")
        number.translation = [14, 14]
        number.width = 52
        number.height = 24
        number.text = numbers[i]
        number.color = accentColors[i]
        number.font = "font:SmallBoldSystemFont"
        card.appendChild(number)

        label = createObject("roSGNode", "Label")
        label.translation = [14, 45]
        label.width = 180
        label.height = 48
        label.text = titles[i]
        label.color = "0xFFFFFFFF"
        label.font = "font:MediumBoldSystemFont"
        label.wrap = true
        card.appendChild(label)

        tag = createObject("roSGNode", "Label")
        tag.translation = [14, 105]
        tag.width = 182
        tag.height = 20
        tag.text = tags[i]
        tag.color = "0xD0D1D8FF"
        tag.font = "font:SmallSystemFont"
        card.appendChild(tag)

        m.posterRow.appendChild(card)
        m.posters.push(card)
    end for

    updateSelection()
    m.top.setFocus(true)
end sub

sub updateSelection()
    for i = 0 to m.posters.count() - 1
        card = m.posters[i]
        panel = card.getChild(0)
        if i = m.selectedIndex
            card.scale = [1.04, 1.04]
            panel.opacity = 1.0
        else
            card.scale = [1.0, 1.0]
            panel.opacity = 0.62
        end if
    end for

    if m.focusHint <> invalid
        itemNumber = "0" + (m.selectedIndex + 1).toStr()
        m.focusHint.text = itemNumber + " / " + m.posters.count().toStr()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        if m.selectedIndex < m.posters.count() - 1
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
        if m.sectionTitle <> invalid
            m.sectionTitle.text = m.posters[m.selectedIndex].getChild(3).text
        end if
        if m.sectionKicker <> invalid
            m.sectionKicker.text = "SELEÇÃO ATUAL"
        end if
        return true
    else if key = "back"
        if m.sectionTitle <> invalid
            m.sectionTitle.text = "ESCOLHAS PARA SUA PRÓXIMA SESSÃO"
        end if
        if m.sectionKicker <> invalid
            m.sectionKicker.text = "EM DESTAQUE"
        end if
        return true
    end if
    return false
end function
