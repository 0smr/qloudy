#include <QGuiApplication>
#include <QQmlApplicationEngine>
// #include "requesthandler.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setApplicationName("Qloudy");
    app.setApplicationDisplayName("Qloudy");
    app.setOrganizationDomain("https://smr76.github.io");
    app.setOrganizationName("smr");

    qmlRegisterSingletonType(QUrl("qrc:/Qloudy.qml"), "Qloudy", 0, 1, "Qloudy");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
