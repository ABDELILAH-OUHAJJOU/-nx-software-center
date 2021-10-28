#ifndef APPSMODEL_H
#define APPSMODEL_H

#include <QObject>

#include <MauiKit/Core/mauilist.h>

#include <QAppImageUpdate>

class QFileSystemWatcher;

class Store;
class Application;
class AppsModel : public MauiList
{
    Q_OBJECT

    // Q_PROPERTY(bool isUpdatable MEMBER m_isUpdatable NOTIFY isUpdatableChanged)

public:
    // bool m_isUpdatable = false;

    explicit AppsModel(QObject *parent = nullptr);

    // QQmlParserStatus interface
    void componentComplete() override final;

    const FMH::MODEL_LIST &items() const override final;

signals:
    void appLaunchSuccess();
    void appLaunchError(int err);
    void appDeleteSuccess();
    void appUpdateSuccess(int index, QString msg);
    void appUpdateError(int index, QString msg);

    // void isUpdatableChanged(bool isUpdatable);

public slots:
    void launchApp(const int &index);
    void updateApp(const int &index);
    void removeApp(const int &index);
    void resfresh();

private:
    FMH::MODEL_LIST m_list;
    QHash<QString, Application *> m_app;
    Store *m_store;
    QFileSystemWatcher * m_watcher;
    QAppImageUpdate *updater;

    void setList();

    void unintegrate(const QUrl &url);
    void clear();

    void handleError(short errorCode, short action, int index);
    void handleFinished(QJsonObject info, short action, int index);
};

#endif // APPSMODEL_H
