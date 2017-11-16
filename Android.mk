LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := curlite

LOCAL_C_INCLUDES += $(LOCAL_PATH) \
	$(LOCAL_PATH)/../curl/ \
	$(LOCAL_PATH)/../curl/include

LOCAL_SRC_FILES := ./curlite.cpp

include $(BUILD_STATIC_LIBRARY)
