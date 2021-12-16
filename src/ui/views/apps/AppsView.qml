import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.maui.nxsc 1.0
import NXModels 1.0 as NX
import "../../templates"

Maui.Page
{
    id: control

    Maui.Dialog
    {
        id: appLaunchErrorDialog

        title: i18n("Error")
        message: i18n("Error launching application")
        rejectButton.visible: false

        acceptButton.onClicked:
        {
            appLaunchErrorDialog.visible = false;
        }

        function showDialog(fileName, errCode)
        {
            switch (errCode)
            {
            case 0:
                message = "Error launching application <b>" + fileName + "</b>. Please check if you have correct permission"
                break;

            default:
                message = "Error launching application " + fileName
                break;
            }

            appLaunchErrorDialog.visible = true;
        }
    }

    Maui.Dialog
    {
        id: appUpdateDialog

        title: i18n("AppImage Update")
        message: i18n("Please wait...")
        rejectButton.visible: false

        acceptButton.onClicked:
        {
            appUpdateDialog.visible = false;
        }

        function showDialog(fileName, status)
        {
            message = status

            appUpdateDialog.visible = true;
        }
    }

    Maui.Dialog
    {
        id: appRemoveDialog

        property int index : -1

        title: i18n("Remove")
        message: i18n("Are you sure you want to remove this application?")
        template.iconSource: "emblem-warning"
        page.margins: Maui.Style.space.big
        spacing: Maui.Style.space.medium
        onRejected: appRemoveDialog.close()
        onAccepted:
        {
            _appsList.removeApp(index);
        }
    }

    headBar.forceCenterMiddleContent: isWide
    headBar.middleContent: Maui.TextField
    {
        id: _filterBar
        Layout.fillWidth: true
        Layout.maximumWidth: 500
        placeholderText: i18n("Filter %1 installed apps", ApplicationsRegistry.rowCount())
        onAccepted: ApplicationsRegistry.filterRegExp = RegExp(text)
        onCleared:  ApplicationsRegistry.filterRegExp = ""
    }

    headBar.rightContent: [
        Button
        {
            text: qsTr("Check for Updates")
            visible: !_appsList.isUpdateAvailable
            onClicked:
            {
                taskManagerCtx.doCheckUpdate(_appsList);
            }
        },

        Button
        {
            text: qsTr("Update All")
            visible: _appsList.isUpdateAvailable
            onClicked:
            {
                taskManagerCtx.doUpdateAll(_appsList);
            }
        },

        Maui.ToolButtonMenu
        {
            icon.name: "view-sort"

            MenuItem
            {
                text: i18n("Name")
                checkable: true
                autoExclusive: true
                checked: ApplicationsRegistry.sortRole === ApplicationRegistryRoles.Name
                onTriggered: ApplicationsRegistry.sortRole = ApplicationRegistryRoles.Name
            }

            MenuItem
            {
                text: i18n("Category")
                checkable: true
                autoExclusive: true
                checked: ApplicationsRegistry.sortRole === ApplicationRegistryRoles.XdgCategories
                onTriggered: ApplicationsRegistry.sortRole = ApplicationRegistryRoles.XdgCategories
            }
        }
    ]

    Maui.Holder
    {
        anchors.fill: parent
        title: i18n("Oops!")
        body: i18n("No apps found")
        visible: _appsListView.count === 0
        emoji: "qrc:/store.svg"
        emojiSize: Maui.Style.iconSizes.huge
    }

    Maui.ListBrowser
    {
        id: _appsListView
        anchors.fill: parent
        orientation: ListView.Vertical
        spacing: Maui.Style.space.medium
        section.property: ApplicationsRegistry.sortRoleName
        section.criteria:  ApplicationsRegistry.sortRole === ApplicationRegistryRoles.Name ? ViewSection.FirstCharacter : ViewSection.FullString
        section.delegate: Maui.LabelDelegate
        {
            id: delegate
            label:   String(section)

            isSection: true

            height: Maui.Style.toolBarHeightAlt
            width: parent.width
        }

        model: ApplicationsRegistry

        delegate: Maui.SwipeBrowserDelegate
        {
            height: 64
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            label1.text: model.name
            label2.text: model.description
            label3.text: model.version
            label4.text: Maui.Handy.formatSize(model.latest_bundle_size)
            imageSource: "image://thumbnailer/" + model.latest_bundle_path
            iconSizeHint: Maui.Style.iconSizes.large
            iconSource: "application-vnd.appimage"

            onClicked:
            {
                _appsListView.currentIndex = index;

                if(Maui.Handy.singleClick || Kirigami.Settings.hasTransientTouchInput)
                {
                    _appsList.launchApp(_appsModel.mappedToSource(index));
                }
            }

            onDoubleClicked:
            {
                _appsListView.currentIndex = index;

                if(!Maui.Handy.singleClick)
                {
                    _appsList.launchApp(_appsModel.mappedToSource(index));
                }
            }

            quickActions: [
                Action
                {
                    icon.name: "media-playback-start"
                    text: "Run"
                    onTriggered:
                    {
                        _appsListView.currentIndex = index;
                        _appsList.launchApp(_appsModel.mappedToSource(index));
                    }
                },
                Action
                {
                    icon.name: "download"
                    text: "Update"
                    enabled: model.updatable==="true"
                    onTriggered:
                    {
                        taskManagerCtx.doUpdate(model.url, model.name);
                    }
                },
                Action
                {
                    icon.name: "entry-delete"
                    text: "Remove"
                    onTriggered:
                    {
                        _appsListView.currentIndex = index;
                        appRemoveDialog.index = _appsModel.mappedToSource(index)
                        appRemoveDialog.open()
                    }
                }
            ]
        }
    }

    Connections
    {
        target: _appsList

        function onAppLaunchError(err) {
            console.log("App Launch Error", err);
            appLaunchErrorDialog.showDialog(_appsListView.model.get(_appsListView.currentIndex).path.split("/").pop(), err);
            _appsListView.currentIndex = -1;
        }

        function onAppLaunchSuccess() {
            _appsListView.currentIndex = -1;
        }

        function onAppDeleteSuccess() {
            appRemoveDialog.visible = false;
        }

        function onAppUpdateSuccess(msg) {
            console.log("AppImage updated successfully.");
            
            appUpdateDialog.showDialog(_appsListView.model.get(_appsListView.currentIndex).path.split("/").pop(), 
                msg);
        }

        function onAppUpdateError(err) {
            console.log("AppImage update error.");
            appUpdateDialog.showDialog(_appsListView.model.get(_appsListView.currentIndex).path.split("/").pop(),
                err);
        }
    }
}



