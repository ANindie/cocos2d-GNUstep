GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles/


include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = CCNodeTest
VERSION = 0.0.1
APP_NAME = CCNodeTest


COCOSTEPDIR = ../../cocostep/
COCOSTEPRESOURCEDIR = ../../Resources
COCOSTEp_IMAGE_RESOURCEDIR = $(COCOSTEPRESOURCEDIR)/Images/

CCNodeTest_APPLICATION_ICON = Icon.png
CCNodeTest_OBJC_FILES = CCNodeTest.m
CCNodeTest_INCLUDE_DIRS= -I . -I $(COCOSTEPDIR)

CCNodeTest_TOOL_LIBS += -lCoCoStep 
CCNodeTest_LIB_DIRS =  -L $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR) 
CCNodeTest_LD_LIBRARY_PATH = $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR)

CCNodeTest_TOOL_LIBS += -lGL -lGLU -lm

CCNodeTest_OBJCFLAGS = -Wno-unknown-pragmas




CCNodeTest_RESOURCE_FILES =  $(COCOSTEPRESOURCEDIR)/Icon.png \
$(COCOSTEPRESOURCEDIR)/Fonts/fps_images.png\
$(COCOSTEPRESOURCEDIR)/Fonts/arial16.png\
$(COCOSTEPRESOURCEDIR)/Fonts/arial16.fnt\
$(COCOSTEp_IMAGE_RESOURCEDIR)/b1.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/r1.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/f1.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/b2.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/r2.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/f2.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/grossinis_sister1.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/grossinis_sister2.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/background3.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/btn-play-normal.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/btn-play-selected.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/grossini.png\
$(COCOSTEp_IMAGE_RESOURCEDIR)/fire.png
				


-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$(CCNodeTest_LD_LIBRARY_PATH) && openapp ./$(APP_NAME).app

-include GNUmakefile.postamble
