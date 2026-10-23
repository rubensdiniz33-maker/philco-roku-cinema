sub init()
    m.posterRow = m.top.findNode("posterRow")
    m.focusHint = m.top.findNode("focusHint")
    m.sectionTitle = m.top.findNode("sectionTitle")
    m.posters = []
    m.selectedIndex = 0

    titles = ["NOITE ELÉTRICA", "ÚLTIMO HORIZONTE", "CÓDIGO VERMELHO", "MUNDO SELVAGEM", "ÓRBITA"]
    colors = ["#3B163A", "#18324B", "#501B21", "#174038", "#25204F"]
    for i = 0 to titles.count() - 1
        card = createObject("roSGNode", "Group")
        card.id = "card" + i.toStr()
        card.translation = [i * 224, 0]

        panel = createObject("roSGNode", "Rectangle")
        panel.width = 198
        panel.height = 112
        panel.color = colors[i]
        panel.opacity = 1.0
        card.appendChild(panel)

        stripe = createObject("roSGNode", "Rectangle")
        stripe.translation = [0, 100]
        stripe.width = 198
        stripe.height = 12
        stripe.color = "#E50914"
        card.appendChild(stripe)

        label = createObject("roSGNode", "Label")
        label.translation = [12, 24]
        label.width = 174
        label.height = 60
        label.text = titles[i]
        label.color = "#FFFFFF"
        label.font = "font:MediumBoldSystemFont"
        label.wrap = true
        card.appendChild(label)

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
            card.scale = [1.06, 1.06]
            panel.opacity = 1.0
        else
            card.scale = [1.0, 1.0]
            panel.opacity = 0.72
        end if
    end for
    if m.focusHint <> invalid
        m.focusHint.text = "ITEM " + (m.selectedIndex + 1).toStr() + " DE " + m.posters.count().toStr()
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
            m.sectionTitle.text = "SELECIONADO: " + m.posters[m.selectedIndex].getChild(2).text
        end if
        return true
    else if key = "back"
        if m.sectionTitle <> invalid
            m.sectionTitle.text = "ESCOLHAS PARA SUA PRÓXIMA SESSÃO"
        end if
        return true
    end if
    return false
end function
