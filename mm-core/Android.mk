ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

OMXCORE_CFLAGS := -g -O3 -DVERBOSE
OMXCORE_CFLAGS += -O0 -fno-inline -fno-short-enums
OMXCORE_CFLAGS += -D_ANDROID_
OMXCORE_CFLAGS += -U_ENABLE_QC_MSG_LOG_

#===============================================================================
#             Figure out the targets
#===============================================================================

ifeq ($(filter $(TARGET_BOARD_PLATFORM), sm8150),$(TARGET_BOARD_PLATFORM))
OMXCORE_CFLAGS += -D_NILE_
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), $(MSMSTEPPE)),$(TARGET_BOARD_PLATFORM))
OMXCORE_CFLAGS += -D_STEPPE_
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), $(TRINKET)),$(TARGET_BOARD_PLATFORM))
OMXCORE_CFLAGS += -D_TRINKET_
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), atoll),$(TARGET_BOARD_PLATFORM))
OMXCORE_CFLAGS += -D_ATOLL_
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), sdm845 msmskunk),$(TARGET_BOARD_PLATFORM))
MM_CORE_TARGET = sdm845
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), sdm660),$(TARGET_BOARD_PLATFORM))
MM_CORE_TARGET = sdm660
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), msm8998),$(TARGET_BOARD_PLATFORM))
MM_CORE_TARGET = msm8998
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), msm8996),$(TARGET_BOARD_PLATFORM))
MM_CORE_TARGET = msm8996
else ifeq ($(filter $(TARGET_BOARD_PLATFORM), msm8952),$(TARGET_BOARD_PLATFORM))
MM_CORE_TARGET = msm8952
else
OMXCORE_CFLAGS += -D_DEFAULT_
endif

ifeq ($(call is-platform-sdk-version-at-least,27),true) # O-MR1
OMXCORE_CFLAGS += -D_ANDROID_O_MR1_DIVX_CHANGES
endif

#===============================================================================
#             LIBRARY for Android apps
#===============================================================================

LOCAL_C_INCLUDES        := $(LOCAL_PATH)/src/common
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/inc

LOCAL_HEADER_LIBRARIES := \
        libutils_headers

LOCAL_PRELINK_MODULE    := false
LOCAL_MODULE            := libOmxCore
LOCAL_MODULE_TAGS       := optional
LOCAL_VENDOR_MODULE     := true
LOCAL_SHARED_LIBRARIES  := liblog libdl libcutils
ifeq ($(call is-board-platform-in-list, $(MSM_VIDC_TARGET_LIST)),true)
LOCAL_SHARED_LIBRARIES  += libplatformconfig
endif
LOCAL_CFLAGS            := $(OMXCORE_CFLAGS)

LOCAL_SRC_FILES         := src/common/omx_core_cmp.cpp
LOCAL_SRC_FILES         += src/common/qc_omx_core.c
ifneq (,$(filter msm8952 msm8996 msm8998 sdm660 sdm845,$(TARGET_BOARD_PLATFORM)))
LOCAL_SRC_FILES         += src/$(MM_CORE_TARGET)/registry_table_android.c
else ifneq (,$(filter sm8150 sdmshrike $(MSMSTEPPE) $(TRINKET) atoll,$(TARGET_BOARD_PLATFORM)))
LOCAL_SRC_FILES         += src/registry_table_android.c
else
$(error "sm8150 media HAL: Refusing to include example file qc_registry_table.c, check if TARGET_BOARD_PLATFORM is correct and in the filter above")
LOCAL_SRC_FILES         += src/qc_registry_table_android.c
endif

include $(BUILD_SHARED_LIBRARY)

#===============================================================================
#             LIBRARY for command line test apps
#===============================================================================

include $(CLEAR_VARS)

LOCAL_C_INCLUDES        := $(LOCAL_PATH)/src/common
LOCAL_C_INCLUDES        += $(LOCAL_PATH)/inc

LOCAL_HEADER_LIBRARIES := \
        libutils_headers

LOCAL_PRELINK_MODULE    := false
LOCAL_MODULE            := libmm-omxcore
LOCAL_MODULE_TAGS       := optional
LOCAL_VENDOR_MODULE     := true
LOCAL_SHARED_LIBRARIES  := liblog libdl libcutils
ifeq ($(call is-board-platform-in-list, $(MSM_VIDC_TARGET_LIST)),true)
LOCAL_SHARED_LIBRARIES  += libplatformconfig
endif
LOCAL_CFLAGS            := $(OMXCORE_CFLAGS)

LOCAL_SRC_FILES         := src/common/omx_core_cmp.cpp
LOCAL_SRC_FILES         += src/common/qc_omx_core.c
ifneq (,$(filter msm8952 msm8996 msm8998 sdm660 sdm845,$(TARGET_BOARD_PLATFORM)))
LOCAL_SRC_FILES         += src/$(MM_CORE_TARGET)/registry_table.c
else ifneq (,$(filter sm8150 sdmshrike $(MSMSTEPPE) $(TRINKET) atoll,$(TARGET_BOARD_PLATFORM)))
LOCAL_SRC_FILES         += src/registry_table.c
else
LOCAL_SRC_FILES         += src/qc_registry_table.c
endif

include $(BUILD_SHARED_LIBRARY)

endif #BUILD_TINY_ANDROID
