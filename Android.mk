ifneq ($(filter $(QCOM_NEW_MEDIA_PLATFORM), $(TARGET_BOARD_PLATFORM)),)
ifneq ($(filter 4.14, $(SOMC_KERNEL_VERSION)),)

QCOM_MEDIA_ROOT := $(call my-dir)

#Compile these for all targets under QCOM_BOARD_PLATFORMS list.
ifeq ($(call is-board-platform-in-list, $(QCOM_BOARD_PLATFORMS)),true)
include $(QCOM_MEDIA_ROOT)/libstagefrighthw/Android.mk
include $(QCOM_MEDIA_ROOT)/mm-core/Android.mk
endif

ifeq ($(call is-board-platform-in-list, $(MSM_VIDC_TARGET_LIST)),true)
include $(QCOM_MEDIA_ROOT)/libplatformconfig/Android.mk
include $(QCOM_MEDIA_ROOT)/mm-video-v4l2/Android.mk
include $(QCOM_MEDIA_ROOT)/libc2dcolorconvert/Android.mk
include $(QCOM_MEDIA_ROOT)/libarbitrarybytes/Android.mk
ifeq ($(ENABLE_HYP),true)
include $(QCOM_MEDIA_ROOT)/hypv-intercept/Android.mk
endif
endif
endif
endif