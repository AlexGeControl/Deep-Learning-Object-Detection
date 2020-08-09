#! /bin/bash

# use faster r-cnn
echo "[Object Detection on Batch Images]: Using Faster R-CNN..."
python /workspace/detectron2/demo/demo.py \
    --config-file /workspace/detectron2/configs/COCO-Detection/faster_rcnn_R_50_FPN_1x.yaml \
    --input /workspace/assignments/02-detectron2/data/*.jpg \
    --output /workspace/assignments/02-detectron2/output/assignment/01/faster_rcnn \
    --opts MODEL.WEIGHTS /workspace/models/pre-trained/COCO-Detection/faster_rcnn_R_50_FPN_1x/137257794/model_final_b275ba.pkl
echo "[Object Detection on Batch Images]: Faster R-CNN DONE."

# use retinanet
echo "[Object Detection on Batch Images]: Using RetinaNet..."
python /workspace/detectron2/demo/demo.py \
    --config-file /workspace/detectron2/configs/COCO-Detection/retinanet_R_50_FPN_1x.yaml \
    --input /workspace/assignments/02-detectron2/data/*.jpg \
    --output /workspace/assignments/02-detectron2/output/assignment/01/retinanet \
    --opts MODEL.WEIGHTS /workspace/models/pre-trained/COCO-Detection/retinanet_R_50_FPN_1x/190397773/model_final_bfca0b.pkl
echo "[Object Detection on Batch Images]: RetinaNet DONE."