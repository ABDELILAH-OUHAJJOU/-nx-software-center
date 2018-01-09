import QtQuick 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nxos.softwarecenter 1.0

Item {
    id: tasksViewRoot

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 6
        anchors.rightMargin: 6

        ListView {
            id: tasksListView

            clip: true

            model: TasksController.model
            spacing: 12
            delegate: TaskListItemDelegate {
            }
        }
    }
}
