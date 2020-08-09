#! /bin/bash

export DETECTRON2_DATASETS=/workspace/data

# use faster r-cnn
echo "[MS COCO 2017 Validation]: Using Faster R-CNN..."
python /workspace/detectron2/tools/train_net.py \
    --config-file /workspace/detectron2/configs/COCO-Detection/faster_rcnn_R_50_FPN_1x.yaml \
    --eval-only MODEL.WEIGHTS /workspace/models/pre-trained/COCO-Detection/faster_rcnn_R_50_FPN_1x/137257794/model_final_b275ba.pkl
echo "[MS COCO 2017 Validation]: Faster R-CNN DONE."

# use retinanet
# echo "[MS COCO 2017 Validation]: Using RetinaNet..."
# python /workspace/detectron2/tools/train_net.py \
#     --config-file /workspace/detectron2/configs/COCO-Detection/retinanet_R_50_FPN_1x.yaml \
#     --eval-only MODEL.WEIGHTS /workspace/models/pre-trained/COCO-Detection/retinanet_R_50_FPN_1x/190397773/model_final_bfca0b.pkl
# echo "[MS COCO 2017 Validation]: RetinaNet DONE."