#include "TaskManager.h"
#include "CheckUpdateBulkTask.h"
#include "CheckUpdateTask.h"
#include "DownloadTask.h"
#include "UpdateTask.h"
#include "UpdateAllTask.h"

#include <QRandomGenerator>
#include <QUuid>
#include <utility>
#include <zconf.h>

QVariant TaskManager::getTasks() const
{
    return QVariant::fromValue(_tasks);
}
TaskManager::TaskManager(QObject *parent)
    : QObject(parent)
{
}

QString TaskManager::createTaskId() const
{
    QString id = QUuid::createUuid().toString();
    return id;
}

Task *TaskManager::doUpdate(QString appImagePath, const QString &appName)
{
    // remove url prefix
    if (appImagePath.startsWith("file://"))
        appImagePath = appImagePath.right(appImagePath.length() - 7);

    QString id = createTaskId();
    auto task = new UpdateTask(id, appImagePath, appName, this);
    _tasks.push_front(task);

    emit tasksChanged(getTasks());

    task->start();
    return task;
}

Task *TaskManager::doDownload(QUrl appDownloadUrl, QString appName)
{
    QString id = createTaskId();
    auto task = new DownloadTask(id, appName, appDownloadUrl, this);
    _tasks.push_front(task);

    emit tasksChanged(getTasks());

    task->start();
    return task;
}

Task *TaskManager::doCheckUpdate(AppsModel *appsModel)
{
    QString id = createTaskId();
    auto task = new CheckUpdateBulkTask(id, appsModel, this);
    _tasks.push_front(task);

    emit tasksChanged(getTasks());

    task->start();
    return task;
}

Task *TaskManager::doUpdateAll(AppsModel *appsModel)
{
    QString id = createTaskId();
    auto task = new UpdateAllTask(id, appsModel, this);
    _tasks.push_front(task);

    emit tasksChanged(getTasks());

    task->start();
    return task;
}

void TaskManager::destroy(Task *task)
{
    auto idx = _tasks.indexOf(task);
    if (idx >= 0) {
        _tasks.removeAt(idx);
        // schedule task for destruction
        task->deleteLater();

        emit tasksChanged(getTasks());
    }
}