import cv2
import os
  

cam = cv2.VideoCapture("mad.mkv")

nb_frame = cam.get(cv2.CAP_PROP_FRAME_COUNT)
start_cap = ((nb_frame / 30) * 0.30) * 1000
  
try:
    if not os.path.exists('data'):
        os.makedirs('data')
  
except OSError:
    print ('Error: Creating directory of data')

cam.set(cv2.CAP_PROP_POS_MSEC, start_cap)  
currentframe = start_cap
      
ret,frame = cam.read(currentframe)

if ret:

    name = './data/frame' + str(currentframe) + '.jpg'
    print ('Creating...' + name)

    cv2.imwrite(name, frame)

cam.release()
cv2.destroyAllWindows()

