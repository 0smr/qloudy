#pragma once

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtCore>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

#include <QDir>

namespace qloudy::network::weather {
class requestHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool processing READ processing NOTIFY processingChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged RESET resetStatus)
    QML_NAMED_ELEMENT(RequestHandler)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum Status {
        Error = -1, None, Pending, Processing, Completed,
    };
    Q_ENUM(Status)

    explicit requestHandler(QObject *parent = nullptr)
        : QObject{parent}, mProcessing(false), mStatus(Status::None) {
//        mNetworkManager.setAutoDeleteReplies(true);
    }

    Q_INVOKABLE bool getRequest(QUrl url) {
//        if(mReply->isRunning()) return false;

        QNetworkRequest req(url);
        mBuffer.clear();

        setStatus(Status::None);
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        req.setTransferTimeout(5000); // 5 second

        mReply = mNetworkManager.get(req);
        setStatus(Status::Pending);

        QObject::connect(mReply, &QNetworkReply::readyRead, this, &requestHandler::onReadyRead);
        QObject::connect(mReply, &QNetworkReply::finished, this, &requestHandler::onFinished);
        QObject::connect(mReply, &QNetworkReply::errorOccurred, this, &requestHandler::onErrorOccurred);

        return true;
    }

    bool processing() const { return mProcessing; }
    void setProcessing(bool processing) {
        if (mProcessing == processing) return;
        mProcessing = processing;
        emit processingChanged();
    }

    const Status& status() const { return mStatus; }
    void setStatus(const Status& newStatus) {
        if(mStatus == newStatus) return;
        mStatus = newStatus;
        emit statusChanged();
        setProcessing(newStatus == Pending ||
                      newStatus == Processing);
    }

public slots:
    void onReadyRead() {
        mBuffer.append(mReply->readAll());
        setStatus(Status::Processing);
    }

    void onFinished() {
        mBuffer.append(mReply->readAll());
        setStatus(Status::Completed);
        emit finished(mBuffer);
    }

    void onErrorOccurred(QNetworkReply::NetworkError error) {
        setStatus(Status::Error);
        emit errorOccurred(QString("Network Error (Code: %1)").arg(error));
    }

    void abort() {
        mReply->abort();
        emit aborted();
        setStatus(Status::None);
    }

    void resetStatus() {
        setStatus(Status::None);
    }

signals:
    void processingChanged();
    void statusChanged();

    void errorOccurred(QString errorMessage);
    void finished(QByteArray response);
    void aborted();

private:
    QNetworkAccessManager mNetworkManager;
    QNetworkReply *mReply;
    QByteArray mBuffer;

    bool mProcessing;
    Status mStatus;
};

static void registerRequestHandlerType() {
//    qmlRegisterType<requestHandler>("qloudy.network.weather", 0, 1, "RequestHandler");
}
Q_COREAPP_STARTUP_FUNCTION(registerRequestHandlerType)
}

