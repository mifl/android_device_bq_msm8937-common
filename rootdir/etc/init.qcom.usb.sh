#!/vendor/bin/sh
# Copyright (c) 2012-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

# Set platform variables
if [ -f /sys/devices/soc0/hw_platform ]; then
    soc_hwplatform=`cat /sys/devices/soc0/hw_platform` 2> /dev/null
else
    soc_hwplatform=`cat /sys/devices/system/soc/soc0/hw_platform` 2> /dev/null
fi

if [ -f /sys/devices/soc0/machine ]; then
    soc_machine=`cat /sys/devices/soc0/machine` 2> /dev/null
else
    soc_machine=`cat /sys/devices/system/soc/soc0/machine` 2> /dev/null
fi

#
# Check ESOC for external MDM
#
# Note: currently only a single MDM is supported
#
if [ -d /sys/bus/esoc/devices ]; then
for f in /sys/bus/esoc/devices/*; do
    if [ -d $f ]; then
        if [ `grep "^MDM" $f/esoc_name` ]; then
            esoc_link=`cat $f/esoc_link`
            break
        fi
    fi
done
fi

target=`getprop ro.board.platform`

# soc_ids for 8937
if [ -f /sys/devices/soc0/soc_id ]; then
	soc_id=`cat /sys/devices/soc0/soc_id`
else
	soc_id=`cat /sys/devices/system/soc/soc0/id`
fi

#
# Allow USB enumeration with default PID/VID
#
baseband=`getprop ro.baseband`

echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
case "$usb_config" in
    "" | "adb") #USB persist config not set, select default configuration
      case "$esoc_link" in
          "PCIe")
              setprop persist.sys.usb.config diag,diag_mdm,serial_cdev,rmnet_qti_ether,mass_storage,adb
          ;;
          *)
	  case "$baseband" in
	      "apq")
	          setprop persist.sys.usb.config diag,adb
	      ;;
	      *)
	      case "$soc_hwplatform" in
	          "Dragon" | "SBC")
	              setprop persist.sys.usb.config diag,adb
	          ;;
                  *)
		  soc_machine=${soc_machine:0:3}
		  case "$soc_machine" in
		    "SDA")
	              setprop persist.sys.usb.config diag,adb
		    ;;
		    *)
	            case "$target" in
	              "msm8996")
	                  setprop persist.sys.usb.config diag,serial_cdev,serial_tty,rmnet_ipa,mass_storage,adb
		      ;;
	              "msm8909")
		          setprop persist.sys.usb.config diag,serial_smd,rmnet_qti_bam,adb
		      ;;
	              "msm8937")
			      if [ -d /config/usb_gadget ]; then
				      setprop persist.sys.usb.config diag,serial_cdev,rmnet,dpl,adb
			      else
				      case "$soc_id" in
					"313" | "320")
				            setprop persist.sys.usb.config diag,serial_smd,rmnet_ipa,adb
				        ;;
				        *)
				            setprop persist.sys.usb.config diag,serial_smd,rmnet_qti_bam,adb
				        ;;
				      esac
			      fi
		      ;;
	              "msm8952")
		          setprop persist.sys.usb.config diag,serial_smd,rmnet_ipa,adb
		      ;;
	              "msm8953")
			      if [ -d /config/usb_gadget ]; then
				      setprop persist.sys.usb.config diag,serial_cdev,rmnet,dpl,adb
			      else
				      setprop persist.sys.usb.config diag,serial_smd,rmnet_ipa,adb
			      fi
		      ;;
	              "msm8998" | "sdm660" | "apq8098_latv")
		          setprop persist.sys.usb.config diag,serial_cdev,rmnet,adb
		      ;;
	              "sdm845")
		          setprop persist.sys.usb.config diag,serial_cdev,rmnet,dpl,adb
		      ;;
	              *)
		          setprop persist.sys.usb.config diag,adb
		      ;;
                    esac
		    ;;
		  esac
	          ;;
	      esac
	      ;;
	  esac
	  ;;
      esac
      ;;
  * ) ;; #USB persist config exists, do nothing
esac

# check configfs is mounted or not
if [ -d /config/usb_gadget ]; then
	# set USB controller's device node
	setprop sys.usb.rndis.func.name "rndis_bam"
	setprop sys.usb.rmnet.func.name "rmnet_bam"
	setprop sys.usb.rmnet.inst.name "rmnet"
	setprop sys.usb.dpl.inst.name "dpl"
	case "$target" in
	"msm8937")
		setprop sys.usb.controller "msm_hsusb"
		setprop sys.usb.rndis.func.name "rndis"
		setprop sys.usb.rmnet.inst.name "rmnet_bam_dmux"
		setprop sys.usb.dpl.inst.name "dpl_bam_dmux"
		;;
	"msm8953")
		setprop sys.usb.controller "7000000.dwc3"
		echo 131072 > /sys/module/usb_f_mtp/parameters/mtp_tx_req_len
		echo 131072 > /sys/module/usb_f_mtp/parameters/mtp_rx_req_len
		;;
	"msm8996")
		setprop sys.usb.controller "6a00000.dwc3"
		echo 131072 > /sys/module/usb_f_mtp/parameters/mtp_tx_req_len
		echo 131072 > /sys/module/usb_f_mtp/parameters/mtp_rx_req_len
		;;
	"msm8998" | "apq8098_latv")
		setprop sys.usb.controller "a800000.dwc3"
		setprop sys.usb.rndis.func.name "gsi"
		setprop sys.usb.rmnet.func.name "gsi"
		;;
	"sdm660")
		setprop sys.usb.controller "a800000.dwc3"
		echo 15916 > /sys/module/usb_f_qcrndis/parameters/rndis_dl_max_xfer_size
		;;
	"sdm845")
		setprop sys.usb.controller "a600000.dwc3"
		setprop sys.usb.rndis.func.name "gsi"
		setprop sys.usb.rmnet.func.name "gsi"
		;;
	*)
		;;
	esac

	# Chip-serial is used for unique MSM identification in Product string
	msm_serial=`cat /sys/devices/soc0/serial_number`;
	msm_serial_hex=`printf %08X $msm_serial`
	machine_type=`cat /sys/devices/soc0/machine`
	product_string="$machine_type-$soc_hwplatform _SN:$msm_serial_hex"
	echo "$product_string" > /config/usb_gadget/g1/strings/0x409/product

	# ADB requires valid iSerialNumber; if ro.serialno is missing, use dummy
	serialnumber=`cat /config/usb_gadget/g1/strings/0x409/serialnumber` 2> /dev/null
	if [ "$serialnumber" == "" ]; then
		serialno=1234567
		echo $serialno > /config/usb_gadget/g1/strings/0x409/serialnumber
	fi

	persist_comp=`getprop persist.sys.usb.config`
	comp=`getprop sys.usb.config`
	echo $persist_comp
	echo $comp
	if [ "$comp" != "$persist_comp" ]; then
		echo "setting sys.usb.config"
		setprop sys.usb.config $persist_comp
	fi

	setprop sys.usb.configfs 1
else
        #
        # Do target specific things
        #
        case "$target" in
             "msm8996" | "msm8953")
                echo BAM2BAM_IPA > /sys/class/android_usb/android0/f_rndis_qc/rndis_transports
                echo 131072 > /sys/module/g_android/parameters/mtp_tx_req_len
                echo 131072 > /sys/module/g_android/parameters/mtp_rx_req_len
             ;;
             "msm8937")
                case "$soc_id" in
                      "313" | "320")
                         echo BAM2BAM_IPA > /sys/class/android_usb/android0/f_rndis_qc/rndis_transports
                      ;;
                esac
             ;;
        esac
	persist_comp=`getprop persist.sys.usb.config`
	comp=`getprop sys.usb.config`
	echo $persist_comp
	echo $comp
	if [ "$comp" != "$persist_comp" ]; then
		echo "setting sys.usb.config"
		setprop sys.usb.config $persist_comp
	fi
fi

#
# Initialize RNDIS Diag option. If unset, set it to 'none'.
#
diag_extra=`getprop persist.sys.usb.config.extra`
if [ "$diag_extra" == "" ]; then
	setprop persist.sys.usb.config.extra none
fi

# enable rps cpus on msm8937 target
setprop sys.usb.rps_mask 0
case "$soc_id" in
	"294" | "295" | "353" | "354")
		setprop sys.usb.rps_mask 40
	;;
esac
