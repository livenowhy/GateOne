all: deploy

# 生成镜像
TAG = latest
PREFIX = index.boxlinker.com
IMAGE_NAME = liuzhangpei/gateone

GATEONE = gateone

gitpush:
	git add -A
	git commit -a -m "...."
	git push origin develop


gitmaster:
	git checkout master
	git merge develop
	git push origin master
	git checkout develop

gitpull:
	git pull origin develop


build:
	docker build -t ${PREFIX}/${IMAGE_NAME}:${TAG} .


push: container
	docker push ${PREFIX}/${IMAGE_NAME}:${TAG}


run: build
	docker stop ${GATEONE} || true
	docker rm -f ${GATEONE} || true
	docker run -d -p 4433:8000 --name=${GATEONE} ${PREFIX}/${IMAGE_NAME}:${TAG}


restart: gitpull build
	docker stop ${GATEONE} || true
	docker rm -f ${GATEONE} || true
	docker run -d -p 4433:8000 --name=${GATEONE} ${PREFIX}/${IMAGE_NAME}:${TAG}


logs:
	docker logs -f ${GATEONE}