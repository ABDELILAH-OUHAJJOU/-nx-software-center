#ifndef SNAPDCLIENTKAUTHWRAPPER_H
#define SNAPDCLIENTKAUTHWRAPPER_H

#include <QObject>
#include <KAuth/KAuthExecuteJob>

class SnapdClientKAuthWrapper : public QObject
{
    Q_OBJECT
public:
    SnapdClientKAuthWrapper(QObject *parent = 0);

    Q_INVOKABLE KAuth::ExecuteJob *disable(const QString &snap);
    Q_INVOKABLE KAuth::ExecuteJob *enable(const QString &snap);

};

#endif // SNAPDCLIENTKAUTHWRAPPER_H