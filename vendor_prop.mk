# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio.deep_buffer.media=true \
    audio.dolby.ds2.enabled=true \
    audio.dolby.ds2.hardbypass=true \
    audio_hal.period_size=192 \
    audio.heap.size.multiplier=7 \
    audio.parser.ip.buffer.size=262144 \
    audio.playback.mch.downsample=true \
    audio.pp.asphere.enabled=false \
    audio.safx.pbe.enabled=true \
    flac.sw.decoder.24bit.support=true \
    persist.audio.fluence.speaker=false \
    persist.audio.fluence.voicecall=false \
    persist.audio.fluence.voicerec=false \
    persist.speaker.prot.enable=false \
    qcom.hw.aac.encoder=true \
    ro.qc.sdk.audio.fluencetype=fluence \
    ro.qc.sdk.audio.ssr=false \
    tunnel.audio.encode=false \
    use.qti.sw.alac.decoder=true \
    use.qti.sw.ape.decoder=true \
    use.voice.path.for.pcm.voip=true \
    voice.conc.fallbackpath=deep-buffer \
    voice.playback.conc.disabled=true \
    voice.record.conc.disabled=false \
    voice.voip.conc.disabled=true

# Audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.min.duration.secs=30 \
    audio.offload.pcm.16bit.enable=true \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.video=true
    audio.offload.buffer.size.kb=64 \
    audio.offload.gapless.enabled=true \
    audio.offload.multiaac.enable=true \
    audio.offload.multiple.enabled=false \
    audio.offload.passthrough=false \
    audio.offload.track.enable=true \

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=smd \
    ro.bluetooth.dun=true \
    ro.bluetooth.hfp.ver=1.7 \
    ro.bluetooth.sap=true \
    ro.qualcomm.bt.hci_transport=smd

# DPM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.dpm.feature=7 \
    persist.sys.dpmd.nsrm=3

# Factory Reset Protection
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/config

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=1 \
    persist.loc.nlp_name=com.qualcomm.location \
    ro.gps.agps_provider=1

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    vidc.debug.perf.mode=2 \
    vidc.enc.dcvs.extra-buff-count=2 \
    vidc.enc.disable.pq=true

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    persist.radio.proc_nw_scan=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.custom_ecc=1 \
    persist.radio.sib16_support=1 \
    persist.radio.rat_on=disable

# Telephony
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.call_ring.multiple=false
