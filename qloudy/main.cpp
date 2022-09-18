#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QFile>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    app.setApplicationDisplayName("qloudy");
    app.setOrganizationDomain("https://smr76.github.io");
    app.setOrganizationName("smr");
    app.setApplicationName("qloudy");

    // Register qml files as singleton
    qmlRegisterSingletonType(QUrl("qrc:/globals/Fonts.qml"), "qloudy.globals", 0, 1, "Fonts");
    qmlRegisterSingletonType(QUrl("qrc:/globals/Theme.qml"), "qloudy.globals", 0, 1, "Theme");
    qmlRegisterSingletonType(QUrl("qrc:/globals/Weather.qml"), "qloudy.globals", 0, 1, "Weather");

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
