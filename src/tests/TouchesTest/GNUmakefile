GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles/


include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = TouchesTest
VERSION = 0.0.1
APP_NAME = TouchesTest

COCOSTEPDIR = ../../cocostep/
COCOSTEPRESOURCEDIR = ../../Resources/


TouchesTest_APPLICATION_ICON = Icon.png
TouchesTest_OBJC_FILES = Ball.m  Paddle.m  PongScene.m  TouchesDemoAppDelegate.m main.m
TouchesTest_INCLUDE_DIRS= -I . -I $(COCOSTEPDIR)

TouchesTest_TOOL_LIBS += -lCoCoStep 
TouchesTest_LIB_DIRS =  -L $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR) 
TouchesTest_LD_LIBRARY_PATH = $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR)

TouchesTest_TOOL_LIBS += -lGL -lGLU -lm

TouchesTest_OBJCFLAGS = -Wno-unknown-pragmas




TouchesTest_RESOURCE_FILES =  $(COCOSTEPRESOURCEDIR)/Icon.png \
				 $(COCOSTEPRESOURCEDIR)/Fonts/fps_images.png\
				ball.png  paddle.png	



-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$(TouchesTest_LD_LIBRARY_PATH) && openapp ./$(APP_NAME).app

-include GNUmakefile.postamble
