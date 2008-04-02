TEMPLATE = app

include(../buildconf.pri)

RESOURCES   *= ../../i18n/i18n.qrc
TRANSLATIONS = quassel_da.ts \
               quassel_de.ts

SRCPATH = ../../src
OBJECTS_DIR = .$$TARGET
RCC_DIR     = .$$TARGET

linux-g++:static {
  # We put libs in contrib/libs that should be linked statically, especially libstdc++.a
  LIBS *= -L../contrib/libs
  QMAKE_LFLAGS *= -static-libgcc
}

for(mod, MODULES) {
  INCLUDEPATH *= $$SRCPATH/$$mod
  LIBS *= -L../modules/$$dirname(mod) -l$$basename(mod)
  #PRE_TARGETDEPS *= ../modules/$$mod
}
PRE_TARGETDEPS *= ../../version.inc

#CONTRIB += libqxt  # not needed
#include(../contrib/contrib.pri)

SOURCES = $$SRCPATH/common/main.cpp

# This is really annoying, but for some reason win32 libs are not included by default.
# Ugly workaround following...

win32:static {
  RC_FILE = win32.rc
  CONFIG += embed_manifest_exe
  LIBS *= -luser32 -lgdi32 -lkernel32 -lshell32 -lwsock32 -lwinspool -lcomdlg32 -lole32
  LIBS *= -ladvapi32 -limm32 -luuid -lwinmm -ldelayimp -lopengl32 -lglu32 -loleaut32 -lws2_32
  LIBS *= -llibeay32MD -lssleay32MD
  QMAKE_LFLAGS_WINDOWS += /nodefaultlib:"libcmt.lib"

}

macx {
  ICON = ../../src/icons/quassel.icns
}
