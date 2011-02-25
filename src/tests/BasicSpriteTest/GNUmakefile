GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles/


include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = BasicSprite
VERSION = 0.0.1
APP_NAME = BasicSprite

COCOSTEPDIR = ../../cocostep/
COCOSTEPRESOURCEDIR = ../../Resources/


BasicSprite_APPLICATION_ICON = Icon.png
BasicSprite_OBJC_FILES = BasicSprite.m
BasicSprite_INCLUDE_DIRS= -I . -I $(COCOSTEPDIR)

BasicSprite_TOOL_LIBS += -lCoCoStep 
BasicSprite_LIB_DIRS =  -L $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR) 
BasicSprite_LD_LIBRARY_PATH = $(COCOSTEPDIR)/$(GNUSTEP_OBJ_DIR)

BasicSprite_TOOL_LIBS += -lGL -lGLU -lm

BasicSprite_OBJCFLAGS = -Wno-unknown-pragmas




BasicSprite_RESOURCE_FILES =  $(COCOSTEPRESOURCEDIR)/Icon.png \
				 $(COCOSTEPRESOURCEDIR)/Fonts/fps_images.png\
				 $(COCOSTEPRESOURCEDIR)/Images/grossini_dance_atlas.png\
				 $(COCOSTEPRESOURCEDIR)/Images/*



-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/application.make
run: 
	export LD_LIBRARY_PATH=$(BasicSprite_LD_LIBRARY_PATH) && openapp ./$(APP_NAME).app

-include GNUmakefile.postamble
