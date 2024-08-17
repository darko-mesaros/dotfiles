#!/bin/bash

usage() {
  echo "Usage $0 [-o outfile] [-d outdir] [-f fps] [-a {alse|pulse|pipwire}]"
  echo "  -o: Specify the output file (default: screen_rec_<current_date_and_time>.mp4)"
  echo "  -d: Specify the output directory (default: ./)"
  echo "  -f: Specify the frame rate (default: 30)"
  echo "  -a: Enable audio recording (alsa, pulse or pipewire)"
  exit 1
}

# Defaults
output_dir="./"
output_file="screen_rec_$(date "+%Y-%m-%d-%H-%M-%S").mp4"
fps=30
timer=5

#command line parsing 
while getopts "o:d:f:a:h" opt; do
  case $opt in
    o) output_file="$OPTARG";;
    d) output_dir="$OPTARG";;
    f) fps="$OPTARG";;
    a)
      case "$OPTARG" in
        alsa) audio_flag="-f alsa -i default" ;;
        pulse) audio_flag="-f pulse -i default" ;;
        pipewire) audio_flag="-f pipewire -i default" ;;
        *) echo "Invalid audio option. Use alse, pulse or pipewire,"; exit 1;;
      esac
      ;;
    h) usage ;;
    \?) usage ;;
  esac
done

# Generate output path
# check if there is a trailing / at the end of the directory path
if [[ $output_dir != */ ]]
then
  output_dir=${output_dir}"/"
fi

output_path="${output_dir}${output_file}"
echo "Will record to: $output_path"

# check for required packages
command -v ffmpeg > /dev/null 2>&1 || { echo "Error: ffmpeg is not installed."; exit 1;}
command -v xdpyinfo > /dev/null 2>&1 || { echo "Error: xdpyinfo is not installed."; exit 1;}
command -v slop > /dev/null 2>&1 || { echo "Error: slop is not installed."; exit 1;}

# get screen resolution
resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')

# use slop to select area
selected_area=$(slop --color=0.3,0.4,0.6,0.4 -b 10 -f "%x %y %w %h")

# extract coordinates and dimensions from the selected area
read -r x y w h <<< "$selected_area"

# set a 5 second timer
echo "Recording will start in: "
for ((i=$timer; i>0; i--))
do
  echo "$i..."
  sleep 1
done


# start recording
echo "Recording started. Press q to stop."
ffmpeg -f x11grab -framerate "$fps" -video_size "${w}x${h}" -i :0.0+"$x","$y" $audio_flag -c:v libx264 -preset ultrafast -crf 0 "$output_path"

echo "Recording saved as $output_path"
