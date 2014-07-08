ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = CopyNote
CopyNote_FILES = Tweak.xm
CopyNote_FRAMEWORKS = UIKit
CopyNote_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk


