#!/bin/bash

INPUT="banner_orginal.mp4"
OUTPUT="banner.webp"
R=20

# Hard corners: pixel is transparent only if it's in a corner square AND outside the quarter circle
ffmpeg -y -i "$INPUT" \
  -vf "crop=1280:450:0:135,scale=830:-1:flags=lanczos,fps=24,format=rgba,geq=\
r='r(X,Y)':\
g='g(X,Y)':\
b='b(X,Y)':\
a='255-255*(\
(lt(X,$R)*lt(Y,$R)*gt(hypot($R-X,$R-Y),$R))+\
(gt(X,W-$R)*lt(Y,$R)*gt(hypot(X-W+$R,$R-Y),$R))+\
(lt(X,$R)*gt(Y,H-$R)*gt(hypot($R-X,Y-H+$R),$R))+\
(gt(X,W-$R)*gt(Y,H-$R)*gt(hypot(X-W+$R,Y-H+$R),$R))\
)'" \
  -c:v libwebp -quality 90 -loop 0 -an \
  "$OUTPUT"

echo "Generated $OUTPUT"
