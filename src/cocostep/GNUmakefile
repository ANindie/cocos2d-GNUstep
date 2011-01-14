GNUSTEP_MAKEFILES=/usr/share/GNUstep/Makefiles/

include $(GNUSTEP_MAKEFILES)/common.make

SUBPROJECTS = Support


include Cocos2dFiles.make
LIBRARY_NAME = libCoCoStep
libCoCoStep_HEADER_FILES = 
libCoCoStep_HEADER_FILES_INSTALL_DIR = CoCoStep
libCoCoStep_OBJC_FILES += $(COCOS2DFILES)
libCoCoStep_OBJC_FILES += UIApplication.m

include $(GNUSTEP_MAKEFILES)/library.make

include $(GNUSTEP_MAKEFILES)/aggregate.make
