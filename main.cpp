#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDateTime>
#include <QDebug>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    qDebug() << QDateTime::currentDateTimeUtc().toSecsSinceEpoch()<<"\n" << QDateTime::currentDateTimeUtc().toMSecsSinceEpoch();
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
