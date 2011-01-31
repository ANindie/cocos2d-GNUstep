GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles/


include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = HelloWorld
VERSION = 0.0.1
APP_NAME = HelloWorld




COCOSTEPDIR = /usr/local/lib/Cocostep
COCOSTEPRESOURCEDIR = ../../Resources/
COCOSTEPINCLUDEDIR=/usr/local/include/GNUstep/CoCoStep/

HelloWorld_APPLICATION_ICON = Icon.png
HelloWorld_OBJC_FILES = HelloWorld.m
HelloWorld_INCLUDE_DIRS= -I . -I $(COCOSTEPINCLUDEDIR)

HelloWorld_TOOL_LIBS += -lCoCoStep 
HelloWorld_LIB_DIRS =  -L $(COCOSTEPDIR) 
HelloWorld_LD_LIBRARY_PATH = $(COCOSTEPDIR)

HelloWorld_TOOL_LIBS += -lGL  -lm

HelloWorld_OBJCFLAGS = -Wno-unknown-pragmas


HelloWorld_OBJC_PRECOMPILED_HEADERS = HelloWorld_Prefix.h
HelloWorld_OBJCFLAGS  += -include HelloWorld_Prefix.h -Winvalid-pch


HelloWorld_RESOURCE_FILES =  $(COCOSTEPRESOURCEDIR)/Icon.png \
				 $(COCOSTEPRESOURCEDIR)/Fonts/fps_images.png\
				 $(COCOSTEPRESOURCEDIR)/Fonts/arial16.fnt\
				 $(COCOSTEPRESOURCEDIR)/Fonts/arial16.png


-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$(HelloWorld_LD_LIBRARY_PATH) && openapp ./$(APP_NAME).app

-include GNUmakefile.postamble
