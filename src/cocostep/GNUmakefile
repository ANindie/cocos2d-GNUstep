GNUSTEP_MAKEFILES=/usr/share/GNUstep/Makefiles/
shared=yes
include $(GNUSTEP_MAKEFILES)/common.make





include Cocos2dFiles.make
LIBRARY_NAME = libCoCoStep

libCoCoStep_OBJC_PRECOMPILED_HEADERS =  CocosStepPrefix.h
libCoCoStep_OBJCFLAGS  += -include CocosStepPrefix.h -Winvalid-pch


libCoCoStep_HEADER_FILES = $(COCOS2D_HEADERFILES)
libCoCoStep_HEADER_FILES_INSTALL_DIR = CoCoStep
libCoCoStep_OBJC_FILES += $(COCOS2DFILES) 
libCoCoStep_SUBPROJECTS = Support UIKit




include $(GNUSTEP_MAKEFILES)/library.make




