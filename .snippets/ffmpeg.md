## FFMPEG

# Used to compress audiobooks with static images, took a 2.9GB video down to 300+MB
$ ffmpeg -i reaper1-20000-215457.mp4 -crf 23 -preset slow -b:a 96k out.mp4   

# used to concat wav files with numbers in title, in order
$ ffmpeg -f concat -safe 0 -i <( for f in $(\ls -1v *.wav); do echo "file $(pwd)/$f"; done ) output.wav

# or (file must start with 'file filename.wav' for ffmpeg)
$ for f in $(\ls -1v *.wav); do echo "file $(pwd)/$f"; done > ffmpeg.txt

$ ffmpeg -f concat -safe 0 -i ffmpeg.txt

# another test ffmpeg command for audiobook encoding
$ ffmpeg  -loop 1 -r 2 -i <image.png> -i <audio.mp3> -c:v libx264 -tune stillimage -preset ultrafast -crf 20  -c:a copy -shortest -pix_fmt yuv420p output.mkv

# encode audio wav and static image
$ ffmpeg -loop 1 -i infmage6-10.jpg -i in.wav -c:v libx264 \ 
  -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest out.mp4

# optimized version (causes some minor issues like having 1 minute of silence at the end of the file)
# for faster encoding change -b:a from 192k to around 80k (also potentially change preset to fast or ultrafast)
ffmpeg -loop 1 -i /home/sweet/Downloads/infmage6-10.jpg -i 11-15.wav \
-c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p \
-shortest -preset veryslow -crf 12 -r 1 11-15.mp4