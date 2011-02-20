GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles/


include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = Box2D
VERSION = 0.0.1
APP_NAME = Box2D

COCOSTEPDIR = ../../cocostep/
COCOSTEPRESOURCEDIR = ../../Resources/
BOX2DINCULDES = -I Box2D -I Box2DTestBed


Box2D_APPLICATION_ICON = Icon.png
Box2D_OBJC_FILES =  main.m
Box2D_OBJCC_FILES = Box2DAppDelegate.mm  GLES-Render.mm        iPhoneTest.mm Box2DView.mm         iPhoneTestEntries.mm
Box2D_SUBPROJECTS = Box2D

Box2D_INCLUDE_DIRS= -I . -I $(COCOSTEPDIR)  $(BOX2DINCULDES)

Box2D_TOOL_LIBS += -lCoCoStep 
Box2D_LIB_DIRS =  -L $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR) 
Box2D_LD_LIBRARY_PATH = $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR)

Box2D_TOOL_LIBS += -lGL -lGLU -lm

Box2D_OBJCFLAGS = -Wno-unknown-pragmas




Box2D_RESOURCE_FILES =  Icon.png  $(COCOSTEPRESOURCEDIR)/Fonts/fps_images.png\
		 $(COCOSTEPRESOURCEDIR)/Fonts/arial16.fnt\
		 $(COCOSTEPRESOURCEDIR)/Fonts/arial16.png \
		$(COCOSTEPRESOURCEDIR)/Images/*
				


-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$(Box2D_LD_LIBRARY_PATH) && openapp ./$(APP_NAME).app

-include GNUmakefile.postamble
