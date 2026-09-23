#!/bin/sh
# Read only supplied synthetic fixture files; decode bounded frames to null.
# Run as the actual Jellyfin service user. No library media, package or config writes.
set -eu
[ "$#" -eq 1 ] || { echo 'usage: jellyfin-nvdec-readonly.sh FIXTURE_DIR' >&2; exit 2; }
fixture_dir=$1
ffmpeg=/usr/lib/jellyfin-ffmpeg/ffmpeg
"$ffmpeg" -nostdin -hide_banner -loglevel verbose -hwaccel cuda -hwaccel_output_format cuda -c:v h264_cuvid -i "$fixture_dir/h264.mkv" -frames:v 60 -an -vf hwdownload,format=nv12 -f null -
"$ffmpeg" -nostdin -hide_banner -loglevel verbose -hwaccel cuda -hwaccel_output_format cuda -c:v hevc_cuvid -i "$fixture_dir/hevc10.mkv" -frames:v 30 -an -vf hwdownload,format=p010le -f null -
# Jellyfin's enabled enhanced NVDEC path uses native decoder + CUDA hwaccel.
"$ffmpeg" -nostdin -hide_banner -loglevel verbose -hwaccel cuda -hwaccel_output_format cuda -i "$fixture_dir/h264.mkv" -frames:v 60 -an -vf hwdownload,format=nv12 -f null -
