all: deploy

# 生成镜像
TAG = latest
PREFIX = index.boxlinker.com
IMAGE_NAME = liuzhangpei/gateone

GATEONE = gateone

git:
	git add -A
	git commit -a -m "...."
	git push origin develop

gitpull:
	git pull origin develop


container:
	docker build -t ${PREFIX}/${IMAGE_NAME}:${TAG} .


push: container
	docker push ${PREFIX}/${IMAGE_NAME}:${TAG}


run:
	docker stop ${GATEONE} || true
	docker rm -f ${GATEONE} || true
	docker run -d -p 4433:8000 --name=${GATEONE} ${PREFIX}/${IMAGE_NAME}:${TAG}
