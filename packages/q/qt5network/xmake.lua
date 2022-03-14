package("qt5network")
    set_base("qt5lib")
    set_kind("library")

    on_load(function (package)
        package:add("deps", "qt5core", {debug = package:is_debug(), version = package:version_str()})
        package:data_set("libname", "Network")

        if package:is_plat("linux") then
            package:add("deps", "openssl 1.1.1b")
        elseif package:is_plat("iphoneos") then
            package:data_set("frameworks", {"GSS", "IOKit", "Security", "SystemConfiguration"})
        end

        package:base():script("load")(package)
        package:set("kind", "library")
    end)

    on_test(function (package)
        local cxflags
        if not package:is_plat("windows") then
            cxflags = "-fPIC"
        end
        assert(package:check_cxxsnippets({test = [[
            int test(int argc, char** argv) {
                QCoreApplication app(argc, argv);

                QByteArray datagram = "Hello from xmake!";
                QUdpSocket udpSocket;
                udpSocket.writeDatagram(datagram, QHostAddress::Broadcast, 45454);

                return app.exec();
            }
        ]]}, {configs = {languages = "c++14", cxflags = cxflags}, includes = {"QCoreApplication", "QByteArray", "QUdpSocket"}}))
    end)
