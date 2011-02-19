GNUSTEP_MAKEFILES=/usr/share/GNUstep/Makefiles/
include $(GNUSTEP_MAKEFILES)/common.make




SUBPROJECT_NAME = Support
Support_HEADER_FILES = CCFileUtils.h  CGPointExtension.h  TGAlib.h  ZipUtils.h CCProfiling.h\
 TransformUtils.h EAGLView.h uthash.h  ccArray.h OpenGL_Internal.h
Support_HEADER_FILES_INSTALL_DIR = CoCoStep/Support
Support_OBJC_FILES += CCFileUtils.m  CGPointExtension.m  TGAlib.m  ZipUtils.m GNUStep.m\
CCProfiling.m    TransformUtils.m EAGLView.m 


Support_OBJC_PRECOMPILED_HEADERS =  ../CocosStepPrefix.h
Support_OBJCFLAGS  += -include ../CocosStepPrefix.h -Winvalid-pch

Support_INCLUDE_DIRS = -I ../UIKit

Support_C_FILES = base64.c glu.c


Support_CPPFLAGS = -I ../ 

include $(GNUSTEP_MAKEFILES)/subproject.make





